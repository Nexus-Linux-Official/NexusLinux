# sys-networkmanager-iwd Skill

**Kategori:** sys
**Tetikleyici:** `sys-networkmanager-iwd`
**Dosya:** `.claude/SKILLS/sys-networkmanager-iwd/sys-networkmanager-iwd.md:1`

## Açıklama
Bu skill `sys-networkmanager-iwd` için satır satır debug ve fix sağlar.

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
Kullanıcı: "sys-networkmanager-iwd"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
