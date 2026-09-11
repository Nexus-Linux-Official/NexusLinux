# pkgbuild-source-lint Skill

**Kategori:** pkgbuild
**Tetikleyici:** `pkgbuild-source-lint`
**Dosya:** `.claude/SKILLS/pkgbuild-source-lint/pkgbuild-source-lint.md:1`

## Açıklama
Bu skill `pkgbuild-source-lint` için satır satır debug ve fix sağlar.

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
Kullanıcı: "pkgbuild-source-lint"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
