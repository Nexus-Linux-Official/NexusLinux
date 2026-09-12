# rust-vendor-id-match Skill

**Kategori:** rust
**Tetikleyici:** `rust-vendor-id-match`
**Dosya:** `.claude/SKILLS/rust-vendor-id-match/rust-vendor-id-match.md:1`

## Açıklama
Bu skill `rust-vendor-id-match` için satır satır debug ve fix sağlar.

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
Kullanıcı: "rust-vendor-id-match"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
