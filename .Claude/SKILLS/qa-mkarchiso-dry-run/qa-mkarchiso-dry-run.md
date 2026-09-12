# qa-mkarchiso-dry-run Skill

**Kategori:** qa
**Tetikleyici:** `qa-mkarchiso-dry-run`
**Dosya:** `.claude/SKILLS/qa-mkarchiso-dry-run/qa-mkarchiso-dry-run.md:1`

## Açıklama
Bu skill `qa-mkarchiso-dry-run` için satır satır debug ve fix sağlar.

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
Kullanıcı: "qa-mkarchiso-dry-run"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
