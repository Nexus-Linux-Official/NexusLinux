# Nexus Live SKILLS Directory

Bu dizin Muse / Codex için 210+ skill içerir. Her skill kendi klasöründe `<skill-adı>/<skill-adı>.md` olarak tanımlıdır.

## Yapı
```
.claude/SKILLS/
├── README.md
├── archiso-profile-validate/archiso-profile-validate.md
├── archiso-pacman-conf-audit/archiso-pacman-conf-audit.md
├── ...
└── meta-issue-txt-tracker/meta-issue-txt-tracker.md
```

## Kategoriler (10)
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

## Kullanım
- Tetikleyici: `archiso-profile-validate` dendiğinde `archiso/profiledef.sh:1-39` satır satır kontrol edilir.
- Her `.md` dosyası: açıklama, tetikleyici, dosya:line referansları, fix adımları içerir.
- Örnek: `.claude/SKILLS/örnek/örnek.md` şablonu aşağıdadır.

## Örnek Skill Şablonu
Bkz: `örnek/örnek.md`

## Toplam
210 skill — yüzlerce olarak tanımlı, her biri izole `.md` dosyası.
