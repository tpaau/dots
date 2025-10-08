#!/usr/bin/python3

import sys
import psutil
import time

if __name__ == "__main__":
    if not hasattr(psutil, "sensors_temperatures"):
        sys.exit("platform not supported")
    while True:
        temps = psutil.sensors_temperatures()
        cpu_temp = round(temps["coretemp"][0].current)
        print(cpu_temp)
        sys.stdout.flush()
        time.sleep(5)

