# git-release-notes-generate Skill

**Kategori:** git
**Tetikleyici:** `git-release-notes-generate`
**Dosya:** `.claude/SKILLS/git-release-notes-generate/git-release-notes-generate.md:1`

## Açıklama
Bu skill `git-release-notes-generate` için satır satır debug ve fix sağlar.

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
Kullanıcı: "git-release-notes-generate"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
