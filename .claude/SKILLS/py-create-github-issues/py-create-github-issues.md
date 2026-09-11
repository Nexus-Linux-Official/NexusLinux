# py-create-github-issues Skill

**Kategori:** py
**Tetikleyici:** `py-create-github-issues`
**Dosya:** `.claude/SKILLS/py-create-github-issues/py-create-github-issues.md:1`

## Açıklama
Bu skill `py-create-github-issues` için satır satır debug ve fix sağlar.

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
Kullanıcı: "py-create-github-issues"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
