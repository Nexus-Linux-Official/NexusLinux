# rust-worst-msg-dead-store Skill

**Kategori:** rust
**Tetikleyici:** `rust-worst-msg-dead-store`
**Dosya:** `.claude/SKILLS/rust-worst-msg-dead-store/rust-worst-msg-dead-store.md:1`

## Açıklama
Bu skill `rust-worst-msg-dead-store` için satır satır debug ve fix sağlar.

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
Kullanıcı: "rust-worst-msg-dead-store"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
