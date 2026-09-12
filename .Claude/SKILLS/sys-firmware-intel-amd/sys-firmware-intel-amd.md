# sys-firmware-intel-amd Skill

**Category:** sys
**Trigger:** `sys-firmware-intel-amd`
**File:** `.claude/SKILLS/sys-firmware-intel-amd/sys-firmware-intel-amd.md:1`

## Description
This skill `sys-firmware-intel-amd` provides line-by-line debug and fix.

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
User: "sys-firmware-intel-amd"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
