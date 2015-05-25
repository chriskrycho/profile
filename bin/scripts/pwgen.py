#!/usr/local/bin/python
import random
import string
import sys


def genpw(length=12):
    options = string.ascii_letters + string.digits + string.punctuation
    characters = [random.choice(options) for x in range(length)]
    print(''.join(characters))


def handle_input():
    argc = len(sys.argv)
    if argc > 2:
        usage()
    elif argc == 2:
        try:
            length = int(sys.argv[1])
            genpw(length)
        except ValueError:
            usage()
    else:
        genpw()


def usage():
    print('Usage: pwgen [password length (integer)]')
    exit()


if __name__ == '__main__':
    handle_input()
