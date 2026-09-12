# archiso-squashfs-options-tune Skill

**Kategori:** archiso
**Tetikleyici:** `archiso-squashfs-options-tune`
**Dosya:** `.claude/SKILLS/archiso-squashfs-options-tune/archiso-squashfs-options-tune.md:1`

## Açıklama
Bu skill `archiso-squashfs-options-tune` için satır satır debug ve fix sağlar.

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
Kullanıcı: "archiso-squashfs-options-tune"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
