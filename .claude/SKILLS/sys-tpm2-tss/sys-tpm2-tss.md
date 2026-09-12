# sys-tpm2-tss Skill

**Category:** sys
**Trigger:** `sys-tpm2-tss`
**File:** `.claude/SKILLS/sys-tpm2-tss/sys-tpm2-tss.md:1`

## Description
This skill `sys-tpm2-tss` provides line-by-line debug and fix.

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
User: "sys-tpm2-tss"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
