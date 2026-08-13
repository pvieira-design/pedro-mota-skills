#!/usr/bin/env bash
set -euo pipefail

pedro_ref="${1:-}"

if [[ ! "$pedro_ref" =~ ^[0-9a-f]{40}$ ]]; then
  printf 'Usage: %s <40-character pedro-mota-skills commit SHA>\n' "$0" >&2
  exit 2
fi

matt_skills=(
  ask-matt
  codebase-design
  diagnosing-bugs
  domain-modeling
  grill-me
  grill-with-docs
  grilling
  handoff
  implement
  improve-codebase-architecture
  prototype
  research
  resolving-merge-conflicts
  setup-matt-pocock-skills
  tdd
  teach
  to-questionnaire
  to-spec
  to-tickets
  triage
  wait-what
  wayfinder
  wizard
  writing-for-agents
)

pedro_overlay=(
  code-review
  grill-with-docs
  handoff
  implement
  improve-codebase-architecture
  research
  setup-matt-pocock-skills
  setup-pedro-mota
  sync-doc
  to-pending
  to-spec
  to-tickets
  wayfinder
)

npx skills add mattpocock/skills@v1.2.3 \
  --global \
  --agent codex claude-code \
  --skill "${matt_skills[@]}" \
  --yes

npx skills add "pvieira-design/pedro-mota-skills@${pedro_ref}" \
  --global \
  --agent codex claude-code \
  --skill "${pedro_overlay[@]}" \
  --yes

npx skills list --global --json
