[![Akamai Property Manager](https://github.com/jaescalo/akamai-pm-tf-multiple-env-workflow/actions/workflows/akamai_pm.yaml/badge.svg)](https://github.com/jaescalo/akamai-pm-tf-multiple-env-workflow/actions/workflows/akamai_pm.yaml)

# Akamai Property Manager — Multi-Environment

This repository automates the management (and onboarding) of multiple Akamai Property Manager properties using [Terraform](https://techdocs.akamai.com/terraform/docs) and GitHub Actions. Each environment (e.g. `app1`, `app2`) maps to a folder under `environments/` and maintains its own isolated Terraform state file.

* GitHub Actions drives the workflow with two triggers: automatic (push) and manual (workflow_dispatch).
* Parallel Terraform runs per environment using a dynamic GitHub Actions matrix.
* Terraform state is stored remotely in Linode Object Storage (S3 compatible), one state file per environment.
* The Terraform plan output is posted to the GitHub Actions run summary for review before applying.

## Repository Structure

```
.
├── environments/
│   ├── app1/
│   │   └── terraform.tfvars      # Environment-specific variables
│   └── app2/
│       └── terraform.tfvars
├── modules/
│   └── property/
│       ├── property.tf
│       ├── variables.tf
│       └── rules/                # Shared Akamai rule tree (applied to all environments)
├── main.tf
├── variables.tf
├── provider.tf
├── versions.tf
├── import.tf
└── import.sh
```

## Prerequisites
- [Akamai API Credentials](https://techdocs.akamai.com/developer/docs/set-up-authentication-credentials)
- [Akamai Terraform Provider](https://techdocs.akamai.com/terraform/docs)
- Basic understanding of [GitHub Actions](https://docs.github.com/en/actions) and [repository secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Linode Object Storage](https://www.linode.com/lp/object-storage/) bucket with access keys for Terraform remote state

## Prepare Properties for Akamai as Code

* Base the code on a production property (e.g. `www.example.com`, not `qa.example.com`)
* Optionally clean up the configuration: remove duplicated rules/behaviors, parameterize matches, etc.
* Convert all advanced rules and matches to [Akamai Custom Behaviors](https://techdocs.akamai.com/property-mgr/reference/custom-behaviors-and-overrides) or standard Property Manager behaviors where possible.
* Freeze the rule tree to a specific catalog version to avoid future breaking changes.
* Treat this repository as the single source of truth — avoid out-of-band changes in the Akamai UI.

## Linode Object Storage — Terraform Remote Backend

Each environment gets its own state file keyed as `<environment>-terraform.tfstate` in the same bucket. This provides full state isolation between environments. Any other S3-compatible backend can be substituted by updating the backend configuration in the workflow.

## GitHub Secrets Setup

Configure the following secrets in **Settings → Secrets and variables → Actions**:

**Akamai API credentials:**
| Secret | Description |
|---|---|
| `AKAMAI_CREDENTIAL_CLIENT_SECRET` | Akamai `client_secret` |
| `AKAMAI_CREDENTIAL_HOST` | Akamai `host` |
| `AKAMAI_CREDENTIAL_ACCESS_TOKEN` | Akamai `access_token` |
| `AKAMAI_CREDENTIAL_CLIENT_TOKEN` | Akamai `client_token` |
| `AKAMAI_ACCOUNT_KEY` | Account switch key (optional) |

**Linode Object Storage:**
| Secret | Description |
|---|---|
| `LINODE_OBJECT_STORAGE_BUCKET` | Bucket name |
| `LINODE_OBJECT_STORAGE_ACCESS_KEY` | Access key |
| `LINODE_OBJECT_STORAGE_SECRET_KEY` | Secret key |

## Workflow Triggers

### Automatic — push to `main`
The workflow fires automatically when a push to `main` modifies files under `environments/**` or `modules/property/rules/**`.

- **Environment changes** (`environments/<name>/**`): only the affected environment(s) are deployed, detected via `git diff`.
- **Rules changes** (`modules/property/rules/**`): all environments are deployed automatically, since rule tree changes apply globally.

### Manual — `workflow_dispatch`
Trigger the workflow manually from the **Actions** tab. The `environment` input accepts:

- A single environment name: `app1`
- A comma-separated list: `app1,app2`
- The keyword `all` (case-insensitive) to target every environment folder

The setup job validates all provided names against the `environments/` directory and fails early with a clear error listing available environments if any name is invalid.

## Workflow Jobs

```
setup  →  create-property (parallel, one job per environment)
```

1. **setup** — builds and validates the dynamic environment matrix, then outputs it for the next job.
2. **create-property** — runs once per environment in parallel (`fail-fast: false`):
   - Posts the environment name, triggered by, and commit SHA to the run summary
   - Initializes Terraform with the environment-scoped remote backend
   - Validates the Terraform configuration
   - Generates a plan and posts the human-readable output to the run summaryß
   - Uploads the plan JSON as a named artifact (`Terraform Plan - <environment>`)
   - Apply is commented out by default — uncomment to enable automated applies

## Adding a New Environment

1. Create a new folder under `environments/` matching the environment name (e.g. `environments/app3/`).
2. Add a `terraform.tfvars` file with the required variables.
3. Commit and push to `main` — the workflow will automatically detect the new folder and run Terraform for it.

## Import Existing Property

To bring an existing Akamai property under Terraform management, run the `import.sh` script on the first deployment to generate the initial Terraform state. The corresponding step in `.github/workflows/akamai_pm.yaml` is commented out and should be uncommented only for that initial run, then commented out again.

## Resources
- [Akamai API Credentials](https://techdocs.akamai.com/developer/docs/set-up-authentication-credentials)
- [Akamai Terraform Provider](https://techdocs.akamai.com/terraform/docs)
- [Akamai CLI for Terraform](https://github.com/akamai/cli-terraform)
- [Linode Object Storage](https://www.linode.com/lp/object-storage/)
- [Akamai Developer YouTube Channel](https://www.youtube.com/c/AkamaiDeveloper)
- [Akamai GitHub](https://github.com/akamai)
