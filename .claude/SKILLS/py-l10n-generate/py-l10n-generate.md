# py-l10n-generate Skill

**Category:** py
**Trigger:** `py-l10n-generate`
**File:** `.claude/SKILLS/py-l10n-generate/py-l10n-generate.md:1`

## Description
This skill `py-l10n-generate` provides line-by-line debug and fix.

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
User: "py-l10n-generate"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
