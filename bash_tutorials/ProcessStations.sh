#!/bin/bash
# Mukhamad Suhermanto
# ABE651


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

# Part 2: { Longitude-Latitude values input }
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





