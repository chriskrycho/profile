#!/usr/local/bin/python3
'''
Use pandoc_ and kindlegen_ (both of which you will have to install yourself) to
convert a Markdown file to a Mobipocket file suitable for use on a Kindle. The
script allows the user to specify an arbitrary destination for generated files.
Alternately, it provides a shortcut to deliver files to a Dropbox folder that is
hooked up to an IFTTT_ recipe_ to send the file to one of our Kindles.

The public function (``convert_to_kindle()``) is designed to be used outside the
script call, and so you can simply include md2kindle.py and call the public
function and it should work nicely.

To customize for your own use, simply change the options for ``KINDLE_DIR`` and
``KINDLE_CHOICES`` to values suitable for your own use and have fun.

.. _pandoc: http://johnmacfarlane.net/pandoc/
.. _kindlegen: http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000765211
.. _IFTTT: https://ifttt.com/
.. _recipe: https://ifttt.com/recipes/46047

LICENSE
=======

Copyright (c) 2013 Chris Krycho

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'''


import argparse
from datetime import datetime
import os, os.path
from subprocess import call, DEVNULL


KINDLE_DIR = '/Users/chris/Dropbox/public/kindle'
KINDLE_CHOICES = ['paperwhite', 'keyboard', 'test']


def convert_to_kindle(markdown_files, output_name=None, logfile=None, keep_epub=False):
    '''
    Convert a Markdown file at the specified path to a Mobipocket file, using
    pandoc and kindlegen.

    :param markdown_files: a list of files to convert
    :param output_name: optional name of file to generate (without extension)
    :param logfile: optional logfile to which to write info/error messages
    :param keep_epub: if True, will leave the epub file after running.
    :returns: path to the finished Mobipocket file.
    '''

    if isinstance(markdown_files, str):
        raise TypeError('Function convert_to_kindle requires the first element be a list, not a string.')

    default_name = 'generated-{}'.format(datetime.now().strftime('%Y%m%d_%H-%M-%S'))

    epub_name = output_name if output_name is not None else default_name
    epub_name += '.epub'

    pandoc = 'pandoc {md} -o {epub} -f markdown+mmd_title_block+pipe_tables+table_captions -t epub3 --ascii --smart --standalone --toc'
    pandoc = pandoc.format(md=' '.join(markdown_files), epub=epub_name)

    logfile = open(logfile, 'w') if logfile is not None else DEVNULL

    mobi_name = output_name if output_name is not None else default_name
    mobi_name += '.mobi'

    print('Generating {} from {}... '.format(epub_name, markdown_files), end='')
    call(pandoc, shell=True, stdout=logfile, stderr=logfile)
    print('done.')

    kindlegen = 'kindlegen {epub} -o {mobi}'.format(epub=epub_name, mobi=mobi_name)

    print('Generating {} from {}... '.format(mobi_name, epub_name), end='')
    call(kindlegen, shell=True, stdout=logfile, stderr=logfile)
    print('done.')

    if not keep_epub:
        print('Removing {}... '.format(epub_name), end='')
        os.remove(epub_name)
        print('done.')

    return os.path.abspath(mobi_name)


def __move_to_destination(mobi_file, kindle_name, output_dir):
    '''
    Move the Mobipocket file to the correct destination, either:

    - a Dropbox Kindle directory, specified by kindle_name, or
    - an arbitrary location specified by output_dir

    If kindle_name is supplied, output_dir will be ignored. Otherwise, the file
    will be moved to output_dir.
    '''
    src_path, src_file = os.path.split(mobi_file)

    if kindle_name is not None:
        dest_dir = os.path.join(KINDLE_DIR, kindle_name)
        dest = os.path.join(KINDLE_DIR, kindle_name, src_file)

    else:
        dest_dir = os.path.normpath(output_dir)
        dest = os.path.join(output_dir, src_file)

    if dest_dir is not os.path.curdir:
        print('Moving {} to {}... '.format(src_file, dest_dir), end='')
        os.rename(mobi_file, dest)
        print('done.')


def __process_args():
    '''
    Gets the user-supplied or default values for the path to the Markdown file,
    the Kindle for which to generate the output, and the name of the output file
    (if specified as different from the input file slug).
    '''
    desc = 'Convert Markdown documents to .mobi and deliver them to a Dropbox file for delivery via IFTTT.'

    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument('input', metavar='<input file>', action='store', nargs='+',
                        help='File location for the document to convert')
    parser.add_argument('-o', '--output', metavar='<output slug>', action='store', default=None,
                        help='Output slug, if different than the input. Extension will be ignored.')
    parser.add_argument('-l', '--logfile', metavar='<logfile>', action='store', default=None,
                        help='Supply a log file to write process logs (e.g. for `kindlegen`).')
    parser.add_argument('-e', '--keep_epub', action='store_true',
                        help='Do not remove the epub file after generating the Kindle file.')

    dest_group = parser.add_mutually_exclusive_group(required=True)
    dest_group.add_argument('-d', '--output-directory', action='store', dest='output_dir',
                            help='Specify an output directory for the generated file(s).')
    dest_group.add_argument('-k', '--kindle', action='store', choices=KINDLE_CHOICES,
                            help='Shortcut for moving the file to a Kindle directory for use with IFTTT.')


    return parser.parse_args()


if __name__ == '__main__':
    args = __process_args()
    mobi_file_with_path = convert_to_kindle(args.input, args.output, args.logfile, args.keep_epub)
    __move_to_destination(mobi_file_with_path, args.kindle, args.output_dir)
