# py-l10n-generate Skill

**Kategori:** py
**Tetikleyici:** `py-l10n-generate`
**Dosya:** `.claude/SKILLS/py-l10n-generate/py-l10n-generate.md:1`

## Açıklama
Bu skill `py-l10n-generate` için satır satır debug ve fix sağlar.

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
Kullanıcı: "py-l10n-generate"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
