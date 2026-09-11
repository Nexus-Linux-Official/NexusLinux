# pkgbuild-install-license Skill

**Kategori:** pkgbuild
**Tetikleyici:** `pkgbuild-install-license`
**Dosya:** `.claude/SKILLS/pkgbuild-install-license/pkgbuild-install-license.md:1`

## Açıklama
Bu skill `pkgbuild-install-license` için satır satır debug ve fix sağlar.

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
Kullanıcı: "pkgbuild-install-license"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
