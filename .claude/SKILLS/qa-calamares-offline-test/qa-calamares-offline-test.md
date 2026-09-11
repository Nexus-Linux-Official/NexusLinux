# qa-calamares-offline-test Skill

**Kategori:** qa
**Tetikleyici:** `qa-calamares-offline-test`
**Dosya:** `.claude/SKILLS/qa-calamares-offline-test/qa-calamares-offline-test.md:1`

## Açıklama
Bu skill `qa-calamares-offline-test` için satır satır debug ve fix sağlar.

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
Kullanıcı: "qa-calamares-offline-test"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
