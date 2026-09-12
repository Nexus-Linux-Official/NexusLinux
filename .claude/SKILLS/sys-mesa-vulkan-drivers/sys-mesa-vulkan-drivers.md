# sys-mesa-vulkan-drivers Skill

**Category:** sys
**Trigger:** `sys-mesa-vulkan-drivers`
**File:** `.claude/SKILLS/sys-mesa-vulkan-drivers/sys-mesa-vulkan-drivers.md:1`

## Description
This skill `sys-mesa-vulkan-drivers` provides line-by-line debug and fix.

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
User: "sys-mesa-vulkan-drivers"
```

---
*Auto-generated — conforms to `README.md:1` structure.*
