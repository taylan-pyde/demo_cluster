import redis
import time
import random
import socket

pod_name = socket.gethostname()
r = redis.Redis(host='redis', port=6379)

while True:
    i = r.incr('global_message_id')
    msg = f"message-{i} from {pod_name}"
    r.lpush('myqueue', msg)
    randomtime = random.randint(2,5)
    print(f"Provider pushed: {msg}, sleeps {randomtime} seconds.")
    time.sleep(randomtime)