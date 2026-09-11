# shell-ci-build-verbose Skill

**Kategori:** shell
**Tetikleyici:** `shell-ci-build-verbose`
**Dosya:** `.claude/SKILLS/shell-ci-build-verbose/shell-ci-build-verbose.md:1`

## Açıklama
Bu skill `shell-ci-build-verbose` için satır satır debug ve fix sağlar.

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
Kullanıcı: "shell-ci-build-verbose"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
