# shell-version-bump-automate Skill

**Category:** shell
**Trigger:** `shell-version-bump-automate`
**File:** `.claude/SKILLS/shell-version-bump-automate/shell-version-bump-automate.md:1`

## Description
This skill `shell-version-bump-automate` provides line-by-line debug and fix.

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
User: "shell-version-bump-automate"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
