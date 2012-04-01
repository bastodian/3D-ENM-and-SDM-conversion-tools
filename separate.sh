#!/bin/bash

#    This script separates a combined ASCII grid file. You need to specifiy into how
#    many files the combined ASCII should be split.
#
#    Call script as follows:
#
#    ./combineASCII.sh /path/to/input/file /path/to/output num_of_files
#    
#    eg:
#    ./combineASCII.sh /path/to/input/file.asc /path/to/output 12
#
#    Author: Bastian Bentlage
#    Email: bastodian@gmail.com
#    License: Creative Commons Attribution

INFILE=$1
OUTPATH=$2
NUMFILES=$3

NCOLS=`grep 'ncols' $INFILE`
NROWS=`grep 'nrows' $INFILE | awk '{ print $2 }'`
XLLCORNER=`grep 'xllcorner' $INFILE`
YLLCORNER=`grep 'yllcorner' $INFILE`
CELLSIZE=`grep 'cellsize' $INFILE`
NODATA=`grep 'NODATA_value' $INFILE`

NROWSnew=`printf $[$NROWS / $NUMFILES]`
TAIL=`printf $[$NROWSnew * $NUMFILES]`
OUTFILE=$OUTPATH/${INFILE/.*}

let NUM=$NUMFILES i=1
while ((i<=NUM))
do
    printf "%b\n" "$NCOLS" "nrows\t$NROWSnew" "$XLLCORNER" "$YLLCORNER" "$CELLSIZE" "$NODATA" > $OUTFILE_$i.asc
    tail -n $TAIL $INFILE | head -n $NROWSnew >> $OUTFILE_$i.asc
    TAIL=`printf $[$TAIL - $NROWSnew]`
    let i++
done
