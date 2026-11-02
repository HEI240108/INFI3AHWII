# AGENTS.md — 3AHWII Agentic Coding Konfiguration

**Schüler:** Jonas  
**Klasse:** 3AHWII (WII - Betriebsinformatik, HTL Spengergasse)  
**Setup:** opencode / Antigravity Agentic Environment

---

## Zweck dieser Datei (Was AGENTS.md steuert)

Die Datei `AGENTS.md` dient als zentraler System-Prompt und Verhaltens-Leitfaden für KI-Coding-Agenten (wie opencode oder Antigravity) in diesem Repository:
1. **Rollen- & Kontext-Definition:** Teilt dem Agenten mit, wer der Benutzer ist (Jonas), um welche Schulfächer es sich handelt (INFI & SWP) und welche technischen Konventionen gelten.
2. **Workflow-Vorgaben:** Verhindert unüberlegte Dateiänderungen und legt den HÜ-Ablauf fest (erst erklären, nach Bestätigung Starter-Dateien mit Tagesdatum anlegen, dann implementieren und testen).
3. **Qualitätssicherung & Git-Disziplin:** Schreibt vor, dass für alle Aufgaben automatisierte Tests (`deno test` bzw. `npm test`) geschrieben und grün gehalten werden, sowie kleine, atomare Commits mit aussagekräftigen Nachrichten erzeugt werden.

---

## Richtlinien & Konventionen

- **Laufzeitumgebungen:** Deno (TypeScript, `node:sqlite`) für moderne Werkzeuge; Node.js nur dort, wo explizit gefordert (z. B. Prisma).
- **Test-Getrieben (TDD):** Jede Implementierung muss durch automatisierte Tests verifiziert werden. Vor Abgabe müssen alle Tests fehlerfrei laufen.
- **Fail-Fast & Invarianten:** Klassen sichern ihre Invarianten im Konstruktor und in mutierenden Methoden sofort durch Exceptions ab.
