# archiso-iso-size-estimate Skill

**Kategori:** archiso
**Tetikleyici:** `archiso-iso-size-estimate`
**Dosya:** `.claude/SKILLS/archiso-iso-size-estimate/archiso-iso-size-estimate.md:1`

## Açıklama
Bu skill `archiso-iso-size-estimate` için satır satır debug ve fix sağlar.

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
Kullanıcı: "archiso-iso-size-estimate"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
