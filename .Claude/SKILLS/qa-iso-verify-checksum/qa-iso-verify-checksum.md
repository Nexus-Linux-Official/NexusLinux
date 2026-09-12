# qa-iso-verify-checksum Skill

**Kategori:** qa
**Tetikleyici:** `qa-iso-verify-checksum`
**Dosya:** `.claude/SKILLS/qa-iso-verify-checksum/qa-iso-verify-checksum.md:1`

## Açıklama
Bu skill `qa-iso-verify-checksum` için satır satır debug ve fix sağlar.

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
Kullanıcı: "qa-iso-verify-checksum"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
