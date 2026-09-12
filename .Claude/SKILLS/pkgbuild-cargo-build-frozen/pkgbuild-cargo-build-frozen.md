# pkgbuild-cargo-build-frozen Skill

**Category:** pkgbuild
**Trigger:** `pkgbuild-cargo-build-frozen`
**File:** `.claude/SKILLS/pkgbuild-cargo-build-frozen/pkgbuild-cargo-build-frozen.md:1`

## Description
This skill `pkgbuild-cargo-build-frozen` provides line-by-line debug and fix.

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
User: "pkgbuild-cargo-build-frozen"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
