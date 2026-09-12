# Nexus Live SKILLS Directory

This directory contains 210+ skills for Muse / Codex. Each skill is defined in its own folder as `<skill-name>/<skill-name>.md`.

## Structure
```
.claude/SKILLS/
├── README.md
├── archiso-profile-validate/archiso-profile-validate.md
├── archiso-pacman-conf-audit/archiso-pacman-conf-audit.md
├── ...
└── meta-issue-txt-tracker/meta-issue-txt-tracker.md
```

## Categories (10)
1. **ARCHISO & ISO BUILD** (30) — `archiso/*`
2. **CALAMARES** (25) — `calamares/*`
3. **RUST WORKSPACE** (30) — `rust/*`
4. **PKGBUILD** (25) — `pkgbuild/*`
5. **SHELL & BUILD** (25) — `shell/*`
6. **GIT & GITHUB** (15) — `git/*`
7. **SYSTEM** (20) — `sys/*`
8. **QA & TEST** (15) — `qa/*`
9. **PYTHON** (15) — `py/*`
10. **META & DOC** (10) — `meta/*`

## Usage
- Trigger: when `archiso-profile-validate` is invoked, `archiso/profiledef.sh:1-39` is checked line by line.
- Each `.md` file contains: description, trigger, file:line references, fix steps.
- Example: template at `.claude/SKILLS/example/example.md` below.

## Example Skill Template
See: `example/example.md`

## Total
210 skills — defined as hundreds, each as an isolated `.md` file.
