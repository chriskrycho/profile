#!/usr/local/bin/python3

from subprocess import call
import os

# Create a file to compare against and set its timestamp to 20 minutes ago
compare_file = "20min"
call(["touch", compare_file])
call(["touch", "-A", "-2000", compare_file])

compare_mtime = os.path.getmtime("20min")

kindle_dir = "/Users/chris/Dropbox/Public/kindle"
for root, folder, files in os.walk(kindle_dir):
    for f in files:
        file_path = os.path.join(root,f)
        file_mtime = os.path.getmtime(file_path)
        if (file_mtime <= compare_mtime):
            os.remove(file_path)

os.remove(compare_file)