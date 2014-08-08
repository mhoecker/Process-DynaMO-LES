#!/bin/bash
# uses nco to match variable and dimension names in a MIMOC v 2.2 file
USAGE="renamevars MIMOCV2.2file.nc"

if [ "$#" == "0" ]; then
	echo "$USAGE"
	exit 1
fi

while (( "$#" )); do
#Get the file suffix
SFX=${1##*.}
# Check if the suffix is "nc"
if [[ $SFX == "nc" ]]; then
# Get the file name not including the extension
	PFX=${1%.*}
# Create a dummy file to hold the data with renamed variables
	NEWFILE=${1%.*}_new.$SFX
	echo "Renaming dimensions in $1"
# ncrename Syntax used is
# ncrename -d oldname,newname oldfile newfile
# Test if
	if ncdump -h -v PRESSURE $1 ;then
	 echo "$HASPRESS means LAT,LON,PRES in $1"
		ncrename -d LAT,LATITUDE -d LONG,LONGITUDE -d PRES,PRESSURE $1 $NEWFILE
	else
	 echo "Renaming LAT,LON in $1"
		ncrename -d LAT,LATITUDE -d LONG,LONGITUDE $1 $NEWFILE
	fi
 ncdump -h $NEWFILE
#	uncomment to just replace the file
#	mv $NEWFILE $1
	else
	# Tell the user that the file does not end in ".nc"
	echo "$1 does not end in .nc"
	echo "Did you forget to uncompress it?"
fi

shift

done
