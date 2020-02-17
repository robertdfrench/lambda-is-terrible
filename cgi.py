#!/usr/local/bin/python3
import sqlite3
import os

def connect_to_db():
    dbh = sqlite3.connect("hit_counter.sqlite3")
    dbh.execute("CREATE TABLE IF NOT EXISTS counters(hits INTEGER, ip TEXT PRIMARY KEY)")
    return dbh

def generate_summary_of_visits(dbh):
    result = dbh.execute("SELECT SUM(hits), COUNT(*) from counters")
    (views, visitors) = result.fetchone()
    return f"This page has been viewed {views} times by {visitors} unique visitors"

def record_new_visit(dbh, ip):
    with dbh:
        dbh.execute("""
            INSERT INTO counters(hits,ip) VALUES(1,?)
            ON CONFLICT(ip) DO
            UPDATE SET hits = (counters.hits + 1) WHERE ip=?
            """, (ip, ip))

def hit_counter(environ):
    ip = environ['REMOTE_ADDR']
    record_new_visit(dbh, ip)
    summary = generate_summary_of_visits(dbh)

    print("Content-Type: text/plain\n")
    print(summary)

# Init
dbh = connect_to_db()
hit_counter(os.environ)
