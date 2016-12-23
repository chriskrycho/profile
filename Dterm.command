#!/bin/bash
env SHELL=/bin/bash TERM=dterm open /Applications/DTerm.app &
osascript -e 'quit app "Terminal"'
exit 0;
