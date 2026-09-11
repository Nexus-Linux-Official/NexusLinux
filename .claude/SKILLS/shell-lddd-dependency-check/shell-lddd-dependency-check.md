# shell-lddd-dependency-check Skill

**Kategori:** shell
**Tetikleyici:** `shell-lddd-dependency-check`
**Dosya:** `.claude/SKILLS/shell-lddd-dependency-check/shell-lddd-dependency-check.md:1`

## Açıklama
Bu skill `shell-lddd-dependency-check` için satır satır debug ve fix sağlar.

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
Kullanıcı: "shell-lddd-dependency-check"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
