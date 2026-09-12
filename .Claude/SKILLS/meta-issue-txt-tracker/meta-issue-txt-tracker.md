# meta-issue-txt-tracker Skill

**Category:** meta
**Trigger:** `meta-issue-txt-tracker`
**File:** `.claude/SKILLS/meta-issue-txt-tracker/meta-issue-txt-tracker.md:1`

## Description
This skill `meta-issue-txt-tracker` provides line-by-line debug and fix.

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
User: "meta-issue-txt-tracker"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
