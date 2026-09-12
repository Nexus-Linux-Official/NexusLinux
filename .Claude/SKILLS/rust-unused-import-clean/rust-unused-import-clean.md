# rust-unused-import-clean Skill

**Category:** rust
**Trigger:** `rust-unused-import-clean`
**File:** `.claude/SKILLS/rust-unused-import-clean/rust-unused-import-clean.md:1`

## Description
This skill `rust-unused-import-clean` provides line-by-line debug and fix.

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
User: "rust-unused-import-clean"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
