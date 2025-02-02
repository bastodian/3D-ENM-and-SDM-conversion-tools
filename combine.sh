#!/bin/bash

#    This script combines ASCII grid files. ASCII grid files should be numbered to assure that they
#    will be combined in the right order (eg, 1.asc, 2.asc,..., n.asc).
#
#    Call script as follows:
#
#    ./combineASCII.sh /path/to/ASCII/files outputfile.asc
#
#    Author: Bastian Bentlage
#    Email: bastian.bentlage@gmail.com
#    License: Creative Commons Attribution

ASCII=$1
OUTFILE=$2
POS=-1
declare -a FILES=()

for FILE in $ASCII/*asc
do 
     POS=`expr $POS + 1`
     FILES[$POS]=$FILE
done

NCOLS=`grep 'ncols' ${FILES[0]} | tr -d '\r'`
NROWS=`grep 'nrows' ${FILES[0]} | tr -d '\r' | awk '{ print $2 }'`
XLLCORNER=`grep 'xllcorner' ${FILES[0]} | tr -d '\r'`
YLLCORNER=`grep 'yllcorner' ${FILES[0]} | tr -d '\r'`
CELLSIZE=`grep 'cellsize' ${FILES[0]} | tr -d '\r'`
NODATA=`grep 'NODATA_value' ${FILES[0]} | tr -d '\r'`

NROWSnew=`printf $[$NROWS * ${#FILES[@]}]`

printf "%b\n" "$NCOLS" "nrows\t$NROWSnew" "$XLLCORNER" "$YLLCORNER" "$CELLSIZE" "$NODATA" > $OUTFILE

for file in ${FILES[@]}
do
    tail -n +7 $file >> $OUTFILE
done
