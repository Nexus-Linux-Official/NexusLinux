# py-build-orchestrator Skill

**Kategori:** py
**Tetikleyici:** `py-build-orchestrator`
**Dosya:** `.claude/SKILLS/py-build-orchestrator/py-build-orchestrator.md:1`

## Açıklama
Bu skill `py-build-orchestrator` için satır satır debug ve fix sağlar.

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
Kullanıcı: "py-build-orchestrator"
```

---
*Otomatik oluşturuldu — `README.md:1` yapısına uygun.*
