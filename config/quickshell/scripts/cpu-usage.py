#!/usr/bin/env python

import psutil
from sys import stdout

if __name__ == "__main__":
    while True:
        print(psutil.cpu_percent(interval=0.2))
        stdout.flush()
