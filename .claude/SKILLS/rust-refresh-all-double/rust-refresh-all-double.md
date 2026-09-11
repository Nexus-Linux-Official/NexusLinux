# rust-refresh-all-double Skill

**Kategori:** rust
**Tetikleyici:** `rust-refresh-all-double`
**Dosya:** `.claude/SKILLS/rust-refresh-all-double/rust-refresh-all-double.md:1`

## Açıklama
Bu skill `rust-refresh-all-double` için satır satır debug ve fix sağlar.

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
Kullanıcı: "rust-refresh-all-double"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
