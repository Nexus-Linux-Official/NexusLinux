# git-ignore-vendored Skill

**Kategori:** git
**Tetikleyici:** `git-ignore-vendored`
**Dosya:** `.claude/SKILLS/git-ignore-vendored/git-ignore-vendored.md:1`

## Açıklama
Bu skill `git-ignore-vendored` için satır satır debug ve fix sağlar.

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
Kullanıcı: "git-ignore-vendored"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
