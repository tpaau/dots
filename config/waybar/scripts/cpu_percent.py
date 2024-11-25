#!/usr/bin/python3

import psutil
import sys

def print_loading_bar(value, max_value, length = 30, fill = '#'):
    """
    Method used to quickly create loading bars
    """
    percent = value / max_value
    filled_length = int(length * percent)
    loading_bar = fill * filled_length + '-' * (length - filled_length)
    print(f' [{loading_bar}]')
    sys.stdout.flush()

def print_cpu_usage():
    while True:
        cpu_usage = psutil.cpu_percent(interval=1)
        print_loading_bar(cpu_usage, 100)

if __name__ == "__main__":
    print_cpu_usage()
