# meta-changelog-update Skill

**Kategori:** meta
**Tetikleyici:** `meta-changelog-update`
**Dosya:** `.claude/SKILLS/meta-changelog-update/meta-changelog-update.md:1`

## Açıklama
Bu skill `meta-changelog-update` için satır satır debug ve fix sağlar.

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
Kullanıcı: "meta-changelog-update"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
