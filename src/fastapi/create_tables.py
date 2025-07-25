import sqlite3


conn = sqlite3.connect('/data/database.db')
cursor = conn.cursor()

cursor.execute("""
CREATE TABLE IF NOT EXISTS USERS (
    userid TEXT PRIMARY KEY,
    username TEXT NOT NULL,
    password TEXT NOT NULL
)
""")

conn.commit()
conn.close()