# shell-nexus-unstable-workdir-restore Skill

**Kategori:** shell
**Tetikleyici:** `shell-nexus-unstable-workdir-restore`
**Dosya:** `.claude/SKILLS/shell-nexus-unstable-workdir-restore/shell-nexus-unstable-workdir-restore.md:1`

## Açıklama
Bu skill `shell-nexus-unstable-workdir-restore` için satır satır debug ve fix sağlar.

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
Kullanıcı: "shell-nexus-unstable-workdir-restore"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
