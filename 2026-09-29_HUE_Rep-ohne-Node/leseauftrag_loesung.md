# Ausarbeitung Leseauftrag: Drizzle vs. Prisma 2026

**Name:** Jonas  
**Datum:** 29.09.2026  
**Fach:** INFI (3AHWII)

---

## Transferfrage 6 (HÜ, schriftlich, 5–6 Sätze)

**Frage:**  
*Setze den Artikel zu unserer Lage in Beziehung: Deno mit eingebautem `node:sqlite`, Prisma-7-Adapter-Pflicht (`better-sqlite3` nativ) und npm-`latest`, das auf einen 8.0.0-RC zeigt. Begründe, warum wir im Unterricht zuerst reines SQL fahren und ein ORM erst später — und wenn, eher Drizzle — evaluieren.*

**Antwort:**  
1. Der Unterrichtseinstieg mit Prisma 7 hat durch die Pflicht zu nativen Treibern (`better-sqlite3`) und instabile Release-Candidates (`npm:latest` auf Version 8.0.0-RC) gezeigt, dass schwere ORMs in modernen JavaScript-Laufzeitumgebungen wie Deno schnell zu unlösbaren Abhängigkeits- und Tooling-Problemen führen.
2. Deno bringt mit `node:sqlite` bereits eine native, performante SQLite-Anbindung im Kern mit, die weder `node_modules` noch externe Build-Tools benötigt.
3. Indem wir zuerst reines SQL lernen, verstehen wir die tatsächliche Arbeitsweise relationaler Datenbanken (Joins, Aggregationen, Indizes und Normalisierung), ohne dass ein ORM wie Prisma die Abfragen intransparent vor uns versteckt.
4. Erst wenn dieses SQL-Fundament sitzt, ist der Einsatz eines ORMs didaktisch sinnvoll – hier passt Drizzle wesentlich besser, da es nach dem „SQL-first“-Prinzip arbeitet und typisiertes SQL erzeugt, anstatt eine eigene DSL und komplexe Query-Engine einzuführen.
5. Zudem harmoniert Drizzle mit einer minimalen Paketgröße von nur ca. 12 KB und TypeScript-nativer Schemadefinition perfekt mit Deno und `node:sqlite`, ohne den Entwickler durch Versionsbrüche zu blockieren.
6. Zusammenfassend schützt uns der Start mit reinem SQL vor unnötiger Tooling-Komplexität und garantiert, dass wir Datenbanksysteme von Grund auf fehlerfrei beherrschen, bevor wir sie über ein leichtgewichtiges ORM automatisieren.
