#!/usr/bin/env bash
# Parses a Terraform DEBUG log and reports API call counts per endpoint prefix per minute.
# Appends a collapsible summary block to $GITHUB_STEP_SUMMARY (if set), or prints to stdout.
#
# Usage: api_rate_summary.sh <log_file> [env_name]

set -euo pipefail

LOG_FILE="${1:-/tmp/tf-debug.log}"
ENV_NAME="${2:-unknown}"
SUMMARY_FILE="${GITHUB_STEP_SUMMARY:-}"

if [ ! -f "$LOG_FILE" ]; then
  echo "No debug log found at $LOG_FILE — skipping API rate summary."
  exit 0
fi

TABLE=$(
  grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}[^(]*(GET|POST|PUT|DELETE|PATCH) https?://[^/]+(/[^/?[:space:]]+)' "$LOG_FILE" \
    | awk '
      {
        match($0, /([0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2})/, t)
        match($0, /(GET|POST|PUT|DELETE|PATCH) https?:\/\/[^\/]+(\/[^\/\/?[:space:]]+)/, u)
        if (t[1] != "" && u[2] != "") counts[t[1] "|" u[2]]++
      }
      END {
        for (k in counts) {
          split(k, a, "|")
          printf "%-16s  %-30s  %d\n", a[1], a[2], counts[k]
        }
      }' \
    | sort
)

OUTPUT=$(
  printf '%-16s  %-30s  %s\n' 'Minute (UTC)' 'Endpoint prefix' 'Calls'
  printf '%-16s  %-30s  %s\n' '----------------' '------------------------------' '-----'
  echo "$TABLE"
)

if [ -n "$SUMMARY_FILE" ]; then
  {
    echo "<details><summary>API Call Rate Summary - ${ENV_NAME}</summary>"
    echo ''
    echo '```'
    echo "$OUTPUT"
    echo '```'
    echo ''
    echo '</details>'
  } >> "$SUMMARY_FILE"
else
  echo "$OUTPUT"
fi
