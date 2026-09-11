# archiso-mkinitcpio-preset-check Skill

**Kategori:** archiso
**Tetikleyici:** `archiso-mkinitcpio-preset-check`
**Dosya:** `.claude/SKILLS/archiso-mkinitcpio-preset-check/archiso-mkinitcpio-preset-check.md:1`

## Açıklama
Bu skill `archiso-mkinitcpio-preset-check` için satır satır debug ve fix sağlar.

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
Kullanıcı: "archiso-mkinitcpio-preset-check"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
