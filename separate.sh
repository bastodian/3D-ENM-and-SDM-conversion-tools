#!/bin/bash

#    This script separates a combined ASCII grid file. You need to specifiy into how
#    many files the combined ASCII should be split.
#
#    Call script as follows:
#
#    ./separate.sh /path/to/input/file /path/to/output num_of_files
#    
#    eg:
#    ./separate.sh /path/to/input/file.asc /path/to/output 12
#
#    Author: Bastian Bentlage
#    Email: bastian.bentlage@gmail.com
#    License: Creative Commons Attribution

INFILE=$1
OUTPATH=$2
NUMFILES=$3

NCOLS=`grep 'ncols' $INFILE | tr -d '\r'`
NROWS=`grep 'nrows' $INFILE | tr -d '\r' | awk '{ print $2 }'`
XLLCORNER=`grep 'xllcorner' $INFILE | tr -d '\r'`
YLLCORNER=`grep 'yllcorner' $INFILE | tr -d '\r'`
CELLSIZE=`grep 'cellsize' $INFILE | tr -d '\r'`
NODATA=`grep 'NODATA_value' $INFILE | tr -d '\r'`

NROWSnew=`printf "%d\n" $[$NROWS / $NUMFILES]`
TAIL=`printf "%d\n" $[$NROWSnew * $NUMFILES]`
OUTFILE=$OUTPATH/${INFILE/.*}

let NUM=$NUMFILES i=1
while ((i<=NUM))
do
    printf "%b\n" "$NCOLS" "nrows\t$NROWSnew" "$XLLCORNER" "$YLLCORNER" "$CELLSIZE" "$NODATA" > $OUTFILE_$i.asc
    tail -n $TAIL $INFILE | head -n $NROWSnew >> $OUTFILE_$i.asc
    TAIL=`expr $TAIL - $NROWSnew`
    let i++
done
