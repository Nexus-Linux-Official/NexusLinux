# sys-nvidia-dkms-check Skill

**Kategori:** sys
**Tetikleyici:** `sys-nvidia-dkms-check`
**Dosya:** `.claude/SKILLS/sys-nvidia-dkms-check/sys-nvidia-dkms-check.md:1`

## Açıklama
Bu skill `sys-nvidia-dkms-check` için satır satır debug ve fix sağlar.

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
Kullanıcı: "sys-nvidia-dkms-check"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
