# qa-cargo-clippy-pedantic Skill

**Category:** qa
**Trigger:** `qa-cargo-clippy-pedantic`
**File:** `.claude/SKILLS/qa-cargo-clippy-pedantic/qa-cargo-clippy-pedantic.md:1`

## Description
This skill `qa-cargo-clippy-pedantic` provides line-by-line debug and fix.

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
User: "qa-cargo-clippy-pedantic"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
