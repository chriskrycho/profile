#!/usr/bin/env python3
"""Generate a new micro post in chriskrycho.com.

Note: this is *incredibly* specific to my current configuration.
"""

import argparse
from datetime import datetime
from functools import lru_cache
import os
from pathlib import Path
import subprocess
import sys


# Define default location in which to generate the file.
HOME = Path(os.environ['HOME'])
SITE = HOME / 'Sites' / 'chriskrycho.com' / 'current'
CONTENT = SITE / 'content'
MICRO = SITE / 'content' / 'micro'

# Existing formats.
# TODO: create a mapping from post type to internal fields, e.g.:
#       {'class': ['Class', 'Professor', 'School']}
POST_TYPES = ['blog', 'class', 'devotions', 'link', 'micro', 'quotations', 
              'republish', 'school']
DEFAULT_POST_TYPE = 'blog'

# Define default text for the file.
TEMPLATE = "---\nTitle: {title}\nDate: {date}\n"
TEMPLATE_END = """...\n\n"""
TEMPLATE_CATEGORY = "Category: {category}\n"
TEMPLATE_TAGS = "Tags: {tags}\n"
TEMPLATE_TYPE = "Template: formats/{type}\n"

# Date formatting
DATE_COMMON = "{:04}-{:02}-{:02}"


def generate_post(args=None):
    args = args if args is not None else __parse_args()
    
    directory = __get_directory(args.category)
    file_name = __get_file_name(args.name)
    header = __get_header(args.name, args.category, args.tags, args.type)
    body = __get_body(args.direct_input)
    
    content = header + body
    path = directory / file_name
    print(content, path); exit()
    with path.open('w') as f:
        f.write(content)

    # Edit the post if it was not generated via direct input.
    if not args.direct_input:
        edit_line = len(content.splitlines())
        subprocess.call([args.editor, str(file_name) + ':{}'.format(edit_line)])


def __get_directory(category=None):
    # Start with the blog content directory.
    directory = CONTENT

    # Micro post type always corresponds to the microblog category.
    if type == 'micro':
        directory /= type

    # Otherwise, an actual category may be allowed.
    elif category is not None:
        directory /= category
    if category is None:
        if type is None:
            directory = CONTENT

        elif type == 'micro':
            directory = CONTENT
    directory = CONTENT if category is None else CONTENT / category
    return directory


def __get_body(use_input):
    if use_input:
        print("Body text:")
        text = sys.stdin.read()
    else:
        text = ''
    
    return text


def __get_header(name=None, category=None, tags=None, type=None):
    """Build the header string to render into the file.
    
    Args:
        name: The file name.
        category: The category in which to file the post. 
        tags: Any tags associated with the post.
        type: The post type (format) to use with the post.

    Returns:
        A fully populated YAML header.

    The header will be styled so (whitespace included intentionally as it *is*
    part of the generated header):
        
    ```YAML
    ---
    Title: <the title>
    Date: <the date>
    Category: <the category specified as an argument>
    Tags: <the tags specified as arguments>
    Template: formats/<post type specified as an argument>
    ...


    ```

    Note:
        The `Category`, `Tags`, and `Template` sections will *not* be generated
        in the case that the corresponding arguments are left empty. The `Title`
        field will always be populated; if no `name` argument is supplied the
        date value will be used instead.

    """
    time = __get_time()
    date = DATE_COMMON + " {:02}:{:02}"
    date = date.format(time.year, time.month, time.day, time.hour, time.minute)
    
    title = name if name is not None else date
    header = TEMPLATE.format(title=title, date=date)
    
    if category is not None and type != 'micro':
        header += TEMPLATE_CATEGORY.format(category=category)

    if tags is not None:
        header += TEMPLATE_TAGS.format(tags=tags)

    if type != DEFAULT_POST_TYPE:
        header += TEMPLATE_TYPE.format(type=type)

    header += TEMPLATE_END
    return header


def __get_file_name(name=None):
    if name:
        return name

    else:
        time = __get_time()
        name = DATE_COMMON + "-{:02}{:02}"
        name = name.format(time.year, time.month, time.day, time.hour, time.minute)
        return name
        

@lru_cache(maxsize=None)
def __get_time():
    """Generate a (single!) timestamp for use with the files.
    
    Returns:
        A `datetime.datetime` object.

    Note:
        The `@lru_cache` call with a zero-argument function memoizes (caches)
        the first time the function is called.

    """
    return datetime.now()


def __parse_args():
    parser = argparse.ArgumentParser()

    # Positional
    parser.add_argument('type', help='The kind of post to generate.',
                        choices=POST_TYPES, default=DEFAULT_POST_TYPE)

    # Optional
    parser.add_argument('-c', '--category',
                        help='The category of the post. NOTE: will be ' +
                             'overridden if the post type is `micro`.')
    parser.add_argument('-t', '--tags', help='Tags associated with the post.')
    parser.add_argument('-n', '--name', help='Specify the file name to use.')
    
    input_group = parser.add_mutually_exclusive_group()
    exclusion =  ' Note: -i and -e are mutually exclusive.'
    input_group.add_argument('-e', '--editor',
                             help='Specify an editor to use.' + exclusion,
                             default='subl')
    input_group.add_argument('-i', '--direct-input', 
                             help='Supply input text directly.' + exclusion,
                             action='store_true',
                             default=False)

    return parser.parse_args()


if __name__ == '__main__':
    generate_post()
