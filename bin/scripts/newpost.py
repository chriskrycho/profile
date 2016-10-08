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

# Existing formats.
# TODO: create a mapping from post type to internal fields, e.g.:
#       {'class': ['Class', 'Professor', 'School']}
POST_TYPES = ['blog', 'class', 'devotions', 'link', 'micro', 'quotations',
              'republish', 'school']
DEFAULT_POST_TYPE = 'blog'

# Define default text for the file.
TEMPLATE = "---\nTitle: {title}\nDate: {date}\n"
TEMPLATE_END = "---\n\n"
TEMPLATE_CATEGORY = "Category: {category}\n"
TEMPLATE_TAGS = "Tags: {tags}\n"
TEMPLATE_SLUG = "Slug: {slug}\n"
TEMPLATE_TYPE = "Template: formats/{post_type}\n"
TEMPLATE_DRAFT = "Status: draft\n"

# Date formatting
DATE_COMMON = "{:04}-{:02}-{:02}"


def generate_post(args=None):
    args = args if args is not None else __parse_args()

    fmt_times = __get_date_formats()

    base_directory = __get_dir(fmt_times['dir'], args.category, args.post_type)
    file_name = args.name if args.name else fmt_times['file']
    header = __get_header(fmt_times, **vars(args))
    body = __get_body(args.direct_input)

    content = header + body
    path = (base_directory / file_name).with_suffix('.md')

    if not base_directory.exists():
        base_directory.mkdir(parents=True)

    with path.open('w') as f:
        f.write(content)

    # Edit the post if it was not generated via direct input.
    if not args.direct_input:
        edit_line = len(content.splitlines())
        subprocess.call([args.editor, str(path) + ':{}'.format(edit_line)])

def __get_date_formats():
    t = __get_time()
    formatted = {}

    meta_fmt = DATE_COMMON + " {:02}:{:02}"
    formatted['meta'] = meta_fmt.format(t.year, t.month, t.day, t.hour, t.minute)

    file_fmt = "{:02}-{:02}{:02}"
    formatted['file'] = file_fmt.format(t.day, t.hour, t.minute)

    slug_fmt = "{:02}-{:02}-{:02}{:02}"
    formatted['slug'] = slug_fmt.format(t.month, t.day, t.hour, t.minute)

    dir_fmt = "{:02}/{:02}"
    formatted['dir'] = dir_fmt.format(t.year, t.month)

    return formatted


def __get_dir(date_for_dir, category=None, post_type=None):
    # Start with the blog content directory.
    directory = CONTENT

    # Micro post type always corresponds to the microblog category.
    if post_type == 'micro':
        directory /= post_type / Path(date_for_dir)

    # Otherwise, an actual category may be allowed.
    elif category is not None:
        directory /= category

    return directory


def __get_body(use_input):
    if use_input:
        print("Body text:")
        text = sys.stdin.read()
    else:
        text = ''

    return text


def __get_header(formatted_times: dict,
                 name: str = None,
                 category: str = None,
                 tags: str = None,
                 slug: str = None,
                 post_type: str = None,
                 title: str = None,
                 draft: bool = False,
                 **kwargs) -> str:
    """Build the header string to render into the file.

    Args:
        formatted_times: the different time stamp formats available
        name: The file name.
        category: The category in which to file the post.
        tags: Any tags associated with the post.
        post_type: The post type (format) to use with the post.
        title: The title of the post.
        kwargs: Any other args specified by the user (ignored)

    Returns:
        A fully populated YAML header.

    The header will be styled so (whitespace included intentionally as it *is*
    part of the generated header), with optional elements wrapped in `[...]`:

    ```YAML
    ---
    Title: [<the title>]
    Date: <the date>
    [Slug: <the specified or, for microblog posts, date as slug>]
    [Category: <the category specified as an argument>]
    [Tags: <the tags specified as arguments>]
    [Template: formats/<post type specified as an argument>]
    ---

    ```

    Note:
        The `Category`, `Tags`, and `Template` sections will *not* be generated
        in the case that the corresponding arguments are left empty. The `Title`
        field will always be populated; if no `name` argument is supplied the
        date value will be used instead.

    """
    title = title if title is not None else '""'
    header = TEMPLATE.format(title=title, date=formatted_times['meta'])

    if tags is not None:
        header += TEMPLATE_TAGS.format(tags=tags)

    if post_type != DEFAULT_POST_TYPE:
        header += TEMPLATE_TYPE.format(post_type=post_type)

    # Microblog posts are a special case for category and slug.
    if post_type == 'micro':
        header += TEMPLATE_SLUG.format(slug=formatted_times['slug'])
        header += TEMPLATE_CATEGORY.format(category=post_type)

    else:
        if slug:
            header += TEMPLATE_SLUG.format()

        if category is not None:
            header += TEMPLATE_CATEGORY.format(category=category)

    if draft:
        header += TEMPLATE_DRAFT

    header += TEMPLATE_END
    return header


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
    parser.add_argument('post_type',
                        help='The kind of post to generate.',
                        choices=POST_TYPES,
                        default=DEFAULT_POST_TYPE)

    # Optional
    parser.add_argument('-c', '--category',
                        help='The category of the post. NOTE: will be ' +
                             'overridden if the post type is `micro`.')
    parser.add_argument('-t', '--tags', help='Tags associated with the post.')
    parser.add_argument('-n', '--name', help='Specify the file name to use.')
    parser.add_argument('--title', help='The post title')
    parser.add_argument('--draft', help='Create the post as a "draft"',
                        action='store_true', default=False)

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
