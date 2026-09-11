# qa-pacman-db-validate Skill

**Kategori:** qa
**Tetikleyici:** `qa-pacman-db-validate`
**Dosya:** `.claude/SKILLS/qa-pacman-db-validate/qa-pacman-db-validate.md:1`

## Açıklama
Bu skill `qa-pacman-db-validate` için satır satır debug ve fix sağlar.

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
Kullanıcı: "qa-pacman-db-validate"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
