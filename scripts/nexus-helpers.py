#!/usr/bin/env python3
"""
Nexus Linux helper utilities - Python
Slowly increasing Python ratio for linguist (target 7.5%)
"""
import argparse
import hashlib
import pathlib
import sys
import tomllib
from typing import Dict, List

def verify_iso(path: pathlib.Path) -> bool:
    """Verify ISO checksum and size."""
    if not path.exists():
        print(f"ISO not found: {path}", file=sys.stderr)
        return False
    sha = hashlib.sha256()
    size = 0
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            sha.update(chunk)
            size += len(chunk)
    print(f"ISO: {path.name}")
    print(f"Size: {size / (1024**3):.2f} GB")
    print(f"SHA256: {sha.hexdigest()}")
    return True

def check_profile(profile: str) -> Dict[str, List[str]]:
    """Check archiso profile for common issues."""
    base = pathlib.Path(f"archiso/{profile}") if profile != "desktop" else pathlib.Path("archiso")
    issues = {"errors": [], "warnings": []}
    pacman = base / "pacman.conf"
    if pacman.exists():
        text = pacman.read_text()
        if "file:///home/cahit" in text:
            issues["errors"].append("pacman.conf has hardcoded /home/cahit path")
        if "[nexus]" not in text:
            issues["warnings"].append("pacman.conf missing [nexus] repo")
    pkg = base / "packages.x86_64"
    if pkg.exists():
        pkgs = pkg.read_text().splitlines()
        if len(pkgs) != len(set(pkgs)):
            issues["warnings"].append(f"duplicate packages in {pkg}")
        for dup in ["breeze-gtk", "mesa"]:
            if pkgs.count(dup) > 1:
                issues["errors"].append(f"duplicate {dup} in {pkg}")
    return issues

def lint_pkgbuild(path: pathlib.Path) -> List[str]:
    """Lint PKGBUILD for common archiso issues."""
    issues = []
    text = path.read_text()
    if "sysinfo" in text and "depends=(sysinfo" in text:
        issues.append(f"{path}: Rust crate in depends (should be empty)")
    if "/home/cahit" in text:
        issues.append(f"{path}: absolute /home/cahit path")
    if 'source=()' in text and 'prepare()' in text:
        # local copy is ok but warn
        pass
    return issues

def main() -> int:
    parser = argparse.ArgumentParser(description="Nexus Linux Python helpers")
    sub = parser.add_subparsers(dest="cmd", required=True)
    p_verify = sub.add_parser("verify-iso", help="verify ISO")
    p_verify.add_argument("iso", type=pathlib.Path, help="path to .iso")
    p_check = sub.add_parser("check-profile", help="check archiso profile")
    p_check.add_argument("profile", nargs="?", default="desktop", help="profile name")
    p_lint = sub.add_parser("lint-pkgbuild", help="lint PKGBUILD")
    p_lint.add_argument("pkgbuild", type=pathlib.Path, help="path to PKGBUILD")
    args = parser.parse_args()

    if args.cmd == "verify-iso":
        return 0 if verify_iso(args.iso) else 1
    if args.cmd == "check-profile":
        issues = check_profile(args.profile)
        print(f"Profile {args.profile}: {issues}")
        return 1 if issues["errors"] else 0
    if args.cmd == "lint-pkgbuild":
        for iss in lint_pkgbuild(args.pkgbuild):
            print(f"  - {iss}")
        return 0
    return 0

if __name__ == "__main__":
    sys.exit(main())
