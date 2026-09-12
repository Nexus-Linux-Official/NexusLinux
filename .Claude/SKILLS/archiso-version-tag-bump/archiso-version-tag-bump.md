# archiso-version-tag-bump Skill

**Category:** archiso
**Trigger:** `archiso-version-tag-bump`
**File:** `.claude/SKILLS/archiso-version-tag-bump/archiso-version-tag-bump.md:1`

## Description
This skill `archiso-version-tag-bump` provides line-by-line debug and fix.

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
User: "archiso-version-tag-bump"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
