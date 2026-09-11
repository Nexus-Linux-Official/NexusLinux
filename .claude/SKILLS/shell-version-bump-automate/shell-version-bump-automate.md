# shell-version-bump-automate Skill

**Kategori:** shell
**Tetikleyici:** `shell-version-bump-automate`
**Dosya:** `.claude/SKILLS/shell-version-bump-automate/shell-version-bump-automate.md:1`

## Açıklama
Bu skill `shell-version-bump-automate` için satır satır debug ve fix sağlar.

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
Kullanıcı: "shell-version-bump-automate"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
