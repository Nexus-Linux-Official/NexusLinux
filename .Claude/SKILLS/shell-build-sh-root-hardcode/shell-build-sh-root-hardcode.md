# shell-build-sh-root-hardcode Skill

**Category:** shell
**Trigger:** `shell-build-sh-root-hardcode`
**File:** `.claude/SKILLS/shell-build-sh-root-hardcode/shell-build-sh-root-hardcode.md:1`

## Description
This skill `shell-build-sh-root-hardcode` provides line-by-line debug and fix.

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
User: "shell-build-sh-root-hardcode"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
