# meta-issue-txt-tracker Skill

**Kategori:** meta
**Tetikleyici:** `meta-issue-txt-tracker`
**Dosya:** `.claude/SKILLS/meta-issue-txt-tracker/meta-issue-txt-tracker.md:1`

## Açıklama
Bu skill `meta-issue-txt-tracker` için satır satır debug ve fix sağlar.

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
Kullanıcı: "meta-issue-txt-tracker"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
