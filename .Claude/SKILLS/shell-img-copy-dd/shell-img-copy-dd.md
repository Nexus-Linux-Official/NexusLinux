# shell-img-copy-dd Skill

**Kategori:** shell
**Tetikleyici:** `shell-img-copy-dd`
**Dosya:** `.claude/SKILLS/shell-img-copy-dd/shell-img-copy-dd.md:1`

## Açıklama
Bu skill `shell-img-copy-dd` için satır satır debug ve fix sağlar.

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
Kullanıcı: "shell-img-copy-dd"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
