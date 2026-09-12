# meta-github-issues-sync Skill

**Category:** meta
**Trigger:** `meta-github-issues-sync`
**File:** `.claude/SKILLS/meta-github-issues-sync/meta-github-issues-sync.md:1`

## Description
This skill `meta-github-issues-sync` provides line-by-line debug and fix.

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
User: "meta-github-issues-sync"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
