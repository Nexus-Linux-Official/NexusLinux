# rust-unused-import-clean Skill

**Kategori:** rust
**Tetikleyici:** `rust-unused-import-clean`
**Dosya:** `.claude/SKILLS/rust-unused-import-clean/rust-unused-import-clean.md:1`

## Açıklama
Bu skill `rust-unused-import-clean` için satır satır debug ve fix sağlar.

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
Kullanıcı: "rust-unused-import-clean"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
