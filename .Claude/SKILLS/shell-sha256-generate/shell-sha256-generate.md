# shell-sha256-generate Skill

**Kategori:** shell
**Tetikleyici:** `shell-sha256-generate`
**Dosya:** `.claude/SKILLS/shell-sha256-generate/shell-sha256-generate.md:1`

## Açıklama
Bu skill `shell-sha256-generate` için satır satır debug ve fix sağlar.

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
Kullanıcı: "shell-sha256-generate"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
