# rust-rustc-version-fallback Skill

**Kategori:** rust
**Tetikleyici:** `rust-rustc-version-fallback`
**Dosya:** `.claude/SKILLS/rust-rustc-version-fallback/rust-rustc-version-fallback.md:1`

## Açıklama
Bu skill `rust-rustc-version-fallback` için satır satır debug ve fix sağlar.

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
Kullanıcı: "rust-rustc-version-fallback"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
