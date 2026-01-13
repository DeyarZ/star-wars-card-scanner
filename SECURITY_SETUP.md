# 🔒 Sicherheits-Setup für API-Schlüssel

## ✅ Was wurde eingerichtet

### 1. Sichere Konfiguration
- **Info.plist** enthält jetzt nur noch Platzhalter-Text
- **Info.plist** wurde zu `.gitignore` hinzugefügt
- **Info.plist.template** als Vorlage erstellt

### 2. Für Entwickler

**Erstmaliges Setup:**
```bash
# 1. Template kopieren
cp tcgscanner/Info.plist.template tcgscanner/Info.plist

# 2. Deinen API-Schlüssel eintragen
# Öffne tcgscanner/Info.plist und ersetze:
# YOUR_OPENAI_API_KEY_HERE → dein echter API-Schlüssel
```

**Dein API-Schlüssel:**
- Füge deinen persönlichen OpenAI API-Schlüssel in die lokale `Info.plist` ein
- Der Schlüssel bleibt lokal und wird nicht ins Git committed

### 3. Sicherheitsgarantien

✅ **API-Schlüssel wird NICHT committed**
✅ **Nur Template-Datei ist in Git**
✅ **Lokale Info.plist ist ignoriert**
✅ **Dokumentation aktualisiert**

### 4. Für andere Entwickler

Wenn jemand anderes das Projekt klont:
1. Sie bekommen nur die Template-Datei
2. Sie müssen ihre eigenen API-Schlüssel hinzufügen
3. Keine Sicherheitslücken durch geteilte Schlüssel

## 🚨 Wichtige Hinweise

- **Niemals** echte API-Schlüssel in Git committen
- **Immer** das Template verwenden zum Teilen
- **Regelmäßig** API-Schlüssel rotieren bei Verdacht auf Kompromittierung
