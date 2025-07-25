import requests, random

def get_users():
    return requests.get('http://fastapi-app:8000/users')

def post_random_user():
    user = {
        "username": f"user{random.randint(1, 100)}",
        "password": f"password{random.randint(1, 100)}"
    }
    return requests.post('http://fastapi-app:8000/users/add_user', json=user)

def main():
    while True:
        get_users()
        post_random_user()
        time.sleep(random.randint(1, 5))

if __name__ == "__main__":
    main()