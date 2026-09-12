# pkgbuild-install-license Skill

**Category:** pkgbuild
**Trigger:** `pkgbuild-install-license`
**File:** `.claude/SKILLS/pkgbuild-install-license/pkgbuild-install-license.md:1`

## Description
This skill `pkgbuild-install-license` provides line-by-line debug and fix.

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
User: "pkgbuild-install-license"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
