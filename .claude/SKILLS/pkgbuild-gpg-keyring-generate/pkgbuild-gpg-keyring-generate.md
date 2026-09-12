# pkgbuild-gpg-keyring-generate Skill

**Category:** pkgbuild
**Trigger:** `pkgbuild-gpg-keyring-generate`
**File:** `.claude/SKILLS/pkgbuild-gpg-keyring-generate/pkgbuild-gpg-keyring-generate.md:1`

## Description
This skill `pkgbuild-gpg-keyring-generate` provides line-by-line debug and fix.

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
User: "pkgbuild-gpg-keyring-generate"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
