#!/bin/sh
# $1: Folder containing Objective-C code (CODE_FOLDER_NAME)

UNCRUSTIFY_HEADER=uncrustify_header.txt

touch ${UNCRUSTIFY_HEADER} #Uncrustify complains without it
set +e
## about uncrustify
# run `brew install uncrustify` to install
# -L 2 : output errors
# -l OC : override Objective C

## apply uncrustify to every .h and .m found in $1
find $1 -name '*.h' -o -name '*.m' -exec uncrustify -L 2 -l OC --no-backup --replace -c ./uncrustify.cfg {} ';'

set -e
rm ${UNCRUSTIFY_HEADER}