# rust-zero-dimension-guard Skill

**Kategori:** rust
**Tetikleyici:** `rust-zero-dimension-guard`
**Dosya:** `.claude/SKILLS/rust-zero-dimension-guard/rust-zero-dimension-guard.md:1`

## Açıklama
Bu skill `rust-zero-dimension-guard` için satır satır debug ve fix sağlar.

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
Kullanıcı: "rust-zero-dimension-guard"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
