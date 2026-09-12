# pkgbuild-arch-any-vs-x86_64 Skill

**Category:** pkgbuild
**Trigger:** `pkgbuild-arch-any-vs-x86_64`
**File:** `.claude/SKILLS/pkgbuild-arch-any-vs-x86_64/pkgbuild-arch-any-vs-x86_64.md:1`

## Description
This skill `pkgbuild-arch-any-vs-x86_64` provides line-by-line debug and fix.

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
User: "pkgbuild-arch-any-vs-x86_64"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
