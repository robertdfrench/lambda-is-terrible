#!/usr/local/bin/python3
import sqlite3
import sys

ip = sys.argv[1]
conn = sqlite3.connect("hit_counter.sqlite3")
dbh = conn.cursor()
dbh.execute("""
    CREATE TABLE IF NOT EXISTS
    counters(hits INTEGER, ip TEXT PRIMARY KEY)
    """)
dbh.execute("""
    INSERT INTO counters(hits,ip) VALUES(0,?)
    ON CONFLICT(ip) DO
    UPDATE SET hits = (counters.hits + 1) WHERE ip=?
    """, (ip, ip))
dbh.execute("""
    SELECT hits,ip FROM counters WHERE ip=?
    """, (ip,))
print(dbh.fetchone())
conn.commit()
