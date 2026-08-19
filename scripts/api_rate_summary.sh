#!/usr/bin/env bash
# Parses a Terraform DEBUG log and reports API call counts per endpoint prefix per minute.
# Appends a collapsible summary block to $GITHUB_STEP_SUMMARY (if set), or prints to stdout.
#
# Usage: api_rate_summary.sh <log_file> [env_name]

set -euo pipefail

LOG_FILE="${1:-/tmp/tf-debug.log}"
ENV_NAME="${2:-unknown}"
SUMMARY_FILE="${GITHUB_STEP_SUMMARY:-}"

# gawk supports 3-arg match(); BSD awk (macOS) requires POSIX fallback
AWK_BIN=$(command -v gawk 2>/dev/null || echo awk)

if [ ! -f "$LOG_FILE" ]; then
  echo "No debug log found at $LOG_FILE — skipping API rate summary."
  exit 0
fi

TABLE=$(
  grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}[^(]*(GET|POST|PUT|DELETE|PATCH) https?://[^/]*\.luna\.akamaiapis\.net(/[^/?[:space:]]*)' "$LOG_FILE" \
    | $AWK_BIN '
      {
        timestamp = substr($0, 1, 16)
        endpoint = ""
        for (i = 1; i <= NF; i++) {
          if ($i ~ /^https?:\/\/[^\/]*\.luna\.akamaiapis\.net\//) {
            path = $i
            sub(/^https?:\/\/[^\/]*\.luna\.akamaiapis\.net/, "", path)
            match(path, /\/[^\/\/?[:space:]]+/)
            if (RSTART > 0) endpoint = substr(path, RSTART, RLENGTH)
            break
          }
        }
        if (endpoint != "") counts[timestamp "|" endpoint]++
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