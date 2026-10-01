#!/usr/bin/env bash
#
# Apply The Digital Office repository baseline settings to a repository.
#
# A template repository copies files only. Branch rules, merge settings and
# security settings are not copied, so an organisation owner runs this once
# for each new repository, and again if the baseline changes. It is safe to
# re-run.
#
# Usage:
#   scripts/apply-baseline.sh <repository> [--dry-run]
#
#   <repository>  name in The-Digital-Office, e.g. "my-service",
#                 or a full "owner/name".
#
# Requirements: GitHub CLI (gh) signed in as an organisation owner or a
# repository admin, and jq.
#
# On the GitHub Free plan, branch rulesets, secret scanning and private
# vulnerability reporting are only available for public repositories. For
# private repositories this script applies the rest and says what it skipped.

set -euo pipefail

ORG="The-Digital-Office"
RULESET_NAME="Digital Office baseline: main"

usage() {
  sed -n '3,22p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

[[ $# -ge 1 ]] || usage 1
[[ $1 == "-h" || $1 == "--help" ]] && usage 0

repo=$1
[[ $repo == */* ]] || repo="$ORG/$repo"
dry_run=false
[[ ${2:-} == "--dry-run" ]] && dry_run=true

for cmd in gh jq; do
  command -v "$cmd" > /dev/null || { echo "error: $cmd is required" >&2; exit 1; }
done

say() { printf '%s\n' "$*"; }
step() { printf '\n== %s\n' "$*"; }

# api <method> <path> [gh api args...]: call the API, or print it in dry-run mode.
api() {
  local method=$1 path=$2; shift 2
  if $dry_run; then
    say "[dry run] $method $path $*"
    return 0
  fi
  gh api --method "$method" -H "X-GitHub-Api-Version: 2022-11-28" "$path" "$@"
}

info=$(gh api "repos/$repo") || { echo "error: cannot read $repo (check the name and your access)" >&2; exit 1; }
visibility=$(jq -r .visibility <<< "$info")
default_branch=$(jq -r .default_branch <<< "$info")
is_public=false
[[ $visibility == "public" ]] && is_public=true

say "Repository:     $repo"
say "Visibility:     $visibility"
say "Default branch: $default_branch"
$dry_run && say "Mode:           dry run (no changes will be made)"

step "Merge and housekeeping settings"
# Squash merge only, with the pull request title as the commit title, and
# head branches deleted after merge to match the branch-per-change workflow.
api PATCH "repos/$repo" --silent \
  -F allow_squash_merge=true \
  -F allow_merge_commit=false \
  -F allow_rebase_merge=false \
  -F allow_auto_merge=false \
  -F allow_update_branch=true \
  -F delete_branch_on_merge=true \
  -f squash_merge_commit_title=PR_TITLE \
  -f squash_merge_commit_message=PR_BODY \
  -F has_wiki=false \
  -F has_projects=false
say "Squash merge only; head branches deleted after merge; wiki and projects off."

step "Dependabot"
api PUT "repos/$repo/vulnerability-alerts" --silent
api PUT "repos/$repo/automated-security-fixes" --silent
say "Dependabot alerts and security updates enabled."

step "Secret scanning and private vulnerability reporting"
if $is_public; then
  api PATCH "repos/$repo" --silent --input - <<'JSON'
{
  "security_and_analysis": {
    "secret_scanning": { "status": "enabled" },
    "secret_scanning_push_protection": { "status": "enabled" }
  }
}
JSON
  api PUT "repos/$repo/private-vulnerability-reporting" --silent
  say "Secret scanning with push protection, and private vulnerability reporting, enabled."
else
  say "Skipped: not available for private repositories on the GitHub Free plan."
fi

step "Branch ruleset for $default_branch"
if $is_public; then
  # Pull request required with no required approvals (most repositories have a
  # single maintainer, who cannot approve their own pull request). Standards
  # checks must pass on an up-to-date branch. No force-pushes or deletion.
  # Repository admins (which includes organisation owners) may bypass when
  # merging a pull request, for emergencies; they cannot push directly.
  ruleset=$(jq -n --arg name "$RULESET_NAME" '{
    name: $name,
    target: "branch",
    enforcement: "active",
    conditions: { ref_name: { include: ["~DEFAULT_BRANCH"], exclude: [] } },
    bypass_actors: [
      { actor_id: 5, actor_type: "RepositoryRole", bypass_mode: "pull_request" }
    ],
    rules: [
      { type: "deletion" },
      { type: "non_fast_forward" },
      { type: "pull_request", parameters: {
          required_approving_review_count: 0,
          dismiss_stale_reviews_on_push: false,
          require_code_owner_review: false,
          require_last_push_approval: false,
          required_review_thread_resolution: false,
          allowed_merge_methods: ["squash"]
      } },
      { type: "required_status_checks", parameters: {
          strict_required_status_checks_policy: true,
          do_not_enforce_on_create: false,
          required_status_checks: [
            { context: "standards / Required files" },
            { context: "standards / publiccode.yml" }
          ]
      } }
    ]
  }')

  existing=$(gh api "repos/$repo/rulesets" --jq ".[] | select(.name == \"$RULESET_NAME\") | .id" || true)
  if [[ -n $existing ]]; then
    api PUT "repos/$repo/rulesets/$existing" --silent --input - <<< "$ruleset"
    say "Updated existing ruleset (id $existing)."
  else
    api POST "repos/$repo/rulesets" --silent --input - <<< "$ruleset"
    say "Created ruleset '$RULESET_NAME'."
  fi
else
  say "Skipped: branch rulesets are not available for private repositories on the GitHub Free plan."
  say "Follow the branch-and-pull-request workflow by convention until the repository is made public."
fi

step "Labels"
# name|colour|description. Existing labels are updated, others are left alone.
labels=(
  "bug|d73a4a|Something is not working"
  "enhancement|a2eeef|New feature or improvement"
  "documentation|0075ca|Documentation only"
  "dependencies|0366d6|Dependency updates"
  "security|b60205|Security-related change"
  "good first issue|7057ff|Suitable for a first contribution"
  "question|d876e3|Further information is requested"
  "wontfix|ffffff|Will not be worked on"
)
for entry in "${labels[@]}"; do
  IFS='|' read -r name colour description <<< "$entry"
  if $dry_run; then
    say "[dry run] label: $name"
  else
    gh label create "$name" --repo "$repo" --color "$colour" --description "$description" --force > /dev/null
  fi
done
say "Standard labels in place."

step "Done"
if $is_public; then
  say "Reminder: if this public repository is documentation rather than software,"
  say "add the 'documentation' topic so publiccode.yml is not required:"
  say "  gh repo edit $repo --add-topic documentation"
fi
