import uvicorn, sqlite3, uuid
from fastapi import FastAPI
from pydantic import BaseModel
import signal, sys

app = FastAPI()


def handle_sigterm(signum, frame):
    print("Received SIGTERM, exiting now.")
    sys.exit(0)  # Exit immediately without waiting

# Register signal handler
signal.signal(signal.SIGTERM, handle_sigterm)
signal.signal(signal.SIGINT, handle_sigterm)  # Optional: Ctrl+C too

class UserPost(BaseModel):
    username: str
    password: str

@app.get("/")
def index():
    hehe = "haha new image too"
    return {"result": "INDEX PAGE"}

@app.get("/users")
def users():
    conn = sqlite3.connect('/data/database.db')
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()
    return {"result": users}

@app.post("/users/add_user")
def add_user(user: UserPost):
    conn = sqlite3.connect('/data/database.db')
    cursor = conn.cursor()
    new_id = str(uuid.uuid4())
    cursor.execute("INSERT INTO users (userid, username, password) VALUES (?, ?, ?)", (new_id, user.username, user.password))
    conn.commit()
    return {"result": "User added", "data":{
        "username": user.username,
        "password": user.password,
        "userid": new_id
    }}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000)