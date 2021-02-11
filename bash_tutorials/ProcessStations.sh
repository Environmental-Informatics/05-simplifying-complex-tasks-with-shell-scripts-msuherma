#!/bin/bash
# Mukhamad Suhermanto
# ABE651
##########################
# This codes contains 3 parts, namely:
#			1. Identifying and separating High Elevation stations from others
#			2. Preparing Longitude-Latitude values input
#			3. Plotting the location of all station
##########################

# Part 1: { Identifying and separating High Elevation stations from others.}

# 1.1 Checking the StationData directory existence:
if [ -d "StationData" ]
then 
	echo -e "StationData directory already exists"
else
	mkdir StationData
fi

# 1.2 Identifying the stations with altitude => 200 ft
#	1.2.1 Checking HigherElevation dir existence

if [ -d "HigherElevation" ]
then 
	echo -e "HigherElevation directory already exists"
else
	mkdir HigherElevation
fi

#   1.2.2 Copying the stations with elevation 200 ft
for file in StationData/*
do
        if
	grep 'Altitude: [>200]' $file # For files > 200 ft in StationData dir 
	then
	        fileName=`basename $file` # using basename 
		cp $file HigherElevation/$fileName # Copy-paste file into HighElevation dir
	fi
done
echo "Copy-pasting files into HigherElevation for values >200 ft has been completed"

echo

# Part 2: { Preparing Longitude-Latitude values input }
# 2.1.1 Getting Long-Lat from files in StationData
awk '/Longitude/ {print -1 * $NF}' StationData/Station_*.txt > Long.list
awk '/Latitude/ {print  $NF}' StationData/Station_*.txt > Lat.list

# 2.1.2 Inputing values of the Long-Lat into a new file
paste Long.list Lat.list > AllStations.xy

# 2.2.1 Getting Long-Lat from files in HigherElevation
awk '/Longitude/ {print -1 * $NF}' StationData/Station_*.txt > HELong.list
awk '/Latitude/ {print  $NF}' StationData/Station_*.txt > HELat.list

# 2.2.2 Inputing values of the Long-Lat into a new file (2)
paste HELong.list HELat.list > HEStations.xy

# Part 3: { Plotting the location of all station }
# 3.1 Loading Module Required for processing
module load gmt

# 3.2 Creating Plots
# 3.2.1 Using 'gmt pscoast' draws land and water surface
#		Source: http://gmt.soest.hawaii.edu/doc/5.3.2/pscoast.html
gmt pscoast -JU16/4i -R-93/-86/36/43 -B2f0.5 -Dh -Ia/blue -Na/orange -P -Sblue -K -V > SoilMoistureStations.ps

# 3.2.2 Using 'gmt psxy' to draw X-Y data pair, 
#	3.2.2.1 Adding black circles spotting the station locations.
#		Source: http://gmt.soest.hawaii.edu/doc/5.3.2/psxy.html.
gmt psxy AllStations.xy -J -R -Sc0.15 -Gblack -K -O -V >> SoilMoistureStations.ps

#	3.2.2.2 Adding red circles for all higher elevation stations
gmt psxy HEStations.xy -J -R -Sc0.08 -Gred -O -V >> SoilMoistureStations.ps

# 3.2.3 PS to EPSI Convertion process 
ps2epsi SoilMoistureStations.ps SoilMoistureStations.epsi

# 3.2.4 EPSI to TIF (150 dpi) Convertion process
convert -density 150 SoilMoistureStations.epsi SoilMoistureStations.tif

echo "All processes has been performed successfully! Good job!"




