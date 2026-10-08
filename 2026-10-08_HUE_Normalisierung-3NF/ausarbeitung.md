# Ausarbeitung Hausübung: Dritte Normalform (3NF)

**Name:** Jonas  
**Datum:** 08.10.2026  
**Fach:** INFI (3AHWII)

---

## 1. Zerlegung von `bestellung_denorm` bis 3NF

### Ausgangstabelle (Unnormalisiert / Denormalisiert)
`bestellung_denorm(bestell_nr, kunde, plz, ort)`  
**Primärschlüssel:** `bestell_nr`

### Analyse der Abhängigkeiten
* `bestell_nr -> kunde`
* `bestell_nr -> plz`
* `plz -> ort`

### Begründung der 3NF-Verletzung
Es liegt eine **transitive Abhängigkeit** vor: `bestell_nr -> plz -> ort`.  
Der Ort hängt funktional von der Postleitzahl (`plz`) ab und nicht direkt vom Primärschlüssel `bestell_nr`. Da sowohl `plz` als auch `ort` Nicht-Schlüssel-Attribute sind, verletzt dies die 3. Normalform (3NF).

### Zerlegung in 3NF (Tabellenschema & Fremdschlüssel)
1. **Tabelle `plz`:**
   * **Schema:** `plz(plz PRIMARY KEY, ort TEXT NOT NULL)`
2. **Tabelle `bestellung`:**
   * **Schema:** `bestellung(bestell_nr PRIMARY KEY, kunde TEXT NOT NULL, plz TEXT NOT NULL REFERENCES plz(plz))`

---

## 2. Zerlegung von zwei eigenen Quiz-Tabellen in 3NF

### Quiz-Tabelle 1: Schülersprecher (`schueler_denorm`)

#### Ausgangslage & Abhängigkeiten
`schueler_denorm(matr_nr, name, klasse, klassensprecher)`  
Abhängigkeit: `matr_nr -> klasse -> klassensprecher` (Der Klassensprecher ist eine Eigenschaft der Klasse, nicht des einzelnen Schülers).

#### SQL-Definition & Testdaten (3NF)
```sql
-- 1. Tabelle Klasse (3NF)
CREATE TABLE klasse (
  klasse          TEXT PRIMARY KEY,
  klassensprecher TEXT NOT NULL
);

INSERT INTO klasse (klasse, klassensprecher) VALUES
  ('3AHWII', 'Beck'),
  ('3BHWII', 'Demir');

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

#### Ausgangslage & Abhängigkeiten
`konto_denorm(iban, inhaber, blz, bankname)`  
Abhängigkeit: `iban -> blz -> bankname` (Der Bankname hängt von der Bankleitzahl `blz` ab).

#### SQL-Definition & Testdaten (3NF)
```sql
-- 1. Tabelle Bank (3NF)
CREATE TABLE bank (
  blz      TEXT PRIMARY KEY,
  bankname TEXT NOT NULL
);

INSERT INTO bank (blz, bankname) VALUES
  ('1000', 'Erste Bank'),
  ('2000', 'Raiffeisen');

-- 2. Tabelle Konto (3NF)
CREATE TABLE konto (
  iban    TEXT PRIMARY KEY,
  inhaber TEXT NOT NULL,
  blz     TEXT NOT NULL REFERENCES bank(blz)
);

INSERT INTO konto (iban, inhaber, blz) VALUES
  ('AT01', 'Auer', '1000'),
  ('AT02', 'Beck', '1000');
```

---

## 3. Nachweis & Verifikation (`deno task demo` / `deno task test`)

Die Ausführung von `deno task demo` und `deno task test` verifiziert die Funktionsfähigkeit der Normalisierungsbeispiele im Deno-Umfeld.
