import redis
import time

r = redis.Redis(host='redis', port=6379)

while True:
    msg = r.rpop('myqueue')
    queue_size = r.llen('myqueue')
    if msg:
        print(f"Consumer got: {msg.decode()}, {queue_size} messages left.")
    else:
        print("Consumer waiting...")
    time.sleep(1)
