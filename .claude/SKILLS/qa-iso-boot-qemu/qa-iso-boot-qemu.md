# qa-iso-boot-qemu Skill

**Category:** qa
**Trigger:** `qa-iso-boot-qemu`
**File:** `.claude/SKILLS/qa-iso-boot-qemu/qa-iso-boot-qemu.md:1`

## Description
This skill `qa-iso-boot-qemu` provides line-by-line debug and fix.

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
User: "qa-iso-boot-qemu"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
