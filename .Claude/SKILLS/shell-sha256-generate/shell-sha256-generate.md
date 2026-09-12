# shell-sha256-generate Skill

**Category:** shell
**Trigger:** `shell-sha256-generate`
**File:** `.claude/SKILLS/shell-sha256-generate/shell-sha256-generate.md:1`

## Description
This skill `shell-sha256-generate` provides line-by-line debug and fix.

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
User: "shell-sha256-generate"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
