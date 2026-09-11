# pkgbuild-prepare-cp-workspace Skill

**Kategori:** pkgbuild
**Tetikleyici:** `pkgbuild-prepare-cp-workspace`
**Dosya:** `.claude/SKILLS/pkgbuild-prepare-cp-workspace/pkgbuild-prepare-cp-workspace.md:1`

## Açıklama
Bu skill `pkgbuild-prepare-cp-workspace` için satır satır debug ve fix sağlar.

## Hedef Dosyalar
- İlgili `file:line` referansları bu skill'e özeldir (bkz. SKILLS listesi).

## Adımlar
1. `Read` ile hedef dosyayı oku
2. Hata/düzenlenecek satırı tespit et
3. `Edit` ile düzelt
4. `Bash` ile doğrula (cargo check / shellcheck / namcap)
5. Gerekirse `git add/commit`

## Örnek Tetik
```
Kullanıcı: "pkgbuild-prepare-cp-workspace"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
