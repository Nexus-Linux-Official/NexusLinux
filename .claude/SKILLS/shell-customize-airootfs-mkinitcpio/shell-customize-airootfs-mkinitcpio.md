# shell-customize-airootfs-mkinitcpio Skill

**Category:** shell
**Trigger:** `shell-customize-airootfs-mkinitcpio`
**File:** `.claude/SKILLS/shell-customize-airootfs-mkinitcpio/shell-customize-airootfs-mkinitcpio.md:1`

## Description
This skill `shell-customize-airootfs-mkinitcpio` provides line-by-line debug and fix.

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
User: "shell-customize-airootfs-mkinitcpio"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
