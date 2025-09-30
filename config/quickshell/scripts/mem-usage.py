#!/usr/bin/python3

import sys
import time
import psutil

if __name__ == "__main__":
    while True:
        mem = round(psutil.virtual_memory().percent)
        print(mem)
        sys.stdout.flush()
        time.sleep(5)
