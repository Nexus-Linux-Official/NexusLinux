# calamares-settings-online-merge Skill

**Category:** calamares
**Trigger:** `calamares-settings-online-merge`
**File:** `.claude/SKILLS/calamares-settings-online-merge/calamares-settings-online-merge.md:1`

## Description
This skill `calamares-settings-online-merge` provides line-by-line debug and fix.

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
User: "calamares-settings-online-merge"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
