# pkgbuild-repo-add-force Skill

**Kategori:** pkgbuild
**Tetikleyici:** `pkgbuild-repo-add-force`
**Dosya:** `.claude/SKILLS/pkgbuild-repo-add-force/pkgbuild-repo-add-force.md:1`

## Açıklama
Bu skill `pkgbuild-repo-add-force` için satır satır debug ve fix sağlar.

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
Kullanıcı: "pkgbuild-repo-add-force"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
