# archiso-iso-checksum-generate Skill

**Kategori:** archiso
**Tetikleyici:** `archiso-iso-checksum-generate`
**Dosya:** `.claude/SKILLS/archiso-iso-checksum-generate/archiso-iso-checksum-generate.md:1`

## Açıklama
Bu skill `archiso-iso-checksum-generate` için satır satır debug ve fix sağlar.

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
Kullanıcı: "archiso-iso-checksum-generate"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
