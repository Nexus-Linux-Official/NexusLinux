# archiso-customize-skel-dedup Skill

**Kategori:** archiso
**Tetikleyici:** `archiso-customize-skel-dedup`
**Dosya:** `.claude/SKILLS/archiso-customize-skel-dedup/archiso-customize-skel-dedup.md:1`

## Açıklama
Bu skill `archiso-customize-skel-dedup` için satır satır debug ve fix sağlar.

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
Kullanıcı: "archiso-customize-skel-dedup"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
