# Ausarbeitung Hausübung: Normalisierung 1NF bis 3NF

**Name:** Jonas  
**Datum:** 08.10.2026 (überarbeitet: 02.11.2026)  
**Fach:** INFI (3AHWII)

---

## 1. Schrittweise Zerlegung von `bestellung_denorm` (1NF → 2NF → 3NF)

### Ausgangstabelle (Unnormalisiert)
`bestellung_denorm(bestell_nr, kunde, plz, ort)`  
*Gegeben:* Ein Attribut `bestell_nr` als Primärschlüssel.

---

### Schritt 1: Prüfung auf 1. Normalform (1NF)
> **Definition 1NF:** Jedes Attribut enthält nur atomare (unteilbare) Werte, und es gibt keine Wiederholungsgruppen.
* **Prüfung:**  
  - Alle Attribute (`bestell_nr`, `kunde`, `plz`, `ort`) enthalten skalare Einzelwerte (keine Arrays, keine Mehrfachwerte pro Zelle wie z.B. mehrere PLZ durch Komma getrennt).
  - Ein Primärschlüssel ist festgelegt (`bestell_nr`).
* **Ergebnis:** Die Tabelle befindet sich bereits in der **1. Normalform (1NF)**.

---

### Schritt 2: Prüfung auf 2. Normalform (2NF)
> **Definition 2NF:** Die Tabelle ist in der 1NF, und jedes Nicht-Schlüssel-Attribut ist von **jedem echten Teil** des Primärschlüssels voll funktional abhängig (keine partiellen Abhängigkeiten).
* **Prüfung:**  
  - Der Primärschlüssel ist einfach (nicht zusammengesetzt): `PK = {bestell_nr}`.
  - Da der Schlüssel nur aus einem einzigen Attribut besteht, kann kein Attribut von einem *Teil* des Schlüssels abhängen.
* **Ergebnis:** Eine Tabelle mit einfachem Primärschlüssel in der 1NF erfüllt automatisch die **2. Normalform (2NF)**.

---

### Schritt 3: Prüfung und Überführung in die 3. Normalform (3NF)
> **Definition 3NF:** Die Tabelle ist in der 2NF, und **kein Nicht-Schlüssel-Attribut hängt transitiv vom Primärschlüssel ab** (d. h. kein Nicht-Schlüssel-Attribut darf von einem anderen Nicht-Schlüssel-Attribut funktional abhängen).

#### Funktionale Abhängigkeiten (Abhängigkeitspfeile):
1. `bestell_nr -> kunde` (Der Kunde hängt direkt von der Bestellnummer ab)
2. `bestell_nr -> plz` (Die Liefer-PLZ hängt direkt von der Bestellnummer ab)
3. `plz -> ort` (Der Ortsname wird eindeutig durch die PLZ bestimmt)

#### Analyse der 3NF-Verletzung:
* Daraus folgt die **transitive Kette**:  
  $$\text{bestell\_nr} \longrightarrow \text{plz} \longrightarrow \text{ort}$$
* Da sowohl `plz` als auch `ort` Nicht-Schlüssel-Attribute sind, hängt `ort` transitiv vom Primärschlüssel `bestell_nr` ab.
* *Folgen der Denormalisierung:*  
  - **Änderungs-Anomalie:** Ändert sich die Schreibweise eines Ortes (oder eine PLZ-Zuordnung), müssen viele Bestellungen aktualisiert werden.
  - **Einfüge-Anomalie:** Ein neuer Ort mit PLZ kann nicht angelegt werden, solange noch keine Bestellung existiert.
  - **Lösch-Anomalie:** Wird die letzte Bestellung einer Stadt gelöscht, geht die Information verloren, welcher Ort zu dieser PLZ gehört.

#### Zerlegung in 3NF (Verlustfrei & Abhängigkeitstreu):
Wir lagern die transitive Abhängigkeit in eine eigene Referenztabelle aus:

1. **Tabelle `plz` (Stammdaten):**  
   - Schema: `plz(plz [PK], ort)`  
   - Abhängigkeit: `plz -> ort` (voll funktional vom eigenen PK abhängig)

2. **Tabelle `bestellung` (Bewegungsdaten):**  
   - Schema: `bestellung(bestell_nr [PK], kunde, plz [FK -> plz.plz])`  
   - Abhängigkeiten: `bestell_nr -> kunde`, `bestell_nr -> plz` (nur noch direkte Abhängigkeiten vom PK)

---

## 2. Zerlegung von zwei Quiz-Tabellen in 3NF

### Quiz-Tabelle 1: Schülersprecher (`schueler_denorm`)

* **Ausgangstabelle:** `schueler_denorm(matr_nr, name, klasse, klassensprecher)` mit PK `matr_nr`
* **Transitive Abhängigkeit:**  
  $$\text{matr\_nr} \longrightarrow \text{klasse} \longrightarrow \text{klassensprecher}$$  
  Der Klassensprecher ist eine Eigenschaft der Klasse, nicht des einzelnen Schülers.
* **Zerlegung in 3NF:**

```sql
-- 1. Tabelle Klasse (3NF)
CREATE TABLE klasse (
  klasse          TEXT PRIMARY KEY,
  klassensprecher TEXT NOT NULL
);

INSERT INTO klasse (klasse, klassensprecher) VALUES
  ('3AHWII', 'Beck'),
  ('3BHWII', 'Demir'),
  ('3CHWII', 'Gruber');

-- 2. Tabelle Schüler (3NF)
CREATE TABLE schueler (
  matr_nr INTEGER PRIMARY KEY,
  name    TEXT NOT NULL,
  klasse  TEXT NOT NULL REFERENCES klasse(klasse)
);

INSERT INTO schueler (matr_nr, name, klasse) VALUES
  (1, 'Auer',  '3AHWII'),
  (2, 'Beck',  '3AHWII'),
  (3, 'Cevik', '3BHWII');
```

---

### Quiz-Tabelle 2: Bankkonto (`konto_denorm`)

* **Ausgangstabelle:** `konto_denorm(iban, inhaber, blz, bankname)` mit PK `iban`
* **Transitive Abhängigkeit:**  
  $$\text{iban} \longrightarrow \text{blz} \longrightarrow \text{bankname}$$  
  Der Bankname wird durch die Bankleitzahl (`blz`) bestimmt und hängt nicht direkt von der `iban` ab.
* **Zerlegung in 3NF (mit geforderten 3 Beispielzeilen je Tabelle):**

```sql
-- 1. Tabelle Bank (3NF)
CREATE TABLE bank (
  blz      TEXT PRIMARY KEY,
  bankname TEXT NOT NULL
);

INSERT INTO bank (blz, bankname) VALUES
  ('1000', 'Erste Bank'),
  ('2000', 'Raiffeisen'),
  ('3000', 'BAWAG PSK');

-- 2. Tabelle Konto (3NF)
CREATE TABLE konto (
  iban    TEXT PRIMARY KEY,
  inhaber TEXT NOT NULL,
  blz     TEXT NOT NULL REFERENCES bank(blz)
);

INSERT INTO konto (iban, inhaber, blz) VALUES
  ('AT01', 'Auer', '1000'),
  ('AT02', 'Beck', '1000'),
  ('AT03', 'Cevik', '2000');
```

---

## 3. Zusatz aus der Stunde: Umsetzung mit Prisma-Schema & Migration

Die 3NF-Zerlegung lässt sich direkt in ein relationales **Prisma 7 Schema** übertragen:

```prisma
// schema.prisma
datasource db {
  provider = "sqlite"
}

generator client {
  provider = "prisma-client-js"
}

model Plz {
  plz          String        @id
  ort          String
  bestellungen Bestellung[]
}

model Bestellung {
  bestellNr    Int           @id @default(autoincrement())
  kunde        String
  plz          String
  ortRef       Plz           @relation(fields: [plz], references: [plz])
}

model Bank {
  blz          String        @id
  bankname     String
  konten       Konto[]
}

model Konto {
  iban         String        @id
  inhaber      String
  blz          String
  bankRef      Bank          @relation(fields: [blz], references: [blz])
}
```

### Migration (`npx prisma migrate dev --name init_3nf`):
Prisma erzeugt daraus automatisch das äquivalente relationale DDL mit Fremdschlüsseln (`FOREIGN KEY (plz) REFERENCES Plz(plz)`), wodurch Datenkonsistenz und Anomaliefreiheit datenbankseitig erzwungen werden.

---

## 4. Nachweis & Konsolenausgabe

### Konsolenausgabe von `deno task demo`:
```text
> deno task demo
Task demo deno run --allow-read --allow-write demo.ts
PLZ 1020 hat 2 verschiedene Orte -> Anomalie!
PLZ-Tabelle hat 1 Zeile fuer 1020 -> genau einmal.
```

### Konsolenausgabe von `deno task test`:
```text
> deno task test
Task test deno test
running 2 tests from ./demo_test.ts
plz-tatsache steht genau einmal ... ok (5ms)
denormalisiert erlaubt widerspruch ... ok (0ms)

ok | 2 passed | 0 failed (17ms)
```
