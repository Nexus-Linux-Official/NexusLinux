# shell-nexus-unstable-pipefail Skill

**Category:** shell
**Trigger:** `shell-nexus-unstable-pipefail`
**File:** `.claude/SKILLS/shell-nexus-unstable-pipefail/shell-nexus-unstable-pipefail.md:1`

## Description
This skill `shell-nexus-unstable-pipefail` provides line-by-line debug and fix.

## Target Files
- Relevant `file:line` references are specific to this skill (see SKILLS list).

## Steps
1. Read the target file with `Read`
2. Identify the error/line to be edited
3. Fix it with `Edit`
4. Verify with `Bash` (cargo check / shellcheck / namcap)
5. If necessary, `git add/commit`

## Example Trigger
```
User: "shell-nexus-unstable-pipefail"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
