# archiso-pxe-boot-test Skill

**Kategori:** archiso
**Tetikleyici:** `archiso-pxe-boot-test`
**Dosya:** `.claude/SKILLS/archiso-pxe-boot-test/archiso-pxe-boot-test.md:1`

## Açıklama
Bu skill `archiso-pxe-boot-test` için satır satır debug ve fix sağlar.

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
Kullanıcı: "archiso-pxe-boot-test"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
