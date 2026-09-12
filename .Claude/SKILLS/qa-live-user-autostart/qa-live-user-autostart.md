# qa-live-user-autostart Skill

**Kategori:** qa
**Tetikleyici:** `qa-live-user-autostart`
**Dosya:** `.claude/SKILLS/qa-live-user-autostart/qa-live-user-autostart.md:1`

## Açıklama
Bu skill `qa-live-user-autostart` için satır satır debug ve fix sağlar.

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
Kullanıcı: "qa-live-user-autostart"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
