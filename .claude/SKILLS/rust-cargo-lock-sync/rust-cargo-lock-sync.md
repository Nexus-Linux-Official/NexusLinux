# rust-cargo-lock-sync Skill

**Category:** rust
**Trigger:** `rust-cargo-lock-sync`
**File:** `.claude/SKILLS/rust-cargo-lock-sync/rust-cargo-lock-sync.md:1`

## Description
This skill `rust-cargo-lock-sync` provides line-by-line debug and fix.

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
User: "rust-cargo-lock-sync"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
