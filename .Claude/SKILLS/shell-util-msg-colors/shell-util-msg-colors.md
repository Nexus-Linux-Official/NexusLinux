# shell-util-msg-colors Skill

**Kategori:** shell
**Tetikleyici:** `shell-util-msg-colors`
**Dosya:** `.claude/SKILLS/shell-util-msg-colors/shell-util-msg-colors.md:1`

## Açıklama
Bu skill `shell-util-msg-colors` için satır satır debug ve fix sağlar.

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
Kullanıcı: "shell-util-msg-colors"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
