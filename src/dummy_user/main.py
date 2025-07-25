import requests, random, time, signal, sys

MAIN_URL = 'http://fastapi-service:8000'

def get_users():
    print("Fetching users...")
    return requests.get(f'{MAIN_URL}/users')

def post_random_user():
    user = {
        "username": f"user{random.randint(1, 100)}",
        "password": f"password{random.randint(1, 100)}"
    }
    print(f"Posting user: {user}")
    return requests.post(f'{MAIN_URL}/users/add_user', json=user)

def main():
    while True:
        get_users()
        post_random_user()
        time.sleep(random.randint(1, 5))

if __name__ == "__main__":
    main()