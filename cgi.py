#!/usr/local/bin/python3
import sqlite3
import os

# Connect to the database
conn = sqlite3.connect("hit_counter.sqlite3")
dbh = conn.cursor()

# Make sure our table exists
dbh.execute("""
    CREATE TABLE IF NOT EXISTS
    counters(hits INTEGER, ip TEXT PRIMARY KEY)
    """)

# Increment a counter based on the client's IP
ip = os.environ['REMOTE_ADDR']
dbh.execute("""
    INSERT INTO counters(hits,ip) VALUES(1,?)
    ON CONFLICT(ip) DO
    UPDATE SET hits = (counters.hits + 1) WHERE ip=?
    """, (ip, ip))
conn.commit()

# Print the total number of visitors
dbh.execute("SELECT total(hits),count(*) FROM counters")
(views, visitors) = dbh.fetchone()
print("Content-Type: text/plain\n")
print(f"This page has been viewed {views} times")
print(f"by {visitors} unique visitors!")
