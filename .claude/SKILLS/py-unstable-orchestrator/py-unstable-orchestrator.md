# py-unstable-orchestrator Skill

**Category:** py
**Trigger:** `py-unstable-orchestrator`
**File:** `.claude/SKILLS/py-unstable-orchestrator/py-unstable-orchestrator.md:1`

## Description
This skill `py-unstable-orchestrator` provides line-by-line debug and fix.

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
User: "py-unstable-orchestrator"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
