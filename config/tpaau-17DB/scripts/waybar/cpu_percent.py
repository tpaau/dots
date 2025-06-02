#!/usr/bin/env python3

import psutil
import sys

def print_bar(value, max_value, length = 16, fill = '#', empty = "-", show_percent = False):
    """
    Show a nice bar showing CPU usage.
    """
    percent = value / max_value
    filled_length = int(length * percent)
    loading_bar = fill * filled_length + empty * (length - filled_length)
    if show_percent:
        print(f' {(percent * 100):.1f}% [{loading_bar}]')
    else:
        print(f' [{loading_bar}]')

    sys.stdout.flush()

if __name__ == "__main__":
    while True:
        cpu_usage = psutil.cpu_percent(interval=0.1)
        print_bar(cpu_usage, 100)
