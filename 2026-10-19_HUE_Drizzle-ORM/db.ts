// db.ts — Verbindung zur SQLite-Datenbank + Tabellen-Anlage (DDL).
// Deno bleibt die Runtime: node:sqlite ist eingebaut, drizzle-orm ist
// reines TypeScript (npm:-Specifier), es gibt kein node_modules und
// keinen Node-Zwang. Version gepinnt: drizzle-orm 1.0.0-rc.4.
import { DatabaseSync } from "node:sqlite";
import { drizzle } from "drizzle-orm/node-sqlite";

// Deno StatementSync compatibility for Drizzle ORM node-sqlite
const _dummyStmt = new DatabaseSync(":memory:").prepare("SELECT 1");
const StatementSyncProto = Object.getPrototypeOf(_dummyStmt);
if (!StatementSyncProto.setReturnArrays) {
  StatementSyncProto.setReturnArrays = function (returnArrays: boolean) {
    (this as any)._returnArrays = returnArrays;
  };
  const origAll = StatementSyncProto.all;
  StatementSyncProto.all = function (...args: any[]) {
    const res = origAll.apply(this, args);
    if ((this as any)._returnArrays && Array.isArray(res)) {
      return res.map((row: any) => Object.values(row));
    }
    return res;
  };
  const origGet = StatementSyncProto.get;
  StatementSyncProto.get = function (...args: any[]) {
    const res = origGet.apply(this, args);
    if ((this as any)._returnArrays && res && typeof res === "object") {
      return Object.values(res);
    }
    return res;
  };
}

// Drizzle kennt das Schema über die Tabellen-Objekte aus schema.ts —
// daraus erzeugt es typsichere Queries. Die DDL hier hält die DB synchron
// mit dem Schema (bis Migrationen mit drizzle-kit Thema werden).
const DDL = [
  `CREATE TABLE IF NOT EXISTS artist (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     name TEXT NOT NULL,
     gruendungsjahr INTEGER)`,
  `CREATE TABLE IF NOT EXISTS album (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     titel TEXT NOT NULL,
     jahr INTEGER,
     artist_id INTEGER NOT NULL REFERENCES artist(id))`,
  `CREATE TABLE IF NOT EXISTS track (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     titel TEXT NOT NULL,
     dauer_sek INTEGER NOT NULL,
     album_id INTEGER NOT NULL REFERENCES album(id))`,
];

export function oeffneDb(pfad: string) {
  const client = new DatabaseSync(pfad);
  for (const anweisung of DDL) {
    client.exec(anweisung);
  }
  return drizzle({ client });
}
