# archiso-version-tag-bump Skill

**Kategori:** archiso
**Tetikleyici:** `archiso-version-tag-bump`
**Dosya:** `.claude/SKILLS/archiso-version-tag-bump/archiso-version-tag-bump.md:1`

## Açıklama
Bu skill `archiso-version-tag-bump` için satır satır debug ve fix sağlar.

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
Kullanıcı: "archiso-version-tag-bump"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
