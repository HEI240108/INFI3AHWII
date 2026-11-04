# AGENTS.md — 3AHWII INFI Konfiguration & Kriterien

**Schüler:** Jonas  
**Klasse:** 3AHWII (WII - Betriebsinformatik, HTL Spengergasse)  
**Lehrperson:** Prof. Georg Graf

---

## Zweck dieser Datei
Steuert das Verhalten von Agenten in diesem Repository zur Einhaltung der Bewertungsstandards von Prof. Graf:
1. **Laufzeitumgebung:** Deno (TypeScript, `node:sqlite`) für Unterrichts-Code; Node.js/npm nur dort, wo explizit vorgegeben (z.B. Prisma).
2. **Aufgaben-Vollständigkeit:** Jede Aufgabe aus `GRG-INFI` vollständig mit Vorhersage (Spalten, WHERE, Parameter) und Reflexion lösen.
3. **Normalisierung:** Zwischenschritte 1NF und 2NF mit funktionalen Abhängigkeitspfeilen (`A -> B -> C`) explizit ausweisen; mindestens 3 Beispielzeilen pro Tabelle; Prisma-Modellierung wo gefordert.
4. **Nachweise & Konsolenausgaben:** Terminal-Ausgaben von `deno task demo` und `deno task test` immer als Beleg in die Markdown-Ausarbeitung einbetten.
5. **Git-Disziplin:** Atomare Commits mit sprechenden Messages (`feat(...)`, `docs(...)`, `test(...)`), keine Sammel-Commits.
