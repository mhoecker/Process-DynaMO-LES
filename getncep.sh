#!/bin/bash
# Download a buch of ncep wind files from ESRL
# ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis/surface_gauss/uwnd.10m.gauss.1948.nc
# ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis/surface_gauss/vwnd.10m.gauss.1948.nc
NCEPURL="ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis/surface_gauss/"
DATDIR="/home/mhoecker/work/Dynamo/output/ncep.reanalysis/"
VWND="vwnd.10m.gauss."
UWND="uwnd.10m.gauss."
HWND="uvwnd.10m.gauss."
YEARS="2011
2012
2013
2014"

for year in $YEARS
do
 wget -nc --limit-rate=256k -P $DATDIR $NCEPURL$VWND$year.nc
 wget -nc --limit-rate=256k -P $DATDIR $NCEPURL$UWND$year.nc
 ncks -A $DATDIR$UWND$year.nc $DATDIR$HWND$year.nc
 ncks -A $DATDIR$VWND$year.nc $DATDIR$HWND$year.nc
 ncrcat $DATDIR$HWND.$year.nc $DATDIR$HWND.nc
done
