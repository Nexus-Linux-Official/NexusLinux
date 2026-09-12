# qa-cargo-clippy-pedantic Skill

**Kategori:** qa
**Tetikleyici:** `qa-cargo-clippy-pedantic`
**Dosya:** `.claude/SKILLS/qa-cargo-clippy-pedantic/qa-cargo-clippy-pedantic.md:1`

## Açıklama
Bu skill `qa-cargo-clippy-pedantic` için satır satır debug ve fix sağlar.

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
Kullanıcı: "qa-cargo-clippy-pedantic"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
