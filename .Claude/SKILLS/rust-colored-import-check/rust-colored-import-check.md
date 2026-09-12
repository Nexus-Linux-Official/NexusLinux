# rust-colored-import-check Skill

**Category:** rust
**Trigger:** `rust-colored-import-check`
**File:** `.claude/SKILLS/rust-colored-import-check/rust-colored-import-check.md:1`

## Description
This skill `rust-colored-import-check` provides line-by-line debug and fix.

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
User: "rust-colored-import-check"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
