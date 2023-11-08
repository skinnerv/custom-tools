#!/bin/bash
# Bash script to examine the scan results through HTML.
#
echo "<HTML><BODY><BR>" > web.html

ls -1 *.png | awk -F : '{ print $1":\n<BR><IMG SRC=\""$1""$2"\" width=600><BR>"}' >> web.html

echo "</BODY></HTML>" >> web.html

#one liner:
echo "<HTML><BODY><BR>" > web.html && for file in *.png; do echo -e "$file:\n<BR><IMG SRC=\"$file\" width=600><BR>"; done >> web.html && echo "</BODY></HTML>" >> web.html
