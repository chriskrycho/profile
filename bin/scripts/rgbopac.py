#!/usr/local/bin/python
import string
import argparse

'''
Command line tool for converting various directions with Hex and RGB.
Color = Color * alpha + Bkg * (1 - alpha);
'''

def rgb_to_hex(rgb):
    hex_r = ''
    hex_g = ''
    hex_b = ''

    return hex_r + hex_g + hex_c

def hex_to_rgb(hex):
    r = ''
    g = ''
    b = ''
    return r, g, b

def rgba_to_hex(rgba, background_rgba):
    hex_r = ''
    hex_g = ''
    hex_b = ''

    pass

def parse():
    to_options = from_options = ['rgb', 'rgba', 'hex', 'hex-opacity']

    parser = argparse.ArgumentParser(prog='rgb_hex', description='Process RGB-Hex converter arguments')
    parser.add_argument(
        '-f', '--from',
        help='Convert from RGB to hex',
        required=True,
        choices=from_options)
    parser.add_argument('-t', '--to',
        help='Convert from hex to RGB',
        required=True,
        choices=to_options)

    parser.parse_args()

def main():
    parse()

if __name__ == '__main__':
    main()