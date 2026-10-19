# Ausarbeitung Hausübung: KM5-05 Drizzle ORM

**Name:** Jonas  
**Datum:** 19.10.2026  
**Fach:** INFI (3AHWII)

---

## 1. Vorhersage (vor dem Ausführen)

Welches SQL erzeugen die zwei Abfragen aus der Lesson?

### Abfrage a)
```typescript
db.select().from(artist).where(eq(artist.gruendungsjahr, 1999))
```
* **Erzeugtes SQL:**
  ```sql
  select "id", "name", "gruendungsjahr" from "artist" where "artist"."gruendungsjahr" = ?
  ```
* **Spaltenliste:** `"id", "name", "gruendungsjahr"` (alle definierten Spalten der Tabelle `artist`)
* **WHERE-Klausel:** `"artist"."gruendungsjahr" = ?`
* **Parameter:** `[ 1999 ]` (wird als Prepared Statement Parameter gebunden, nicht als Klartextstring im SQL)

---

### Abfrage b)
```typescript
db.select({ n: count() }).from(album).where(eq(album.artistId, 1))
```
* **Erzeugtes SQL:**
  ```sql
  select count() as "n" from "album" where "album"."artist_id" = ?
  ```
* **Spaltenliste:** `count() as "n"` (benannte Aggregation)
* **WHERE-Klausel:** `"album"."artist_id" = ?` (beachte: Drizzle mappt automatisch die TypeScript-Eigenschaft `artistId` auf die DB-Spalte `artist_id`)
* **Parameter:** `[ 1 ]`

---

## 2. Erweiterung in `demo.ts`

In [`demo.ts`](./demo.ts) wurden die geforderten Abfragen implementiert:

```typescript
// 1. Ältestes Album (orderBy + limit)
const aeltestes = await db.select().from(album)
  .orderBy(asc(album.jahr))
  .limit(1);
console.log("HÜ 1 - Ältestes Album:", aeltestes[0].titel, "(", aeltestes[0].jahr, ")");

// 2. Tracks eines Albums mit Titel-Anfang 'Echo' (and + eq + like)
const echoTracks = await db.select().from(track)
  .where(and(eq(track.albumId, stille[0].id), like(track.titel, "Echo%")));
console.log("HÜ 2 - Tracks mit Titel-Anfang 'Echo':", echoTracks);

// 3. Anzahl Tracks je Album (count + groupBy)
const tracksJeAlbum = await db.select({ titel: album.titel, tracks: count() })
  .from(track)
  .innerJoin(album, eq(track.albumId, album.id))
  .groupBy(album.id);
console.log("HÜ 3 - Tracks pro Album:", tracksJeAlbum);
```

---

## 3. SQL-Vergleich (Interleaving)

### Reines SQL:
```sql
SELECT album.titel, count() AS tracks
FROM track
INNER JOIN album ON track.album_id = album.id
GROUP BY album.id;
```

### Gegenüberstellung mit Drizzle ORM:
Drizzle ORM bildet die SQL-Bausteine 1:1 typsicher in TypeScript ab:

| SQL-Baustein | Drizzle ORM Code |
|---|---|
| `SELECT album.titel, count() AS tracks` | `db.select({ titel: album.titel, tracks: count() })` |
| `FROM track` | `.from(track)` |
| `INNER JOIN album ON track.album_id = album.id` | `.innerJoin(album, eq(track.albumId, album.id))` |
| `GROUP BY album.id` | `.groupBy(album.id)` |

---

## 4. Nachweis: Ausführung & Tests

### Konsolenausgabe von `deno task demo`:
```text
Task demo deno run --allow-read --allow-write demo.ts
Lesen, erzeugtes SQL: select "id", "titel", "jahr", "artist_id" from "album" where "album"."artist_id" = ?
Lesen, Parameter: [ 1 ]
Lesen, Ergebnis: [ { id: 1, titel: "Silent Lines", jahr: 2015, artistId: 1 } ]
Neuestes Album: Silent Lines ( 2015 )
HÜ 1 - Ältestes Album: Night Ferry ( 2012 )
HÜ 2 - Tracks mit Titel-Anfang 'Echo': [ { id: 2, titel: "Echo Room", dauerSek: 187, albumId: 1 } ]
HÜ 3 - Tracks pro Album: [ { titel: "Silent Lines", tracks: 2 } ]
Nach update: 220 Sekunden
Tracks nach delete: 1
```

### Konsolenausgabe von `deno task test`:
```text
Task test deno test
running 12 tests from ./demo_test.ts
insert mit returning liefert die neue Zeile mit id ... ok (10ms)
select mit where filtert typsicher ... ok (4ms)
Fremdschlüssel verhindert Album ohne Artist ... ok (2ms)
update aendert nur die gewaehlten Zeilen ... ok (7ms)
delete entfernt nur die gewaehlte Zeile ... ok (4ms)
orderBy + limit liefern das juengste Album ... ok (2ms)
innerJoin verbindet Album und Artist ... ok (4ms)
Drizzle parametrisiert: Werte stecken in params, nicht im SQL ... ok (1ms)
assertThrows ist importiert und steht bereit ... ok (1ms)
HÜ 2a: orderBy (asc) + limit liefert das aelteste Album ... ok (4ms)
HÜ 2b: and + eq + like findet Tracks mit Titel-Anfang Echo ... ok (1ms)
HÜ 2c: count + groupBy zaehlt Tracks pro Album ... ok (2ms)

ok | 12 passed | 0 failed (66ms)
```
