# archiso-customize-airootfs-lint Skill

**Category:** archiso
**Trigger:** `archiso-customize-airootfs-lint`
**File:** `.claude/SKILLS/archiso-customize-airootfs-lint/archiso-customize-airootfs-lint.md:1`

## Description
This skill `archiso-customize-airootfs-lint` provides line-by-line debug and fix.

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
User: "archiso-customize-airootfs-lint"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
