import time
import argparse

text_1KB = "0" * 1024
text_1MB = "0" * 1024 * 1024


def print_1M():
    print(text_1MB)
    pass


def print_100M():
    for i in range(100):
        print(text_1MB)
    pass


def wait_forever():
    while True:
        time.sleep(1*10)
    pass


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--log-size', dest='log_size', type=int, required=True, help='print how many logs(unit MB)')
    args = parser.parse_args()
    return args


def main(args):
    i = 0
    log_size = args.log_size
    while i < log_size:
        i += 1
        print_1M()
        time.sleep(0.01)

    wait_forever()
    pass


if __name__ == "__main__":
    args = parse_args()
    main(args)
    pass
