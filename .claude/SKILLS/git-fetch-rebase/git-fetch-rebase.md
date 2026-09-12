# git-fetch-rebase Skill

**Category:** git
**Trigger:** `git-fetch-rebase`
**File:** `.claude/SKILLS/git-fetch-rebase/git-fetch-rebase.md:1`

## Description
This skill `git-fetch-rebase` provides line-by-line debug and fix.

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
User: "git-fetch-rebase"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
