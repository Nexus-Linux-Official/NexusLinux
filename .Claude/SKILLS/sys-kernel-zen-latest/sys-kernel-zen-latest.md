# sys-kernel-zen-latest Skill

**Category:** sys
**Trigger:** `sys-kernel-zen-latest`
**File:** `.claude/SKILLS/sys-kernel-zen-latest/sys-kernel-zen-latest.md:1`

## Description
This skill `sys-kernel-zen-latest` provides line-by-line debug and fix.

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
User: "sys-kernel-zen-latest"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
