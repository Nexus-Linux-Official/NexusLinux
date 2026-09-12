# archiso-pxe-boot-test Skill

**Category:** archiso
**Trigger:** `archiso-pxe-boot-test`
**File:** `.claude/SKILLS/archiso-pxe-boot-test/archiso-pxe-boot-test.md:1`

## Description
This skill `archiso-pxe-boot-test` provides line-by-line debug and fix.

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
User: "archiso-pxe-boot-test"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
