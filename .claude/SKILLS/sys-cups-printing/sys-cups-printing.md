# sys-cups-printing Skill

**Kategori:** sys
**Tetikleyici:** `sys-cups-printing`
**Dosya:** `.claude/SKILLS/sys-cups-printing/sys-cups-printing.md:1`

## Açıklama
Bu skill `sys-cups-printing` için satır satır debug ve fix sağlar.

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
Kullanıcı: "sys-cups-printing"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
