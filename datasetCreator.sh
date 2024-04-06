#!/bin/bash

# Number of rows to generate
num_rows=1000000000  # 1 billion 
num_processes=1      # Number of parallel processes

# Function to generate a random station name
generate_random_station_name() {
    # Define arrays of prefixes and suffixes for station names
    prefixes=("North" "South" "East" "West" "Central" "Downtown" "Upper" "Lower" "Old" "New" "Lake" "River" "Mountain" "Valley" "Golden" "Silver" "Green" "Blue" "White" "Red" "Yellow" "Purple" "Orange" "Pink" "Black" "Gray" "Rainbow" "Sunny" "Cloudy" "Windy" "Rainy" "Snowy" "Foggy" "Misty" "Sandy" "Rocky" "Breezy" "Hazy" "Star" "Moon" "Sunset" "Sunrise" "Twilight" "Dusk" "Dawn" "Crystal" "Emerald" "Amber" "Diamond" "Ruby" "Sapphire" "Pearl" "Opal" "Topaz" "Quartz" "Granite" "Marble" "Jade" "Copper" "Bronze" "Brass" "Iron" "Steel" "Titanium" "Platinum" "Gold" "Silver")
    suffixes=("City" "Town" "Village" "Harbor" "Beach" "Cove" "Bay" "Springs" "Hills" "Meadows" "Forest" "Grove" "Heights" "View" "Point" "Junction" "Crossing" "Park" "Gardens" "Fields" "Plains" "Lakes" "Shores" "Ridge" "Valley" "Brook" "Creek" "Stream" "Trail" "Highway" "Boulevard" "Avenue" "Street" "Road" "Lane" "Place" "Square" "Court" "Circle" "Way" "Path" "Alley" "Terrace" "Territory" "Land" "Glen" "Port" "Quay" "Market" "Marketplace" "Market Street" "Promenade" "Gate" "Wharf" "Pier" "Dock" "Terminal" "Terminal Avenue" "Station" "Depot" "Haven" "Center" "Plaza" "Square" "Square Plaza" "Grove" "Crossroads" "Overlook" "Estates" "Reserve" "Reservoir" "Mansion" "Manor" "Palace" "Castle" "Fort" "Tower" "Keep" "Villa" "Cottage" "House" "Museum" "Library" "School" "University" "College" "Academy" "Institute" "Laboratory" "Observatory" "Planetarium" "Zoo" "Aquarium" "Botanical Garden" "Gallery" "Theater" "Cinema" "Opera House" "Concert Hall" "Stadium" "Arena" "Field" "Pitch" "Court" "Rink" "Park" "Grounds" "Track" "Gymnasium" "Pool" "Center" "Club" "Fitness Center" "Health Club" "Spa" "Retreat" "Sanctuary" "Lodge" "Inn" "Hotel" "Motel" "Resort" "Hostel" "Campground" "Camp" "Ranch" "Farm" "Plantation" "Orchard" "Vineyard" "Farmstead" "Homestead" "Mill" "Factory" "Workshop" "Studio" "Warehouse" "Store" "Shop" "Boutique" "Market" "Supermarket" "Mall" "Plaza" "Center" "Centerpoint" "Square" "Circle" "Roundabout" "Loop" "Path" "Lane" "Trail" "Way" "Walk" "Drive" "Street" "Road" "Avenue" "Boulevard" "Highway" "Expressway" "Freeway" "Interstate" "Turnpike" "Parkway" "Alley" "Place" "Court" "Terrace" "Garden" "Terrace" "Terrace Garden" "Terrace Park" "Terrace Court" "Terrace Plaza" "Terrace Avenue" "Terrace Street" "Terrace Road" "Terrace Lane" "Terrace Way" "Terrace Circle" "Terrace Drive" "Terrace Boulevard" "Terrace Highway" "Terrace Freeway" "Terrace Expressway" "Terrace Turnpike" "Terrace Parkway" "Terrace Place" "Terrace Square" "Terrace Mall" "Terrace Center" "Terrace Corner" "Terrace Cornerstone" "Terrace Corner Plaza" "Terrace Corner Avenue" "Terrace Corner Street" "Terrace Corner Road" "Terrace Corner Lane" "Terrace Corner Way" "Terrace Corner Circle" "Terrace Corner Drive" "Terrace Corner Boulevard" "Terrace Corner Highway" "Terrace Corner Freeway" "Terrace Corner Expressway" "Terrace Corner Turnpike" "Terrace Corner Parkway" "Terrace Corner Place" "Terrace Corner Square" "Terrace Corner Mall" "Terrace Corner Center" "Terrace Corner Shop" "Terrace Corner Market" "Terrace Corner Station" "Terrace Corner Depot" "Terrace Corner Haven" "Terrace Corner Base" "Terrace Corner Park" "Terrace Corner Garden" "Terrace Corner Terrace" "Terrace Corner View" "Terrace Corner Point" "Terrace Corner Junction" "Terrace Corner Crossing" "Terrace Corner Stream" "Terrace Corner Trail" "Terrace Corner Glen" "Terrace Corner Brook" "Terrace Corner Ridge" "Terrace Corner Valley" "Terrace Corner Falls" "Terrace Corner Creek" "Terrace Corner Canyon" "Terrace Corner Peak" "Terrace Corner Hill" "Terrace Corner Mountain" "Terrace Corner Forest" "Terrace Corner Woods" "Terrace Corner Jungle" "Terrace Corner Desert" "Terrace Corner Oasis" "Terrace Corner Beach" "Terrace Corner Cove" "Terrace Corner Harbor" "Terrace Corner Bay" "Terrace Corner Island" "Terrace Corner Peninsula" "Terrace Corner Cape" "Terrace Corner Coast" "Terrace Corner Ridge" "Terrace Corner Plateau" "Terrace Corner Summit" "Terrace Corner Pass" "Terrace Corner Ravine" "Terrace Corner Gorge" "Terrace Corner Gulch" "Terrace Corner Estuary" "Terrace Corner Marsh" "Terrace Corner Swamp" "Terrace Corner Bog" "Terrace Corner Lagoon" "Terrace Corner Pond" "Terrace Corner Lake" "Terrace Corner River" "Terrace Corner Stream" "Terrace Corner Brook" "Terrace Corner Creek" "Terrace Corner Waterfall" "Terr")

    # Choose random prefix and suffix
    random_prefix=${prefixes[$((RANDOM % ${#prefixes[@]}))]}
    random_suffix=${suffixes[$((RANDOM % ${#suffixes[@]}))]}

    # Generate a random station name by combining prefix and suffix
    random_station_name="$random_prefix $random_suffix"
    echo "$random_station_name"
}

# Function to generate a random temperature between 0 and 50 with one decimal
generate_random_temperature() {
    temperature=$(printf "%.1f" "$(bc -l <<< "scale=1; $RANDOM/3276.7")")
    echo $temperature
}

# Function to generate a portion of the dataset
generate_data() {
    local start_index=$1
    local end_index=$2

    for ((i=start_index; i<end_index; i++)); do
        station=$(generate_random_station_name)
        temperature=$(generate_random_temperature)
        echo "$station;$temperature" >> final.txt
    done
}

# Calculate the number of rows per process
rows_per_process=$((num_rows / num_processes))

# Generate data using parallel processes
for ((i=0; i<num_processes; i++)); do
    start_row=$((i * rows_per_process))
    end_row=$((start_row + rows_per_process))
    generate_data $start_row $end_row &
done

# Wait for all processes to complete
wait

echo "Dataset with $num_rows rows generated successfully."
