# archiso-iso-size-estimate Skill

**Category:** archiso
**Trigger:** `archiso-iso-size-estimate`
**File:** `.claude/SKILLS/archiso-iso-size-estimate/archiso-iso-size-estimate.md:1`

## Description
This skill `archiso-iso-size-estimate` provides line-by-line debug and fix.

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
User: "archiso-iso-size-estimate"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
