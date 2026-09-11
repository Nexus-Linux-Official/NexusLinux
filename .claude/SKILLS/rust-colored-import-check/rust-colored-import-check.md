# rust-colored-import-check Skill

**Kategori:** rust
**Tetikleyici:** `rust-colored-import-check`
**Dosya:** `.claude/SKILLS/rust-colored-import-check/rust-colored-import-check.md:1`

## Açıklama
Bu skill `rust-colored-import-check` için satır satır debug ve fix sağlar.

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
Kullanıcı: "rust-colored-import-check"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
