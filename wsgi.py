#!/usr/local/bin/python3
import sqlite3
from wsgiref.simple_server import make_server

conn = sqlite3.connect("hit_counter.sqlite3")

def hit_counter(environ, start_response):
    status = '200 OK'
    headers = [('Content-type', 'text/plain; charset=utf-8')]
    start_response(status, headers)

    ip = '0.0.0.0'
    with conn:
        conn.execute("""
        INSERT INTO counters(hits,ip) VALUES(1,?)
        ON CONFLICT(ip) DO
        UPDATE SET hits = (counters.hits + 1) WHERE ip=?
        """, (ip, ip))
    result = conn.execute("SELECT SUM(hits), COUNT(*) from counters")
    (visits, visitors) = result.fetchone()
    response = f"This page has been viewed {visits} times by {visitors} unique visitors"
    return [response.encode('utf-8')]

conn.execute("CREATE TABLE IF NOT EXISTS counters(hits INTEGER, ip TEXT PRIMARY KEY)")
with make_server('', 8000, hit_counter) as httpd:
    print("Serving on port 8000...")
    httpd.serve_forever()
