#!/bin/bash






clear


export cur_path=$(pwd)
echo "cur_path"
echo $cur_path

export folder_2_organize=$(echo "bike_casestudy/csvdata_test")
echo "folder_2_organize"
echo $folder_2_organize

# Step 2: Get path of folder to search
export main_path=$(echo "${cur_path}/${folder_2_organize}")
echo "main_path"
echo $main_path

cd $main_path


# --------------------------------------------

# Redo file_list, because it is missing one file
create_file_list



export n_tot_header=$(cat tot_header | wc -l)
echo "n_tot_header: "
echo $n_tot_header


# Create a large length value as a filler
export dummy_len=$(echo "500")


for r in $( seq 1 $n_tot_header )
do
	tot_count[$r]=$(echo "0")
	tot_length[$r]=$(echo $dummy_len)
done

echo "tot_count"
echo ${tot_count[@]}

echo "tot_length"
echo ${tot_length[@]}
