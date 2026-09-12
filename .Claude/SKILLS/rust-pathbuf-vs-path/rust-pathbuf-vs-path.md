# rust-pathbuf-vs-path Skill

**Category:** rust
**Trigger:** `rust-pathbuf-vs-path`
**File:** `.claude/SKILLS/rust-pathbuf-vs-path/rust-pathbuf-vs-path.md:1`

## Description
This skill `rust-pathbuf-vs-path` provides line-by-line debug and fix.

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
User: "rust-pathbuf-vs-path"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
