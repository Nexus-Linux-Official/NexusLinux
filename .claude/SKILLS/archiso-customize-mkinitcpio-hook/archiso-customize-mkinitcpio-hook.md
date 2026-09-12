# archiso-customize-mkinitcpio-hook Skill

**Category:** archiso
**Trigger:** `archiso-customize-mkinitcpio-hook`
**File:** `.claude/SKILLS/archiso-customize-mkinitcpio-hook/archiso-customize-mkinitcpio-hook.md:1`

## Description
This skill `archiso-customize-mkinitcpio-hook` provides line-by-line debug and fix.

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
User: "archiso-customize-mkinitcpio-hook"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
