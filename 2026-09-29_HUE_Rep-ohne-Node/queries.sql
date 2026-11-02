-- ============================================================================
-- Hausübung INFI: 5 Auffrischungs-Queries (Rep ohne Node)
-- Name: Jonas
-- Datum: 29.09.2026
-- Datenbank: musik-mini.db (Schema: label, kuenstler, song)
-- ============================================================================

-- Query 1: Top-5-Künstler nach Anzahl der Tracks
-- Frage: Welche Künstler haben die meisten Songs im Katalog veröffentlicht?
-- Erklärung: Verbindet Künstler mit ihren Songs per INNER JOIN, gruppiert nach der Künstler-ID,
-- zählt die zugehörigen Songs mit COUNT(*), sortiert absteigend und limitiert auf die obersten 5.
SELECT k.name AS kuenstler, COUNT(*) AS tracks
FROM kuenstler k 
JOIN song s ON s.kuenstler_id = k.id
GROUP BY k.id
ORDER BY tracks DESC
LIMIT 5;

-- Query 2: Künstlerpaare desselben Labels (Self-JOIN)
-- Frage: Welche Künstler stehen beim selben Label unter Vertrag (ohne Duplikate/Selbstpaarung)?
-- Erklärung: Ein Self-JOIN auf die Tabelle Künstler über die gemeinsame label_id. Die Bedingung
-- x.id < y.id verhindert, dass ein Künstler mit sich selbst gepaart wird (x.id != y.id) und
-- eliminiert gespiegelte Paare wie (A, B) und (B, A).
SELECT x.name AS kuenstler_a, y.name AS kuenstler_b, l.name AS label
FROM kuenstler x
JOIN kuenstler y ON x.label_id = y.label_id AND x.id < y.id
JOIN label l ON l.id = x.label_id;

-- Query 3: Labels mit mehr als einem Künstler
-- Frage: Welche Musiklabels betreuen mehr als einen Künstler?
-- Erklärung: Gruppiert alle Künstler nach ihrem Label und filtert aggregierte Gruppen
-- mit der HAVING-Klausel (HAVING COUNT(*) > 1). WHERE filtert Zeilen vor der Gruppierung,
-- HAVING filtert erst nach der Berechnung des Aggregats.
SELECT l.name AS label, COUNT(*) AS kuenstler_anzahl
FROM kuenstler k 
JOIN label l ON l.id = k.label_id
GROUP BY l.id
HAVING COUNT(*) > 1;

-- Query 4: COUNT(*) vs. COUNT(label_id)
-- Frage: Wie viele Künstler gibt es insgesamt im Vergleich zu Künstlern mit zugewiesenem Label?
-- Erklärung: COUNT(*) zählt ausnahmslos alle Zeilen der Tabelle, inklusive NULL-Werte (Ergebnis: 6).
-- COUNT(label_id) ignoriert Zeilen mit NULL in der Spalte label_id (Ergebnis: 5). Ein Künstler
-- hat somit kein Label eingetragen ("Ohne Label").
SELECT COUNT(*) AS kuenstler_gesamt, COUNT(label_id) AS kuenstler_mit_label 
FROM kuenstler;

-- Query 5: WHERE und HAVING kombiniert (Lange Songs je Künstler)
-- Frage: Welche Künstler haben mindestens zwei lange Songs mit einer Dauer von über 200 Sekunden?
-- Erklärung: Die WHERE-Bedingung filtert zuerst auf Zeilenebene alle Songs heraus, die <= 200s dauern.
-- Anschließend wird nach Künstler gruppiert, und HAVING COUNT(*) >= 2 stellt sicher, dass nur Künstler
-- ausgegeben werden, bei denen nach dem WHERE-Filter mindestens 2 Songs übrig geblieben sind.
SELECT k.name AS kuenstler, COUNT(*) AS anzahl_lange_songs
FROM kuenstler k 
JOIN song s ON s.kuenstler_id = k.id
WHERE s.dauer_sek > 200
GROUP BY k.id
HAVING COUNT(*) >= 2;
