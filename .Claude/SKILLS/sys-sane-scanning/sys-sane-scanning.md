# sys-sane-scanning Skill

**Category:** sys
**Trigger:** `sys-sane-scanning`
**File:** `.claude/SKILLS/sys-sane-scanning/sys-sane-scanning.md:1`

## Description
This skill `sys-sane-scanning` provides line-by-line debug and fix.

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
User: "sys-sane-scanning"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
