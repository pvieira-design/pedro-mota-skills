#!/usr/bin/env bash
set -euo pipefail

user_root="${HOME}/.agents/skills"
project_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
project_skills="${project_root}/.agents/skills"

printf 'Canonical user skills: %s\n' "$user_root"
printf 'Project skills:        %s\n\n' "$project_skills"

if [[ ! -d "$user_root" ]]; then
  printf 'WARN: user skill directory does not exist.\n'
fi

if [[ ! -d "$project_skills" ]]; then
  printf 'OK: no project .agents/skills directory; no user/project overlap.\n'
  exit 0
fi

overlap=0
different=0

while IFS= read -r project_skill; do
  name="$(basename "$project_skill")"
  user_skill="${user_root}/${name}"
  [[ -d "$user_skill" ]] || continue

  overlap=$((overlap + 1))
  if diff -qr "$project_skill" "$user_skill" >/dev/null; then
    printf 'DUPLICATE identical: %s\n' "$name"
  else
    different=$((different + 1))
    printf 'CONFLICT different:   %s\n' "$name"
  fi
done < <(find "$project_skills" -mindepth 1 -maxdepth 1 -type d -print | sort)

printf '\n'
if [[ "$overlap" -eq 0 ]]; then
  printf 'OK: no same-named user/project skills found.\n'
  exit 0
fi

printf 'Found %d same-named skill(s) in user and project scopes.\n' "$overlap"
if [[ "$different" -gt 0 ]]; then
  printf 'Do not remove conflicts until their project-specific changes are reviewed.\n'
fi
printf 'Choose one scope per skill name. Re-run the audit after cleanup.\n'
exit 1
