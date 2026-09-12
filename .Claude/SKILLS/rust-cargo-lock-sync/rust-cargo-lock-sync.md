# rust-cargo-lock-sync Skill

**Kategori:** rust
**Tetikleyici:** `rust-cargo-lock-sync`
**Dosya:** `.claude/SKILLS/rust-cargo-lock-sync/rust-cargo-lock-sync.md:1`

## Açıklama
Bu skill `rust-cargo-lock-sync` için satır satır debug ve fix sağlar.

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
Kullanıcı: "rust-cargo-lock-sync"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
