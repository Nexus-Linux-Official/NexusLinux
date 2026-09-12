# sys-memtest-efi Skill

**Category:** sys
**Trigger:** `sys-memtest-efi`
**File:** `.claude/SKILLS/sys-memtest-efi/sys-memtest-efi.md:1`

## Description
This skill `sys-memtest-efi` provides line-by-line debug and fix.

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
User: "sys-memtest-efi"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
