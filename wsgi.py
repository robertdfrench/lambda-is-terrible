#!/usr/local/bin/python3
import sqlite3
from wsgiref.simple_server import make_server

def connect_to_db():
    dbh = sqlite3.connect("hit_counter.sqlite3")
    dbh.execute("CREATE TABLE IF NOT EXISTS counters(hits INTEGER, ip TEXT PRIMARY KEY)")
    return dbh

def generate_summary_of_visits(dbh):
    result = dbh.execute("SELECT SUM(hits), COUNT(*) from counters")
    (visits, visitors) = result.fetchone()
    return f"This page has been viewed {visits} times by {visitors} unique visitors"

def record_new_visit(dbh, ip):
    with dbh:
        dbh.execute("""
            INSERT INTO counters(hits,ip) VALUES(1,?)
            ON CONFLICT(ip) DO
            UPDATE SET hits = (counters.hits + 1) WHERE ip=?
            """, (ip, ip))

def hit_counter(environ, start_response):
    ip = '0.0.0.0'
    record_new_visit(dbh, ip)
    summary = generate_summary_of_visits(dbh)

    status = '200 OK'
    headers = [('Content-type', 'text/plain; charset=utf-8')]
    start_response(status, headers)
    return [summary.encode('utf-8')]

# Init
dbh = connect_to_db()
with make_server('', 8000, hit_counter) as httpd:
    print("Serving on port 8000...")
    httpd.serve_forever()
