# HÜ – KM5-01 (Node.js + Prisma 7): Lösungen & Vorhersage

## Aufgabe 1 – Vorhersage (vor dem Ausführen notiert)

**Q1: Welche Künstler liefert „Top-Künstler nach Track-Anzahl" und in welcher Reihenfolge?**

Erwartet (auf Basis des Seeds: 4 Künstler, 7 Songs):

1. **Nova** — 3 Songs (Nordlicht, Glut, Funkeln)
2. **Pixel** — 2 Songs (Pixelstaub, Raster)
3. **Ohne Label** — 1 Song (Kurz)
4. **Solveig** — 1 Song (Fjord)

Sortierung: `ORDER BY tracks DESC` → absteigend, Nova hat die meisten Tracks.
Bei Gleichstand (1 Song) ist die Reihenfolge von SQLite nicht fix definiert — hier
liefert die DB zufällig „Ohne Label" vor „Solveig" (bei LIMIT 5 werden ohnehin alle
zurückgegeben, die Reihenfolge unter den 1-Track-Künstlern ist nicht weiter wichtig).

**Der tatsächliche Lauf (bestätigt):**

```
1) Top-Künstler: [
  { name: 'Nova', tracks: 3 },
  { name: 'Pixel', tracks: 2 },
  { name: 'Ohne Label', tracks: 1 },
  { name: 'Solveig', tracks: 1 }
]
```

---

## Frage Teil 1: Warum `COUNT(*)` = 4, aber `COUNT(labelId)` = 3?

| Künstler | labelId |
|----------|---------|
| Nova     | 1 (Ohrwurm Records) |
| Pixel    | 1 (Ohrwurm Records) |
| Solveig  | 2 (Indie Nord)      |
| Ohne Label | **NULL**        |

- `COUNT(*)` zählt **alle Zeilen** → 4 Künstler.
- `COUNT(labelId)` zählt **nur Zeilen, in denen die Spalte einen Wert (≠ NULL) hat** → die Zeile
  „Ohne Label" hat `labelId = NULL` und zählt **nicht** mit → 3.

Merksatz: `COUNT(spalte)` ignoriert NULL-Werte, `COUNT(*)` zählt jede Zeile.

---

## Aufgabe 3 – Playlist (N:M zu Song)

**Schema** (`praxis/prisma/schema.prisma`): Modell `Playlist` (`id`, `name @unique`) mit
`songs Song[]`; in `Song` Gegenfeld `playlists Playlist[]`. Prisma baut daraus die implizite
Join-Tabelle `_PlaylistToSong` (Migration `20260930151215_add_playlist`).

**Query** (`praxis/src/queries.js`, `songsPerPlaylist()`):
```js
const playlists = await prisma.playlist.findMany({
  include: { _count: { select: { songs: true } } },
});
return playlists.map((p) => ({ name: p.name, songs: p._count.songs }));
```

**Ergebnis im Lauf + Test (6/6 grün):**
```
6) Songs pro Playlist: [ { name: 'Nachtfahrt', songs: 2 }, { name: 'Fokus', songs: 2 } ]
```

Seed ergänzt (`praxis/src/seed.js`): Playlist `deleteMany` + 2 Playlists (Nachtfahrt:
Nordlicht, Fjord; Fokus: Pixelstaub, Raster).

---

## Aufgabe 4 – Reflexion

Bei den meisten Standard-Abfragen war Prisma deutlich kürzer und klarer als das
entsprechende SQL: Die Zähl-Frage aus Query 4 löste ich mit zwei kurzen `count()`-Aufrufen
statt mit einem `GROUP BY`-Gedanken, und „Labels mit mehr als einem Künstler" brauchte ein
`findMany` mit `_count`, wo ich sonst eine `HAVING`-Klausel von Hand geschrieben hätte. Am
eindrucksvollsten war die N:M-Playlist: Ich musste nur zwei Relationen-Felder deklarieren,
und Prisma hat die Join-Tabelle samt Fremdschlüsseln selbst erzeugt. Auf der anderen Seite
stieß ich beim Self-JOIN für die Künstlerpaare an die Grenze der Prisma-API — dafür gibt es
keinen direkten Befehl, und ich musste auf `$queryRaw` mit rohem SQL ausweichen. Ich finde
das nicht schlimm, weil man so trotzdem die volle Kontrolle behält, wenn man eine Abfrage
braucht, die nicht in das normale Prisma-Muster passt. Insgesamt bleibe ich vorerst bei
Prisma: Für die typischen Fragen des Unterrichts ist es schneller zu schreiben und weniger
fehleranfällig als rohes SQL, solange man den `$queryRaw`-Fluchtweg kennt.