# archiso-mkinitcpio-preset-check Skill

**Category:** archiso
**Trigger:** `archiso-mkinitcpio-preset-check`
**File:** `.claude/SKILLS/archiso-mkinitcpio-preset-check/archiso-mkinitcpio-preset-check.md:1`

## Description
This skill `archiso-mkinitcpio-preset-check` provides line-by-line debug and fix.

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
User: "archiso-mkinitcpio-preset-check"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
