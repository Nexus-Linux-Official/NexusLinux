# rust-clap-derive-audit Skill

**Category:** rust
**Trigger:** `rust-clap-derive-audit`
**File:** `.claude/SKILLS/rust-clap-derive-audit/rust-clap-derive-audit.md:1`

## Description
This skill `rust-clap-derive-audit` provides line-by-line debug and fix.

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
User: "rust-clap-derive-audit"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
