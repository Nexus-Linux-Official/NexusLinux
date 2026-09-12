# git-log-oneline Skill

**Category:** git
**Trigger:** `git-log-oneline`
**File:** `.claude/SKILLS/git-log-oneline/git-log-oneline.md:1`

## Description
This skill `git-log-oneline` provides line-by-line debug and fix.

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
User: "git-log-oneline"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
