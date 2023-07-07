#!/bin/bash

# ------------------------------------------------------
# Old code
# ------------------------------------------------------

export max_score_values=$(echo '')

for r in $(echo $rows_that_repword_appear)
do
   export temp=$(cat filetemp | cut -d ' ' -f 4 | head -n $r | tail -n $(($r-($r-1))))
   export max_score_values=$(echo $max_score_values' '$temp)
done

echo "max_score_values: "
echo $max_score_values

export maxvalue=$(echo $max_score_values | tr " " '\n' | sort -n | tail -n 1)
echo "maxvalue: "
echo $maxvalue


# ------------------------------------------------------

# How to use Hugging Face REST APIs : https://huggingface.co/docs/api-inference/detailed_parameters
# ---------------------------
# Sentence similarity
# ---------------------------
export HF_API_TOKEN=$(echo "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")

curl https://api-inference.huggingface.co/models/sentence-transformers/all-MiniLM-L6-v2 \
    -X POST \
    -d '{"inputs":{"source_sentence": '$f_row_quotes', "sentences": ['$header_list_reduced_quotes']}}' \
    -H "Authorization: Bearer ${HF_API_TOKEN}" | cut -b 2- | sed 's/.$//' | tr "," '\n' > sim_float
# ---------------------------

# ---------------------------
# Calculate the max similarity and vector
for csim in $(cat sim_float)
do 
echo "scale=0;$csim*100" | bc | cut -d '.' -f 1 >> sim_int
done
# ---------------------------

# ---------------------------
max=$(cat sim_int | sort -nr | head -n1)
echo "max: "
echo $max
# ---------------------------

# ---------------------------
# Selection of most similar based on maximum similarity within each category
# ---------------------------
c=1  # ****** ALL vectors start at 1 ******
for csim in $(cat sim_int)
do
  if [[ $csim == $max ]] && [[ $csim -gt 60 ]]; then
    
    export to_replace=$(echo $f_row)
    export to_replace_with=$(cat temp | head -n $c | tail -n $(($c-($c-1))))
    
    # Way 0
    # cat file | sed "s/$to_replace/$to_replace_with/g" | sed "/^$/d" >> filetemp
    # mv filetemp file
    
    # Way 1
    export sim_int_concat=$(cat sim_int | paste -s -d "," | tr -d '\r')
    echo $to_replace' '$to_replace_with' '$header_count_list_reduced' '$csim' '$sim_int_concat' '$header_list_reduced_noquotes >> filetemp
  else
    echo ""
  fi
  
  c=$((c+1))
done

# ------------------------------------------------------

# Inputs:  
# $1 = filename [file with a matrix structure]
# $2 = select_colnum [column number to search for a string pattern match]
# $3 = $select_colnum_pattern_search [string_pattern]
# $4 = operator_type
colAselection_rownumoutput 


repword:  [column ]
end_station_id

to_replace: 
to_station_id


# ---------------------------
# Selection of most similar based on maximum similarity across all matches
# ---------------------------
cat filetemp | cut -d ' ' -f 2 | sort -u | tr " " '\n' > uqtemp
export uqtemp_len=$(wc uqtemp |cut -d ' ' -f 2)
echo "uqtemp_len: "
echo $uqtemp_len

export filetemp_len=$(wc filetemp | tr " " '\n' | tr -s "[:space:]" | head -n 2 | tail -n 1)
echo "filetemp_len: "
echo $filetemp_len



    # Re-evaluate repetition of variables
    # rm uqtemp
    # cat filetemp | cut -d ' ' -f 2 | uniq | tr " " '\n' > uqtemp
    # export uqtemp_len=$(wc uqtemp |cut -d ' ' -f 2)
    # export filetemp_len=$(wc filetemp |cut -d ' ' -f 2)


unset r_or_repword
maxscore
maxcount_per_row
mincount_per_row

# ---------------------------


    
    # We do a loop over the items that repeat to reassign them : once finished we retest the length of filetemp column 2 with the unique list length
    # ok, I could test the exact entry values, but I just used length for an initial construction

    # List in header that it recommends to assign to file
    export to_replace_wlist=$(cat filetemp | cut -d ' ' -f 2 | paste -s -d "," | tr -d '\r')
    echo "to_replace_wlist: "
    echo $to_replace_wlist
    
    # This is  basically setdiff of column 2 with the unique items in column 2, to see which items repeat
    for i in $(cat uqtemp)
    do 
      echo "i: "
      echo $i
    
      # search to see if it is counted more than 1 times
      export count=$(grep -o $i <<<"$to_replace_wlist" | grep -c .)
      echo "count: "
      echo $count
      
      # This may seem like it should be uqtemp, but we want the rows that repeat two OR more times only
      if [[ $count -gt 1 ]]; then
          echo $i >> filedump
      fi
    
    done

# ------------------------------------------------------


# --------------------------
# Way 0: may not be robust
# --------------------------
# Concatenate list items into a text string, add double quote to the beginning of the text string
# export header_list_reduced0=$(cat temp | paste -s -d "," | sed 's/^/"/g')
# rm temp   # delete temp

# Add double quotes around commas
# export header_list_reduced1=$(echo $header_list_reduced0 | sed 's/,/","/g')

# export len0=$(echo -n "$header_list_reduced1" | wc -m)
# export len=$(echo "$len0-1" | bc)

# Add double quotes to the end of text string
#export header_list_reduced_quotes=$(echo $header_list_reduced1 | sed 's/.\{'$len'\}/&"/')
# --------------------------

# --------------------------
# Way 1: Add the last
# --------------------------
# export row_len=$(cat temp | wc -l)
# export select_concat=$(cat temp | head -n $(($row_len-1)) | paste -s -d "," | sed 's/^/"/g' | sed 's/,/","/g')

# export select_lastrow=$(cat temp | tail -n 1 | sed 's/^/","/g')

# export len0=$(echo -n "$select_lastrow" | wc -m)
# export len=$(echo "$len0" | bc)
# export endpart=$(echo $select_lastrow | sed 's/.\{'$len'\}/&"/')
# OR
# export doublequote_str=$(echo '"')
# endpart="${select_lastrow}${doublequote_str}"
# echo "endpart: "
# echo $endpart

# export len0=$(echo -n "$select_concat" | wc -m)
# export len=$(echo "$len0" | bc)
# export header_list_reduced_quotes=$(echo $select_concat | sed 's/.\{'$len'\}/&'$endpart'/')
# --------------------------

# ------------------------------------------------------

export max_list=$(cat filetemp | cut -d ' ' -f 4 | paste -s -d "," | tr -d '\r')

# ---------------------------
# Selection of most similar based on maximum similarity across all matches
# ---------------------------
cat filetemp | cut -d ' ' -f 2 | sort -u | tr " " '\n' > uqtemp
export uqtemp_len=$(wc uqtemp |cut -d ' ' -f 2)
echo "uqtemp_len: "
echo $uqtemp_len

export filetemp_len=$(wc filetemp | tr " " '\n' | tr -s "[:space:]" | head -n 2 | tail -n 1)
echo "filetemp_len: "
echo $filetemp_len



    # Re-evaluate repetition of variables
    # rm uqtemp
    # cat filetemp | cut -d ' ' -f 2 | uniq | tr " " '\n' > uqtemp
    # export uqtemp_len=$(wc uqtemp |cut -d ' ' -f 2)
    # export filetemp_len=$(wc filetemp |cut -d ' ' -f 2)








       for r in $(echo $nonrowdes)
       do 
          # Update column 5 by removing the assigned max value
          export to_replace_with=$(cat filetemp | cut -d ' ' -f 5 | head -n $r | tail -n $(($r-($r-1))) | sed "s/,$maxscore//g")
          export to_replace=$(cat filetemp | cut -d ' ' -f 5 | head -n $r | tail -n $(($r-($r-1))))
          cat filetemp | sed "s/$to_replace/$to_replace_with/g" > file0
          mv file0 filetemp  # Destroy the temporary file file0
          
          # Update column 4, the max value of column 5
          export newmax=$(cat filetemp | cut -d ' ' -f 5 | head -n $r | tail -n $(($r-($r-1))) | tr "," '\n' | sort -n | tail -n 1)
          export maxscore=$(cat filetemp | cut -d ' ' -f 4 | head -n $r | tail -n $(($r-($r-1))))
          export to_replace=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))))
          export to_replace_with=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | sed "s/$maxscore/$newmax/g")
          cat filetemp | sed "s/$to_replace/$to_replace_with/g" > file0
          mv file0 filetemp  # Destroy the temporary file file0
          
          # [filetemp modification] Remove repword from 6th column of filetemp
          export to_replace=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))))
          export to_replace_with=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | sed "s/,$repword//g")
          cat filetemp | sed "s/$to_replace/$to_replace_with/g" > file0
          mv file0 filetemp  # Destroy the temporary file file0
       done
       
       
       # -------------------------
       # Modify filetemp row values 
       # -------------------------
       # [filetemp modification] delete the row from filetemp
       export pattern_to_search=$(cat filetemp | head -n $rowdes | tail -n $(($rowdes-($rowdes-1))))
       
       
       cat filetemp | sed "/$pattern_to_search/d" > file2
       mv file2 filetemp  # Destroy the temporary file file2
       
       
# ------------------------------------------------------

       # Get the max score value for repword [use rowdes]
       export maxscore_value=$(cat filetemp | cut -d ' ' -f 5 | head -n $r | tail -n $(($r-($r-1))))
       
       
       for r in $(echo $nonrowdes)
       do 
         
       
          # Update column 5 by removing the assigned max value
          
          
          
          export to_replace_with=$(cat filetemp | cut -d ' ' -f 5 | head -n $r | tail -n $(($r-($r-1))) | sed "s/,$maxscore//g")
          export to_replace=$(cat filetemp | cut -d ' ' -f 5 | head -n $r | tail -n $(($r-($r-1))))
          cat filetemp | sed "s/$to_replace/$to_replace_with/g" > file0
          mv file0 filetemp  # Destroy the temporary file file0
          
          # Update column 4, the max value of column 5
          export newmax=$(cat filetemp | cut -d ' ' -f 5 | head -n $r | tail -n $(($r-($r-1))) | tr "," '\n' | sort -n | tail -n 1)
          export maxscore=$(cat filetemp | cut -d ' ' -f 4 | head -n $r | tail -n $(($r-($r-1))))
          export to_replace=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))))
          export to_replace_with=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | sed "s/$maxscore/$newmax/g")
          cat filetemp | sed "s/$to_replace/$to_replace_with/g" > file0
          mv file0 filetemp  # Destroy the temporary file file0
          
          
       done


# ------------------------------------------------------

#export text2remove=$(echo "echo ${val/tripdata.txt/}")

# Need to do two more operations


# if [[ $VAR == *"NAP"* ]]; then


# for i in {1..3}
# do
# echo "TABLE $i"
# bq query --use_legacy_sql=false 'select * from `<project>.<database>.'$i'`'
# done

# ------------------------------------------------------


        
        # Pre-process files : Remove quotes from csv files if it exists
        cat $str_head_gen | sed 's/"//g' > temp.csv
        mv temp.csv $headeronly
        # echo $filename
        
        # ---------------------------------------------
        
        # Way 0: exact match : searching the header within the file
        # A string needs to be searched in a file for this to work
        export exact_match=$(grep $str_head_gen $filename | wc -l)
        
        # OR 
        
        # Way 1: exact match : comparing two strings 
        # Decided way 0 was better because there is less code 
        
        # ---------------------------------------------
        
        # Evaluate header 
        if [[ "$exact_match" == "0" ]]; then
            # Way 0: file-column search 
            cat $filename | head -n 1 | tr "," '\n' > file
            cat $exact_match | tr "," '\n' > header
            
            
            # search each item 
            for cur_item in $(cat cur_arr)
            do
                for gen_item in $(cat gen_arr)
                do
                    # calculate some approximate match measure
                    if [[ match_mea > thresh ]]
                        # replace header value directly in file
                        cat cur_arr | sed 's/$cur_item/$gen_item/g' >> cur_arr
                done
                
                
            done    
        else
            echo "exact match"
            # exact match : keep general header the same
        fi    
        #export str_head_prev=$(cat $filename | head -n 1)

# ------------------------------------------------------


run_model(){
    
        # Inputs:  
        # $1 = f_row_quotes
        # $2 = header_list_reduced_quotes
        # $3 = $header_count_list_reduced
        
        export header_list_reduced_noquotes=$(echo $2 | sed 's/"//g' | tr -d '\r')
        
        # How to use Hugging Face REST APIs : https://huggingface.co/docs/api-inference/detailed_parameters
        # ---------------------------
        # Sentence similarity
        # ---------------------------
        export HF_API_TOKEN=$(echo "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")
          
        curl https://api-inference.huggingface.co/models/sentence-transformers/all-MiniLM-L6-v2 \
              -X POST \
              -d '{"inputs":{"source_sentence": '$1', "sentences": ['$2']}}' \
              -H "Authorization: Bearer ${HF_API_TOKEN}" | cut -b 2- | sed 's/.$//' | tr "," '\n' > sim_float
        # ---------------------------
        
        # ---------------------------
        # Calculate the max similarity and vector
        for csim in $(cat sim_float)
        do 
          echo "scale=0;$csim*100" | bc | cut -d '.' -f 1 >> sim_int
        done
        rm sim_float
        # ---------------------------
          
        # ---------------------------
        max=$(cat sim_int | sort -nr | head -n1)
        echo "max: "
        echo $max
        # ---------------------------
         
        # ---------------------------
        # Selection of most similar based on maximum similarity within each category
        # ---------------------------
        if [ -f filetemp ]; then
            rm filetemp
        fi
        
        c=1  # ****** ALL vectors start at 1 ******
        for csim in $(cat sim_int)
        do
            if [[ $csim == $max ]] && [[ $csim -gt 60 ]]; then
                
              export to_replace=$(echo $f_row)
              export to_replace_with=$(cat temp | head -n $c | tail -n $(($c-($c-1))))
               
              # Way 0
              # cat file | sed "s/$to_replace/$to_replace_with/g" | sed "/^$/d" >> filetemp
              # mv filetemp file
                
              # Way 1
            export sim_int_concat=$(cat sim_int | paste -s -d "," | tr -d '\r')
              echo $to_replace' '$to_replace_with' '$3' '$csim' '$sim_int_concat' '$header_list_reduced_noquotes >> filetemp
            else
              echo ""
            fi
              
            c=$((c+1))
        done
        
        rm sim_int
        # ---------------------------
    }

# ------------------------------------------------------


# ---------------------------------------------
# Load csv files
# ---------------------------------------------
# export filename=$(echo "Divvy_Trips_2013.csv")
# echo "filename: "
# echo $filename

# Test : comparing two strings
# export headeronly=$(cat 202004-divvy-tripdata.csv | head -n 1)


# export str_head_gen=$(cat $filename | head -n 1 | sed 's/"//g')

# ---------------------------------------------

    
    

            # Remove first file from folder_list2
            # cat folder_list2 | sed '/'$filename'/d' > folder_list3
            # mv folder_list3 folder_list2

# ------------------------------------------------------

echo $first_filename  # (ie: 202004-divvy-tripdata.csv)
echo $headeronly # (ie: ride_id,rideable_type,started_at)

echo $filename  # (ie: 202005-divvy-tripdata.csv)
echo $str_head_gen # (ie: ride_id,rideable_type,started_at)


header1  = headeronly  = tot_header  
header2 = str_head_gen = file       # file (ie: ride_id\nrideable_type\nstarted_at)

# Use tot_header instead of header ****** 
# compare tot_header and file   (new convention)


Clearer naming 

tot_header = header1




file_list = folder_list2


# ------------------------------------------------------



    




# ------------------------------------------------------


# ---------------------------------------------
# Get general header for all the files
# ---------------------------------------------
# Get first file from folder_list2
export first_filename=$(cat file_list | head -n 1)
echo "first_filename"
echo $first_filename  # (ie: 202004-divvy-tripdata.csv)

# Get header from the first file
# Pre-process files : Remove quotes from csv files if it exists
cat $first_filename | sed 's/"//g' > temp.csv
mv temp.csv $first_filename

# ---------------------------------------------
# export header1=$(cat $first_filename | head -n 1 | sed 's/"//g')
# echo "header1"
# echo $header1 
# OR
if [ -f header1_file ]; then
   rm header1_file
fi
cat $first_filename | head -n 1 | sed 's/"//g' > header1_file
echo "header1_file" 
cat header1_file 
# ---------------------------------------------



    # Pre-process files : Remove quotes from csv files if it exists
    cat $filename | sed 's/"//g' > temp.csv
    mv temp.csv $filename
    export header2=$(cat $filename | head -n 1 | sed 's/"//g')
    echo "header2"
    echo $header2 # (ie: ride_id,rideable_type,started_at)

# ---------------------------------------------

# *****************
# Prepare header
# *****************
# Compare header with existing header file
# echo $1 | tr "," '\n' > header
# cat tot_header header | uniq > temp
# mv temp tot_header
# rm temp

# Remove empty lines from header
# export x=$(cat tot_header)
# echo ${x/'\n'} | tr " " '\n' > temp
# mv temp tot_header
# rm temp
# *****************

# *****************
# Prepare file
# *****************
# echo $2 | tr "," '\n' > file

# Testing : selecting a specific row in file to test
# c=2
# cat file | head -n $c | tail -n $(($c-($c-1))) > filetemp
# mv filetemp file
# *****************

# ---------------------------------------------



#!/bin/bash


clear

initial_setup


export filename=$(echo "202005-divvy-tripdata.csv")

clean_csv_header $filename     # (ie: ride_id \n rideable_type \n started_at)
mv dummy_name header2

echo "initial_similarity_assignment"


# Inputs:  
# tot_header  # file (ie: ride_id \n rideable_type \n started_at)
# header2  # file (ie: ride_id \n rideable_type \n started_at)


# Purpose : Fills header file with headeronly words, puts 

for f_row in $(cat header2)
do
  echo "f_row: "
  echo $f_row
  
  substring_evaluation $f_row
  # OUTPUT : header_reduced, tempcount
  
  export header_count_list_reduced=$(cat tempcount | paste -s -d "," | tr -d '\r')
  echo "header_count_list_reduced: "
  echo $header_count_list_reduced
  
  rm tempcount
  
  export header_reduced_list=$(cat header_reduced | paste -s -d "," | tr -d '\r')
  echo "header_reduced_list: "
  echo $header_reduced_list
  
  #model_evaluation $f_row $header_reduced_list $header_count_list_reduced
  
done  # end of f_row









****************************************************************


initial_setup


export filename=$(echo "Divvy_Trips_2013.csv")

clean_csv_header $filename     # (ie: ride_id \n rideable_type \n started_at)
mv dummy_name header2

echo "initial_similarity_assignment"


# Inputs:  
# tot_header  # file (ie: ride_id \n rideable_type \n started_at)
# header2  # file (ie: ride_id \n rideable_type \n started_at)


# Purpose : Fills header file with headeronly words, puts 



#for f_row in $(cat header2)
#do
export f_row=$(cat header2 | head -n 1)

  echo "f_row: "
  echo $f_row
  
 # -------------------------------------
# substring_evaluation $f_row
# OUTPUT : header_reduced, tempcount
 # -------------------------------------
  # Inputs:  
    # $1 = $f_row               # environmental variable (ie: ride_id from header2 file)
    # tot_header                # file (ie: ride_id \n rideable_type \n started_at)
    
    for h_row in $(cat tot_header)
    do
    # export h_row=$(cat tot_header | head -n 1)
        echo "h_row: "
        echo $h_row
        
        # ---------------------------
        # cut the word in $f_row into substrings : creates res with substrings
        word2substrs $f_row
        # OUTPUT : res
        # ---------------------------
        
        # ---------------------------
        if [ -f header_match_count_per_file ]; then
          rm header_match_count_per_file
        fi
        
        if [ -f htemp ]; then
          rm htemp
        fi
        # ---------------------------
        
        # ---------------------------
        # Must put the row header word in a file
        echo $h_row > htemp
        
        sum=0
        for ss in $(cat res)
        do
          export count=$(grep $ss htemp | wc -l)
          sum=$((sum  + $count))
        done
        
        rm htemp
        rm res
        
        # Now we have the sum of the filename substrings per header : should be as long as header
        echo $sum >> header_match_count_per_file
        # ---------------------------
     
    done  # end of h_row
      
    echo "header_match_count_per_file"
    cat header_match_count_per_file
    
    
    # ---------------------------
    # Way 1: assign header rows to file rows based on a comparative count threshold in header_match_count_per_file
      
    # Take the average of header_match_count_per_file
    export sum=$(cat header_match_count_per_file | paste -s -d "+" | bc)
    export N=$(wc header_match_count_per_file |cut -d ' ' -f 2)

    export avg=$(echo "scale=0;$sum/$N" | bc)
    echo "avg: "
    echo $avg
    # -------------------------------------
      
    # -------------------------------------
    if [ -f header_reduced ]; then
      rm header_reduced
    fi
      
    if [ -f tempcount ]; then
      rm tempcount
    fi
    # -------------------------------------
      
    # -------------------------------------
    # Select all the rows in header that have a count greater than the average of header_match_count_per_file
    r=1
    for h_row_count in $(cat header_match_count_per_file)
    do
      if [[ $h_row_count -ge $avg ]]; then
          # echo "h_row_count: "
          # echo $h_row_count
          
          # Appending to a file
          cat tot_header | head -n $r | tail -n $(($r-($r-1))) >> header_reduced
          
          echo $h_row_count >> tempcount
      fi
      r=$((r+1))
    done
      
    rm header_match_count_per_file
    # -------------------------------------
      
    # OUTPUT : header_reduced, tempcount
  
# -------------------------------------

export header_count_list_reduced=$(cat tempcount | paste -s -d "," | tr -d '\r')
echo "header_count_list_reduced: "
echo $header_count_list_reduced

rm tempcount

export header_reduced_list=$(cat header_reduced | paste -s -d "," | tr -d '\r')
echo "header_reduced_list: "
echo $header_reduced_list

#model_evaluation $f_row $header_reduced_list $header_count_list_reduced

#done  # end of f_row

# -------------------------------------

# export flag=$(echo "0")
# while [[ $flag == 0 ]]


# Can not iterate over an environmental variable
# export uqtemp=$(cat filetemp | cut -d ' ' -f 2 | sort -u | tr " " '\n')
# echo "uqtemp: "
# echo $uqtemp
# export len_uq=$(echo $uqtemp | wc -l) 

# for n in $(1..$len_uq)

# -------------------------------------


colAselection_rownumoutput(){
    # Logic : return a rownum based on a pattern match in a selected column
           
    # Inputs:  
    # $1 = file_name [file with a matrix structure]
    # $2 = select_colnum [column number to search for a string pattern match]
    # $3 = $select_colnum_pattern_search [string_pattern]
    # $4 = operator_type
    
    unset r
    unset rowdes1
    unset rowdes
    unset col_row_value
    
    # echo 'input 1'
    # echo $1
    
    # echo 'Number of rows in $1 : file_name'
    # cat $1 | wc -l 
    
    # echo 'input 2 : select_colnum'
    # echo $2
    
    # echo 'input 3 : select_colnum_pattern_search'
    # echo $3

    # echo 'input 4 : operator_type'
    # echo $4

    r=1
    for i in $(cat $1)
    do
        export col_row_value=$(cat $1 | cut -d ' ' -f $2 | head -n $r | tail -n $(($r-($r-1))))
                 
        if [ $3 $4 $col_row_value ]; then
           export rowdes1=$(echo $r) # there should be only one match so store the value one time
           # echo "rowdes1"
           # echo "$rowdes1"
           
           export rowdes=$(echo $rowdes" "$rowdes1)
           # echo "rowdes"
           # echo "$rowdes"
        fi
        r=$((r+1))
    done
    
    
    echo $rowdes > rowdes
    # return $rowdes
    
    # ***** OUTPUT [rowdes] *****
}

# ---------------------------

# -------------------------------------


    # Get length of filetemp
    export n=$(cat filetemp | wc -l)
    echo "n: "
    echo $n
    
    #for line_in_file in $(cat filetemp)
    for r in $( seq 1 $n )
    do
        # 2 ways : 
        # Way 0 [easy]: re-run the text words in last column with to_replace through the model - select most similar
        
        export f_row=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 1 | tr -d '\r')
        
        substring_evaluation $f_row
        export header_count_list_reduced=$(echo $?)  # output of function
        echo "header_count_list_reduced: "
        echo $header_count_list_reduced
        
        # Make column 6 a list with commas
        export header_reduced_list=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 6 | sed 's/,/ /g' | sed -Ee '/[[:space:]]+$/s///' | sed 's/ /,/g')
        
        model_evaluation $f_row $header_reduced_list $header_count_list_reduced
        # ***** OUTPUT [filetemp, header_reduced] *****
        
        #r=$((r+1))
    done

# -------------------------------------

# echo "$count-1" | bc
      
      # Problem : do not know which line that genheader was found in file curheader
      
      
      # OR
      
      # colnum=1
      # for ch in $(cat curheader)
      # do
      #    echo "ch:"
      #    echo $ch
         if [[ "$genheader" -eq "$ch" ]]; then
            echo "MATCH column"
            echo $colnum
            #  export colnum=$(echo $colnum)
            cat $filename | cut -d ',' -f $colnum > col
            paste new_csv col -d "," > tempjoin
            mv tempjoin new_csv
            
            # Indicate that a match exists
            export flag=$(echo "1")
         fi
         colnum=$((colnum+1))
      done
      
      # If no match exists, append a null column
      if [[ "$flag" -eq "0" ]];then
        # Append genheader to top of column
        cat $genheader nullcol > tot2
        
        # No match was found, make a NULL column
        paste new_csv tot2 -d "," > tempjoin
        mv tempjoin new_csv
      fi

# -------------------------------------

echo "r:"
      echo $r
      
      export genheader=$(cat tot_header | head -n $r | tail -n $(($r-($r-1))) | tr -d '\r')
      echo "genheader:"
      echo $genheader
      
      # add bars to define the word
      export len=$(echo -n $genheader | wc -m)  # *** for the function we use $1 for the input $f_row ***
      echo "len"
      echo $len
    
      # export genheader_bars=$(echo $genheader | sed 's/^/|/g' | sed 's/$/|/g')
      export genheader_bars=$(echo $genheader | sed 's/.\{1\}/&"/' | sed 's/.\{'$len'\}/&"/')
      echo "genheader_bars:"
      echo $genheader_bars
      
      
      # Problem : as I previously thought genheader can have multiple matches
      cat curheader | paste -s -d "|" | sed 's/^/|/g' | sed 's/$/|/g' > test
      
      
      # Count fixed strings (-F) from a file per line
      export loc_in_curheader=$(grep -n -F $genheader_bars test)
      echo "loc_in_curheader:"
      echo $loc_in_curheader

# -------------------------------------

# OR

      # export len=$(echo -n $genheader | wc -m)  # *** for the function we use $1 for the input $f_row ***
      # echo "len"
      # echo $len
      # export len1=$(echo "scale=0;$len+1" | bc)
      # echo "len1"
      # echo $len1
      # export genheader_bars=$(echo $genheader | sed 's/.\{0\}/&|/' | sed 's/.\{'$len1'\}/&|/')
      # echo "genheader_bars:"
      # echo $genheader_bars


      # Problem : as I previously thought genheader can have multiple matches
      

      # echo "curheader file:"
      # cat curheader

# -------------------------------------


# Attempt to combine two 11 column length tables : it does not work, the columns that depass 11 wrap over the existing columns
export fnum=$(echo 2)
echo "fnum:"
echo $fnum

export fnum=$(echo "$fnum-1" | bc)
echo "fnum:"
echo $fnum

for r_prev in $(seq 1 $fnum)
do  
    echo "r_prev:"
    echo $r_prev

    export r=$(echo "$r_prev+1" | bc)
    echo "r:"
    echo $r
    
    paste new_csv${r_prev} new_csv${r} -d "," > tempjoin
    mv tempjoin new_csv${r}
done

# -------------------------------------


rm count

# cat header2 | paste -s -d "," | sed 's/,/|,|/g' | sed 's/^/|/g' | sed 's/$/|/g' | tr "," '\n' | tr -d '\r' > test
cat tot_header | paste -s -d "," | sed 's/,/|,|/g' | sed 's/^/|/g' | sed 's/$/|/g' | tr "," '\n' | tr -d '\r' > test

export n=$(cat header2 | wc -l)
echo "n: "
echo $n
for r in $( seq 1 $n )
do
  # echo "r:"
  # echo $r

  # add bars to define the word
  export genheader_bars1=$(cat header2 | head -n $r | tail -n $(($r-($r-1))) | tr -d '\r' | sed 's/^/|/g' | sed 's/$/|/g')
  # echo "genheader_bars1:"
  # echo $genheader_bars1

  # Count fixed strings (-F) from a file per line
  export loc_in_curheader=$(grep -n -F $genheader_bars1 test)
  # echo "loc_in_curheader:"
  # echo $loc_in_curheader

  if [ ! -f $loc_in_curheader ]; then
    echo 1 >> count
  else
    # No match found, insert null column
    echo 0 >> count
  fi
done

export sum=$(cat count | paste -s -d "+" | bc)
echo "sum: "
echo $sum

# Problem: it is not an integer
# export percentage=$(echo "scale=1;($sum/$n)*100" | bc)
export float=$(echo "scale=2;$sum/$n" | bc)
echo "float: "
echo $float

export percentage=$(echo "scale=0;$float * 100" | bc)
echo "percentage: "
echo $percentage


# -------------------------------------


1. search for error in get_primary_key_list  
    - why is file outputing 0 and 19
    - need to output primary_key_list (sorted list of tot_header with respect to prevalence in csv files)


# -------------------------------------

reduce_header2_to_unique_words(){

    echo "reduce_header2_to_unique_words"
    # Inputs:  
    # header2  # file (ie: ride_id \n rideable_type \n started_at)
    # tot_header  # file (ie: ride_id \n rideable_type \n started_at)
    
    export n=$(cat header2 | wc -l)
    # echo "n: "
    # echo $n
    
    export n_tot=$(cat tot_header | wc -l)
    # echo "n_tot: "
    # echo $n_tot
    
    for r in $( seq 1 $n )
    do 
	flag=0
	export header2_word=$(cat header2 | head -n $r | tail -n $(($r-($r-1))) | tr -d '\r')
	# echo "header2_word: "
	# echo $header2_word
	
	for r_tot in $( seq 1 $n_tot )
	do 
	    export tot_header_word=$(cat tot_header | head -n $r_tot | tail -n $(($r_tot-($r_tot-1))) | tr -d '\r')
	    if [[ $header2_word == $tot_header_word ]]; then
	        flag=1
	    fi
	done
	
	# Modify header2 when header2_word is equal to tot_header_word
	if [[ $flag -eq "1" ]]; then
	
	    # replace this row with blank space
	    export to_replace=$(echo $header2_word)
	    export to_replace_with=$(echo "")
	    
	    # Update header2
	    # Purposely do not change the length of header2 ( | sed '/^$/d') to keep for loop index
	    cat header2 | sed "s/$to_replace/$to_replace_with/g" > temp
	    mv temp header2
	    
	    # echo "header2 : flag=1, r=$r, header2_word=$header2_word reduce_header2_to_unique_words"
	    # cat header2
	fi
	
    done
    
    # Remove white/empty space at the end : an empty file means that all the words in header2 were in tot_header
    cat header2 | sed '/^$/d' > temp
    mv temp header2
    
# ***** OUPUT : replaced version of header2 (where only values are lexically different than tot_header)
}


# -------------------------------------


reduce_header2_to_unique_words(){

    echo "reduce_header2_to_unique_words"
    # Inputs:  
    # header2  # file (ie: ride_id \n rideable_type \n started_at)
    # tot_header  # file (ie: ride_id \n rideable_type \n started_at)
    
    export OPTION=$(echo "0")
    
    compare_a_list_with_a_list tot_header header2 $OPTION
    # OUTPUT : temp 
    
    # Remove white/empty space at the end : an empty file means that all the words in header2 were in tot_header
    cat header2 | sed '/^$/d' > temp
    mv temp header2
    
# ***** OUPUT : replaced version of header2 (where only values are lexically different than tot_header)
}


# -------------------------------------


check_if_header2_is_similar_to_totheader(){

    echo "reduce_header2_to_unique_words"
    # Inputs:
    # $1 = filename
    # header2  # file (ie: ride_id \n rideable_type \n started_at)
    # tot_header  # file (ie: ride_id \n rideable_type \n started_at)
    
    if [ -f count ]; then
        rm count
    fi
    
    export OPTION=$(echo "1")
    
    compare_a_list_with_a_list tot_header header2 $OPTION
    # OUTPUT : count 
    
    # Sum to get total number of header2 words in tot_header
    export sum=$(cat count | paste -s -d "+" | bc)
    echo "sum: "
    echo $sum

    # ---------------------------
    if [[ "$sum" -gt 0 ]]; then
      # Update tot_header with header2 values : one or more header2 values are in tot_header
      cat tot_header header2 | sort -u | sed '/^$/d' > temp
      mv temp tot_header
    else
      # Move the csv to another folder : NO header2 values are in tot_header
      mkdir no_match_header
      mv $1 no_match_header
    fi
    # ---------------------------
    
    # ***** OUTPUT [move non-similar file to no_match_header] *****
}


# -------------------------------------

# Way 1

# for loop over each number - remove the number per column and store the remaining number number

export out=$(echo "1.,[2]19,[3]6,[4]6,[5]2,[6]17,[7],[8],[9],[10],[11]6,[12],[13],[14]11,[15]16,[16]19,[17]6,[18]7,[19]1,[20]10,1.,[2]19,[3]6,[4]6,[5]2,[6]19,[7],[8],[9],[10],[11]6,[12],[13],[14]11,[15]16,[16]19,[17]6,[18]7,[19]1,[20]17,1.,[2]21,[3]4,[4]5,[5]0,[6]0,[7],[8],[9],[10],[11]8,[12],[13],[14]14,[15]18,[16]21,[17]4,[18]5,[19]0,[20]0,1.2,[2],[3],[4],[5],[6],[7]2,[8]1,[9]7,[10]8,[11],[12]17,[13],[14],[15],[16],[17],[18],[19],[20],1.,[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20]")



for r in $( seq 1 $n_tot_header )
do
    echo "r:"
    echo $r
    
    # export out_cols=$(echo -n "$out" | tr "," ' ' | sed "s/\b$r)\b//g")
    export searchpattern=$(echo "$r.")
    export out_cols=$(echo -n "$out" | tr "," ' ' | sed "s/'$searchpattern'//g")
    echo "out_cols:"
    echo $out_cols
    
    # Select the columns that do not have a ] 
    
    # Way 0: problem: have to go to text file
    export colmatch=$(echo "")
    echo "colmatch:"
    echo $colmatch
    
    echo $out_cols | tr " " '\n' > col
    
    export n=$(cat col | wc -l)
    echo "n: "
    echo $n
    
    for r in $( seq 1 $n )
    do
        export colval=$(cat col | head -n $r | tail -n $(($r-($r-1))) | tr -d '\r')
        echo "colval:"
        echo $colval
    
        export uniq_del_pattern=$(echo 'todelete$colval')
        
        if [[ -f $colval ]]; then
            echo 'colval is empty'
            cat col | sed '/'$uniq_del_pattern'/d'
        else
            echo 'colval is NOT empty'
            # search for ]
            colafter=$(echo $colval | sed 's/"]"//g')
            
            if [[ $colval -eq $colafter ]]; then
                echo 'colval is NOT equal to colafter'
                # match!
                export colmatch=$(echo $colmatch'+'$colval)
                echo "colmatch:"
                echo $colmatch
        
                # Need to erase it from out or col
                # echo $out | | cut -d ',' -f 1 
                # OR
                cat col | sed '/'$uniq_del_pattern'/d'
            fi
        
        fi
        
        
    done   # END of [for r in $( seq 1 $n )]
    
    # sum colmatch
    
    # count + 
    
    # avg
    
    # store for tot_header column 3

    export out=$(cat col | paste -s -d ",")
    
done 

# -------------------------------------

c=1
for filename in $(cat file_list)
do
  # export filename=$(echo "202005-divvy-tripdata.csv")

  # Get the header from the current csv
  cat $filename | head -n 1 | tr "," '\n' | tr -d '\r' > tempheader2
  cat tempheader2 | paste -s -d "," | sed 's/,/|,|/g' | sed 's/^/|/g' | sed 's/$/|/g' | tr "," '\n' | tr -d '\r' > tempheader2_bars
  
  
  export n_filename=$(cat $filename | wc -l)
  export n_samples=$(echo "50") # random number of samples
  # echo "n_samples: "
  # echo $n_samples
  
  
  if [ -f count ]; then
    rm count
  fi
  
  # -------------
  # Way 0
  # if [ -f length ]; then
  #   rm length
  # fi
  
  # Way 1
  # unset out
  # -------------
  
  
  
  for r in $( seq 1 $n_tot_header )
  do
    echo "r:"
    echo $r
  
    # add bars to define the word
    export genheader_bars1=$(cat tot_header | head -n $r | tail -n $(($r-($r-1))) | tr -d '\r' | sed 's/^/|/g' | sed 's/$/|/g')
    # echo "genheader_bars1:"
    # echo $genheader_bars1

    # Count fixed strings (-F) from a file per line
    export loc_in_curheader=$(grep -n -F $genheader_bars1 tempheader2_bars)
    # echo "loc_in_curheader:"
    # echo $loc_in_curheader

    if [ ! -f $loc_in_curheader ]; then
      echo 1 >> count
      
      # Calculate the min character length for this column
      # Need to find the search_pattern in $filename, to get the column number
      if [ -f len_filename ]; then
        rm len_filename
      fi
      
      export colval=$(echo $loc_in_curheader | cut -d ':' -f 1)
      # echo "colval:"
      # echo $colval
      
      for rf in  $( seq 1 $n_samples )
      do
        # $RANDOM is distributed between 0 and 32767
        # random selection between 2 and n_filename
        export rand=$(echo "((($RANDOM + $RANDOM) % $n_filename+1) + 2)" | bc)
        # echo "rand:"
        # echo $rand
        
        cat $filename | head -n $rand | tail -n $(($rand-($rand-1))) | tr -d '\r' | cut -d ',' -f $colval | tr -d '\n' | wc -m >> len_filename
      done
      
      export min_len=$(cat len_filename | sort -n | head -n 1)
      echo "min_len:"
      echo $min_len
      
      rm len_filename
      
      # Way 0 : put min_len in a file
      # echo $min_len >> length
      # The file length is erased and it is not my program, it worked yesterday
      
      # Way 1: put in environmental variables
      if [[ $r -eq 1 ]]; then
        export out=$(echo $out[$r]$min_len)
      else
        export out=$(echo $out","[$r]$min_len)
      fi
      
    else
    
      # No match found, insert null column
      echo 0 >> count
      # echo "" >> length
      if [[ $r -eq 1 ]]; then
        export out=$(echo $out"[$r]")
      else
        export out=$(echo $out",[$r]")
      fi
      
    fi
    
    echo "out inside for loop:"
    echo $out
    
  done  # END of [for r in $( seq 1 $n_tot_header )]
  
  echo "out AFTER for loop:"
  echo $out
  
  
  # Count 
  if [[ $c -eq 1 ]]; then
    paste matrix_c count -d "" >> matrix_c_temp
  else
    paste matrix_c count -d "+" >> matrix_c_temp
  fi
  
  # -------------
  # Way 0
  # Length
  # if [[ -f length ]]; then
    # length is empty: put an empty space in matrix_l (incorrect thinking : thinking if data was a row and not a column)
    # echo "" >  emptyspace
    # cat matrix_l emptyspace > matrix_l_temp
    # mv matrix_l_temp matrix_l
    
    # if length is empty: and data is in a column, do not append anything 
    # leave matrix_l the same for the next loop
  #   echo "" > length
  #   if [[ $c -eq 1 ]]; then
  #       paste matrix_l length -d "" >> matrix_l_temp
  #   else
  #       paste matrix_l length -d "|+" >> matrix_l_temp
  #   fi
  # else
    # length is not empty: put the 
  #   if [[ $c -eq 1 ]]; then
  #       paste matrix_l length -d "" >> matrix_l_temp
  #   else
  #       paste matrix_l length -d "+" >> matrix_l_temp
  #   fi
  # fi
  
  
  
  # Way 1
  # export out_col=$(echo $out | tr " " '\n')
  
  # if [[ $c -eq 1 ]]; then
  #   export matrix_l_temp=$(paste $matrix_l $out_col -d "")
  # else
  #   export matrix_l_temp=$(paste $matrix_l $out_col -d "+")
  # fi
  
  # Re-assign matrix_l
  # export matrix_l=$(echo $matrix_l_temp)
 #  unset $out_col
  # unset $matrix_l_temp
  
  
  
  # Way 2
  # export out=$(echo $out"EOF")
  
  # -------------
  



done    # END of [for filename in $(cat file_list)]





echo "out: "
echo $out



# Search from number to comma

# What I can do : 
# search for a search_pattern - replace it with something, get something in a corresponding column
#

# -------------------------------------


if [ -f primary_key_list ]; then
    rm primary_key_list
fi



export n_tot_header=$(cat tot_header | wc -l)
echo "n_tot_header: "
echo $n_tot_header

# Sum across rows, the maximum row shows the most prevalent column in tot_header
for r in $( seq 1 $n_tot_header )
do  
    export tot_header_name=$(cat tot_header | head -n $r | tail -n $(($r-($r-1))) | tr -d '\r')
    
    # Count the number of plus sign
    export n_matrix_c=$(cat matrix_c | head -n $r | tail -n $(($r-($r-1))) | tr -d '\r' | tr '+' "\n" | wc -l)
    
    export n_matrix_l=$(cat matrix_l | head -n $r | tail -n $(($r-($r-1))) | tr -d '\r' | tr '+' "\n" | wc -l)
    echo "n_matrix_l: "
    echo $n_matrix_l
    
    # ---------------------------
    export sum_c=$(cat matrix_c | head -n $r | tail -n $(($r-($r-1))) | tr -d '\r' | bc)
    export float_c=$(echo "scale=2;$sum_c/$n_matrix_c" | bc)
    echo "float_c: "
    echo $float_c
    
    export float_c2=$(echo $((sum_c/n_matrix_c))*100 )
    echo "float_c2: "
    echo $float_c2

    export percentage_c_int=$(echo "scale=0;$float_c * 100" | bc)
    echo "percentage_c_int: "
    echo $percentage_c_int
    # ---------------------------
    
    # ---------------------------
    export sum_l=$(cat matrix_l | head -n $r | tail -n $(($r-($r-1))) | tr -d '\r' | bc)
    echo "sum_l: "
    echo $sum_l
    
    export float_l=$(echo "scale=2;$sum_l/$n_matrix_l" | bc)
    echo "float_l: "
    echo $float_l

    export percentage_l_int=$(echo "scale=0;$float_l * 100" | bc)
    echo "percentage_l_int: "
    echo $percentage_l_int
    # ---------------------------
    
    echo $tot_header_name' '$percentage_c_int' '$percentage_l_int >> primary_key_list
done


# Sort column 2 in descending order
cat primary_key_list | sort -k 2 -n -r > primary_key_list_col2sorted


export n=$(cat primary_key_list_col2sorted | wc -l)
echo "n: "
echo $n

export col2max=$(cat primary_key_list_col2sorted | cut -d ' ' -f 2 | sort -n | tail -n 1 | tr -d '\r')
echo "col2max: "
echo $col2max

for r in $( seq 1 $n )
do
   export col2=$(cat primary_key_list_col2sorted | cut -d ' ' -f 2 | head -n $r | tail -n $(($r-($r-1)))) 
   
   if [ $col2 -eq $col2max ]; then
      cat primary_key_list_col2sorted | head -n $r | tail -n $(($r-($r-1))) >> primary_key_list_col2sorted_2ndmax
      break;
   fi
done

rm primary_key_list_col2sorted

# Sort column 3 in ascending order
cat primary_key_list_col2sorted_2ndmax | sort -k 3 -n > primary_key_list_col2sorted_2ndmax_3rdmin
rm primary_key_list_col2sorted_2ndmax

# The first column are tot_header names that are most suitable to be primary keys, in ascending order
export primary_key_list=$(cat primary_key_list_col2sorted_2ndmax_3rdmin | cut -d ' ' -f 1 )

echo "primary_key_list:"
echo $primary_key_list

# -------------------------------------



# --------------------------------------
# Original code in step1_open_files.sh
# --------------------------------------

# Secondary clean up of files
export val=$(echo "X0")

if [[ $val == "X0" ]]
then 
    
    # get main path
    export cur_path=$(pwd)
    #echo "cur_path:"
    #echo $cur_path
    
    # get path of folder to search
    export main_path=$(echo "${cur_path}/${folder_2_organize}")
    #echo "main_path:"
    #echo $main_path
    # /home/oem2/Documents/COURS_ONLINE/Spécialisation_Google_Data_Analytics/3_Google_Data_Analytics_Capstone_Complete_a_Case_Study/bike_casestudy/dataORG
    
    # find folders inside of the folder to search
    cd $main_path
    ls -d */ >> folder_list
   
    # move folder contents into data
    # export i=$(echo "Divvy_Stations_Trips_2013/")
    for i in $(cat folder_list)
    do
      export new_path=$(echo "${main_path}/${i}")
      echo "new_path:"
      echo $new_path
      
      cd $new_path
      
      # Save an array of values 
      # remove the text folder_list2 from the file, then remove blank or empty lines
      ls  | sed 's/folder_list2//g' | sed '/^$/d' >> folder_list2
      
      #echo "contents of folder_list2:"
      for j in $(cat folder_list2)
      do
        #echo $j
        export new_path2=$(echo "${new_path}${j}")
        #echo "new_path2:"
        #echo $new_path2
        mv $new_path2 $main_path 
      done
      
      # delete folders
      rm folder_list2
      
      cd $main_path
      
      rm -rf $i
    done
    
    
    rm folder_list
   
    # Recreate main folders
    # --------------
    # zipfile folder
    mkdir zipdata
    mv *.zip zipdata
    # --------------
    
    # --------------
    # csv folder
    mkdir csvdata
    mv *.csv csvdata
    # --------------
    
    # --------------
    # The rest in a folder
    mkdir remaining_files
    
    find $main_path -maxdepth 1 -type f >> nondir_folder_list
    
    # remove the directory items from the file all_file_list
    for i in $(cat nondir_folder_list)
    do
      mv $i remaining_files
    done
    
    rm remaining_files/nondir_folder_list
    # --------------
else
    echo ""
fi

# -------------------------------------



# -------------------------------------






