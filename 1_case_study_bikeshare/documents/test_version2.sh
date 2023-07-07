#!/bin/bash


clear



# ---------------------------
# Functions START
# ---------------------------


# ---------------------------

initial_setup(){

    # Inputs:  
    # 2 csv files
    
    # get main path
    export cur_path=$(pwd)
    echo "cur_path"
    echo $cur_path
    
    export folder_2_organize=$(echo "bike_casestudy/csvdata_test")
    echo "folder_2_organize"
    echo $folder_2_organize
    
    # get path of folder to search
    export main_path=$(echo "${cur_path}/${folder_2_organize}")
    echo "main_path"
    echo $main_path
    
    cd $main_path
    
    # Create a file named file_list that contains all the files in the directory
    ls | sed 's/colBvalue//g' | sed 's/diffrow//g' | sed 's/diff//g' | sed 's/dummy_name//g' | sed 's/file0//g' | sed 's/file1//g' | sed 's/file2//g' | sed 's/file3//g' | sed 's/file4//g' | sed 's/file5//g' | sed 's/file_list//g' | sed 's/filetemp_reevaluate//g' | sed 's/filetemp//g' | sed 's/header2reevaluate_per_row//g' | sed 's/header2//g' | sed 's/header_match_count_per_file//g' | sed 's/header_reduced//g' | sed 's/modelscores//g' | sed 's/new_csv//g' | sed 's/result//g' | sed 's/rows_that_repword_appear//g' | sed 's/sim_float//g' | sed 's/sim_int//g' | sed 's/tempcount//g' | sed 's/to_replace_assignment//g' | sed 's/tot_headerreevaluate_per_row//g' | sed 's/uqtemp//g' | sed 's/test.sh//g' | sed 's/test2.sh//g' | sed 's/test3.sh//g' | sed 's/test4.sh//g' | sed 's/temp//g' | sed 's/tot_header//g' | sed 's/primary_key_list//g' | sed 's/no_match_header//g' | sed 's/test//g' | sed 's/count//g' | sed '/^$/d' > file_list
    
      
    # If tot_header does not exist, Create tot_header
    if [ ! -f tot_header ]; then
        # Get first file from file_list
        export first_filename=$(cat file_list | head -n 1)
        echo "first_filename"
        echo $first_filename  # (ie: 202004-divvy-tripdata.csv)
        
        # Clean header from csv file and put in a new file
        clean_csv_header $first_filename     # (ie: ride_id \n rideable_type \n started_at)
        mv dummy_name tot_header
        
        # Remove first_filename from file_list
        cat file_list | sed '/'$first_filename'/d' > temp
        mv temp file_list
    fi
    
    # Delete any program related files
    delete_temp_files
    
    # ***** OUTPUT [file_list, tot_header] *****
}

# ---------------------------

clean_csv_header(){

    # Inputs:  
    # $1 = $filename
    
    # ---------------------------------------------
    # Clean header from csv file and put in a new file
    # ---------------------------------------------
    # Get the first line of $first_filename, remove double/single quotes, put each word on a newline 
    cat $1 | head -n 1 | sed 's/"//g' | sed "s/'//g" | tr "," '\n' | sort -u > dummy_name  # (ie: ride_id \n rideable_type \n started_at)
    
    # Clean csv file header
    export to_replace=$(cat $1 | head -n 1)
    export to_replace_with=$(cat $1 | head -n 1 | sed 's/"//g' | sed "s/'//g")
    # Modify the csv : replaces the word in the entire file
    cat $1 | sed "s/$to_replace/$to_replace_with/g" > new_csv
    mv new_csv $1
        
    # ***** OUTPUT [dummy_name] *****
}

# ---------------------------

# Needs to contain a list of all the files the program creates.

delete_temp_files(){
    if [ -f colBvalue ]; then
       rm colBvalue
    fi
  
    if [ -f diff ]; then
       rm diff
    fi
  
    if [ -f diffrow ]; then
       rm diffrow
    fi

    if [ -f dummy_name ]; then
       rm dummy_name
    fi
  
    if [ -f file0 ]; then
       rm file0
    fi
  
    if [ -f file1 ]; then
       rm file1
    fi
  
    if [ -f file2 ]; then
       rm file2
    fi
  
    if [ -f file3 ]; then
       rm file3
    fi
    
    if [ -f file4 ]; then
       rm file4
    fi
    
    if [ -f file5 ]; then
        rm file5
    fi
    
    if [ -f filetemp_reevaluate ]; then
        rm filetemp_reevaluate
    fi
    
    if [ -f filetemp ]; then
        rm filetemp
    fi
    
    if [ -f header2reevaluate_per_row ]; then
        rm header2reevaluate_per_row
    fi
    
    if [ -f header2 ]; then
        rm header2
    fi
    
    if [ -f header_match_count_per_file ]; then
        rm header_match_count_per_file
    fi
    
    if [ -f header_reduced ]; then
        rm header_reduced
    fi
    
    if [ -f modelscores ]; then
        rm modelscores
    fi
    
    if [ -f new_csv ]; then
        rm new_csv
    fi
    
    if [ -f result ]; then
        rm result
    fi
    
    if [ -f rows_that_repword_appear ]; then
        rm rows_that_repword_appear
    fi
    
    if [ -f sim_float ]; then
        rm sim_float
    fi
    
    if [ -f sim_int ]; then
        rm sim_int
    fi
    
    if [ -f tempcount ]; then
        rm tempcount
    fi
    
    if [ -f to_replace_assignment ]; then
        rm to_replace_assignment
    fi
    
    if [ -f tot_headerreevaluate_per_row ]; then
        rm tot_headerreevaluate_per_row
    fi
    
    if [ -f uqtemp ]; then
        rm uqtemp
    fi
    
    if [ -f temp ]; then
        rm temp
    fi
}

# ---------------------------

# Considers substring match of words
word2substrs(){

    # Inputs:  
    # $1 = f_row
    
    # Get the character length of the word
    export len=$(echo -n "$1" | wc -m)  # *** for the function we use $1 for the input $f_row ***
    # echo "len"
    # echo $len
    
    cnt0=0  ### IT starts from 0 unlike an array ###
    cnt1=2 # **** reset inner loop **** 0
    while [ $cnt0 -le $len ]
    do
       # echo "cnt0:"
       # echo $cnt0
       
       while [ $cnt1 -le $len ]
       do
         # echo "cnt1:"
         # echo $cnt1
       
         # ${string:start_position:sub_strwidth} 
         out=${1:$cnt0:$cnt1}  # *** for the function we use $1 for the input $f_row ***
         # echo "out:"
         # echo $out
         
         # Creates the file result and closes it
         echo $out >> result
         cnt1=$((cnt1+1))
       done
       
       cnt1=2  # **** reset inner loop ****
       cnt0=$((cnt0+1))
    done

    # Opens result, Remove white spaces, puts contents into temp (*** can not save directly to result***)
    cat result | sed '/^$/d' > temp
    mv temp result # *** resave over result ***
    
    # ***** OUTPUT [result] *****
}

# ---------------------------

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
	    
	    echo "header2 : flag=1, r=$r, header2_word=$header2_word reduce_header2_to_unique_words"
	    cat header2
	    
	fi
	
    done
    
    # Remove white/empty space at the end : an empty file means that all the words in header2 were in tot_header
    cat header2 | sed '/^$/d' > temp
    mv temp header2
    
# ***** OUPUT : replaced version of header2 (where only values are lexically different than tot_header)
}

# ---------------------------

model_evaluation(){

    echo "model_evaluation"

    # Inputs:  
    # $1 = $f_row                         # environmental variable (ie: ride_id from header2 file)
    # $2 = $header_reduced_list           # environmental variable (ie: ride_id,rideable_type,started_at from tot_header file)
    # $3 = $header_count_list_reduced     # environmental variable (ie: 89,34,29 via substring_evaluation)
    
    # ---------------------------
    # 
    export f_row_quotes=$(echo $1 | sed 's/^/"/g' | sed 's/$/"/g' | tr -d '\r')
    echo "f_row_quotes: "
    echo $f_row_quotes
      
    export header_list_reduced_quotes=$(echo $2 | sed 's/^/"/g' | sed 's/,/","/g' | sed 's/$/"/g' | tr -d '\r')
    echo "header_list_reduced_quotes: "
    echo $header_list_reduced_quotes
    
    export header_list_reduced_noquotes=$(echo $header_list_reduced_quotes | sed 's/"//g' | tr -d '\r')
    # ---------------------------
    
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
    
    # echo "sim_float"
    # cat sim_float
    
    # ---------------------------
    # Calculate the max similarity and vector
    for csim in $(cat sim_float)
    do 
      echo "scale=0;$csim*100" | bc | cut -d '.' -f 1 >> sim_int
    done
    rm sim_float
    # ---------------------------
    
    echo "sim_int"
    cat sim_int  # vector as long as $header_list_reduced_quotes
      
    # ---------------------------
    max=$(cat sim_int | sort -nr | head -n1)
    echo "max: "
    echo $max
    # ---------------------------
     
    # ---------------------------
    # Selection of most similar based on maximum similarity within each category
    # NOTE : filetemp is CREATED below 
    # ---------------------------
    c=1  # ****** ALL vectors start at 1 ******
    for csim in $(cat sim_int)
    do
        if [[ $csim == $max ]] && [[ $csim -gt 60 ]]; then
            
          export to_replace=$(echo $1)
          export to_replace_with=$(cat header_reduced | head -n $c | tail -n $(($c-($c-1))))
           
          # Way 1
          export sim_int_concat=$(cat sim_int | paste -s -d "," | tr -d '\r')
          echo $to_replace' '$to_replace_with' '$3' '$csim' '$sim_int_concat' '$header_list_reduced_noquotes >> filetemp
        else
            # Append spaces in filetemp
            echo "" >> filetemp
        fi
        c=$((c+1))
    done
    
    rm sim_int
    rm header_reduced  # header_reduced contains header values where substring were greater than avg
    # ---------------------------
    
    # ***** OUTPUT [filetemp] *****
}

# ---------------------------

substring_evaluation(){
    
    echo "substring_evaluation"
    
    # Inputs:  
    # $1 = $f_row               # environmental variable (ie: ride_id from header2 file)
    # $2 = tot_header           # file (ie: ride_id \n rideable_type \n started_at)
    
    # ---------------------------
    if [ -f header_match_count_per_file ]; then
      rm header_match_count_per_file
    fi
    # ---------------------------
    
    for h_row in $(cat $2)
      do
        # ---------------------------
        # cut the word in $f_row into substrings : creates result with substrings
        word2substrs $1
        # OUTPUT : result
        # ---------------------------
        
        # ---------------------------
        if [ -f temp ]; then
          rm temp
        fi
        # ---------------------------
        
        # ---------------------------
        # Must put the row header word in a file
        echo $h_row > temp
        
        sum=0
        for ss in $(cat result)
        do
          export count=$(grep $ss temp | wc -l)
          sum=$((sum  + $count))
        done
        
        rm temp
        rm result
        
        # Now we have the sum of the filename substrings per header : should be as long as header
        echo $sum >> header_match_count_per_file
        # ---------------------------
     
    done  # end of h_row
      
      
    # ---------------------------
    # Way 1: assign header rows to file rows based on a comparative count threshold in header_match_count_per_file
      
    # Take the average of header_match_count_per_file
    export sum=$(cat header_match_count_per_file | paste -s -d "+" | bc)
    export N=$(wc header_match_count_per_file |cut -d ' ' -f 2)

    export avg=$(echo "scale=0;$sum/$N" | bc)
    # echo "avg: "
    # echo $avg
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
          cat $2 | head -n $r | tail -n $(($r-($r-1))) >> header_reduced
          
          echo $h_row_count >> tempcount
      fi
      r=$((r+1))
    done
      
    rm header_match_count_per_file
    # -------------------------------------
      
    # ***** OUTPUT : [header_reduced, tempcount] *****
}


# ---------------------------

similarity_assignment(){

    echo "similarity_assignment"

    # Inputs:  
    # $1 = header2  # file (ie: ride_id \n rideable_type \n started_at)
    # $2 = tot_header  # file (ie: ride_id \n rideable_type \n started_at)
    
    # *** The filenames are not used because this function is called many times with other filenames ***
    
    echo "Verify header2 values: "
    cat $1
    
    # Purpose : Fills header file with headeronly words
    for f_row in $(cat header2)
    do
      echo "f_row: "
      echo $f_row
      
      substring_evaluation $f_row $2
      # OUTPUT : header_reduced, tempcount
      
      export header_count_list_reduced=$(cat tempcount | paste -s -d "," | tr -d '\r')
      # echo "header_count_list_reduced: "
      # echo $header_count_list_reduced
      
      rm tempcount
      
      export header_reduced_list=$(cat header_reduced | paste -s -d "," | tr -d '\r')
      # echo "header_reduced_list: "
      # echo $header_reduced_list
      
      model_evaluation $f_row $header_reduced_list $header_count_list_reduced
      
      # Remove empty spaces from rows
      cat filetemp | sed '/^$/d' > temp
      mv temp filetemp
      
    done  # end of f_row
    
    # ***** OUTPUT [filetemp] *****
}

# ---------------------------
    
colAselection_colBoutput(){

    echo "colAselection_colBoutput"
    
    # ----------------------
    # Equivalent usage with awk: but unreliable sometimes (gives a syntax error sometimes)
    # ----------------------
    # Using file difftemp, select col1, search for $min_lex_cnt_diff, output col2 aligned value
    # export colBvalue=$(cat difftemp | awk '{if($1=='$min_lex_cnt_diff'){print $2}}')
    
    # ----------------------
    # Example usage
    # ----------------------
    # export file_name=$(echo 'difftemp')
    # export select_colnum=$(echo '1')
    # export select_colnum_pattern_search=$(echo $min_lex_cnt_diff)
    # export aligned_output_colnum=$(echo '2')
    
    # Logic : if column1==x, select corresponding column2 value
    
    # Inputs:  
    # $1 = file_name [file with a matrix structure]
    # $2 = select_colnum [column number to search for a string pattern match]
    # $3 = $select_colnum_pattern_search [string pattern]
    # $4 = $aligned_output_colnum [output column number where one desires to have the value aligned with the row where the string pattern was found]
    
    r=1
    export colBvalue=$(echo "")
    for i in $(cat $1)
    do
       export colA_search_pattern=$(echo $3)
       export colB_desired_output=$(cat $1 | cut -d ' ' -f $4 | head -n $r | tail -n $(($r-($r-1))))
       export row_format=$(echo $i | cut -d ' ' -f $2 | head -n $r | tail -n $(($r-($r-1)))) # select column 1, and variable row 
       
       if [ $row_format == $colA_search_pattern ]; then
          export colBvalue1=$(echo $colB_desired_output) # there should be only one match so store the value one time
          export colBvalue=$(echo $colBvalue" "$colBvalue1)
       fi
       r=$((r+1))
    done
    
    echo $colBvalue > colBvalue
    # return $colBvalue
}

# ---------------------------

get_to_replace_assignment(){
    
    echo "get_to_replace_assignment"
    
    # Inputs:
    # $1 = $repword
    # $2 = $maxvalue
    # $3 = $count
    # rows_that_repword_appear
    # filetemp
    

    # [file and csv modification] assign repword to the value of to_replace in the row (in file and the csv)
    if [[ $3 -gt 1 ]]; then
       # If the model predicts two or more matches EQUALLY : select the row with the minimum lexical difference 
       
       echo "Model predicts two or more matches EQUALLY"
       
       for r in $(cat rows_that_repword_appear)
       do 
          echo "r: "
          echo $r
          
          export maxscore=$(cat filetemp | cut -d ' ' -f 4 | head -n $r | tail -n $(($r-($r-1))))
          echo "maxscore: "
          echo $maxscore
          
          if [ $maxscore == $2 ]; then
              
              # NOTE : $3 corresponds to the 3rd column in filetemp, NOT $count
              export maxcount_per_row=$(cat filetemp | awk '{print $3}' | head -n $r | tail -n $(($r-($r-1))) | tr "," '\n' | sort -n | tail -n 1)
              echo "maxcount_per_row: "
              echo $maxcount_per_row
          
              export mincount_per_row=$(cat filetemp | awk '{print $3}' | head -n $r | tail -n $(($r-($r-1))) | tr "," '\n' | sort -n | head -n 1)
              echo "mincount_per_row: "
              echo $mincount_per_row
          
              echo "scale=0;$maxcount_per_row-$mincount_per_row" | bc >> diff
              echo $r >> diffrow
          fi
       done
       
       rm rows_that_repword_appear
       
       if [ -f difftemp ]; then
          rm difftemp
        fi
        
       # Construct a matrix of these values: difftemp=[diff difftemp]  
       paste diff diffrow -d " " >> difftemp
       rm diff diffrow
       
       echo "difftemp"
       cat difftemp
       
       # Find the min value of column 1 of difftemp [minimum lexical count difference]
       export min_lex_cnt_diff=$(cat difftemp | awk '{print $1}' | sort -n | head -n 1)
       echo "min_lex_cnt_diff"
       echo $min_lex_cnt_diff
       
       # Using file difftemp, select col1, search for $min_lex_cnt_diff, output col2 aligned value
       export file_name=$(echo 'difftemp')
       export select_colnum=$(echo '1')
       export select_colnum_pattern_search=$(echo $min_lex_cnt_diff)
       export aligned_output_colnum=$(echo '2')
       colAselection_colBoutput $file_name $select_colnum $select_colnum_pattern_search $aligned_output_colnum
       export rowdes=$(cat colBvalue)  # output of function
       rm colBvalue
       echo "rowdes: "
       echo $rowdes
       
       rm difftemp
       
       # Want to replace to_station_id with $repword=end_station_id : row $resdes, column filetemp
       export to_replace_assignment=$(cat filetemp | cut -d ' ' -f 1 | head -n $rowdes | tail -n $(($rowdes-($rowdes-1))))
       echo "to_replace_assignment: "
       echo $to_replace_assignment
       
    else
       echo "Model predicts two or more matches NON-EQUALLY"
       
       # If the model predicts two or more matches NON-EQUALLY (max_score_values has one maximum) : model assigns one header value to a file value based on meaning/context
       
       # There could be multiple repword in column 2 , find column2=repword and column4=maxvalue, output col1
       r=1
       for line_in_file in $(cat filetemp)
       do 
          # Select the entire row in filetemp
          export col1=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 1 | tr -d '\r')
          export col2=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 2 | tr -d '\r')
          export col4=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 4 | tr -d '\r')
          
          if [[ $col2 == $1 ]] && [[ $col4 == $2 ]]; then
            export to_replace_assignment=$(echo $col1)
          fi
          r=$((r+1))
       done
      
       echo "to_replace_assignment: "
       echo $to_replace_assignment
    fi
    
    echo $to_replace_assignment > to_replace_assignment
    #return $to_replace_assignment
    
    # ***** OUTPUT [to_replace_assignment] *****
}

# ---------------------------

get_modelscores_for_repword(){

    echo "get_modelscores_for_repword"
    
    # Inputs:  
    # filetemp
    # rows_that_repword_appear

    export modelscores=$(echo '')

    for r in $(cat rows_that_repword_appear)
    do
       export temp=$(cat filetemp | cut -d ' ' -f 4 | head -n $r | tail -n $(($r-($r-1))))
       export modelscores=$(echo $modelscores' '$temp)
    done
    
    # ***** OUTPUT : $modelscores *****
    
    # return $modelscores
    echo $modelscores > modelscores
}

# ---------------------------

modify_filetemp_header2(){

    echo "modify_filetemp_header2"

    # Inputs:  
    # $1 = $repword
    # $2 = $to_replace_assignment
    # header2  # file (ie: ride_id\nrideable_type\nstarted_at)
    # filetemp
    
    # -------------------------
    # Modify filetemp : main match assignment (replace [file=to_replace=column 1 of filetemp] with [best match header=repword=to_replace_with=column 2 of filetemp] )
    # -------------------------
    # Modify header2 : replaces the word in the entire file
    export to_replace_with_assignment=$(echo $1)
    echo "to_replace_with_assignment"
    echo $to_replace_with_assignment
    
    
    echo "Confirm contents of header2 BEFORE to_replace_with_assignment:"
    cat header2
    
    cat header2 | sed "s/$2/$to_replace_with_assignment/g" > temp
    mv temp header2

    # Modify the csv : replaces the word in the entire file
    cat $filename | sed "s/$2/$to_replace_with_assignment/g" > new_csv
    mv new_csv $filename
    
    echo "Confirm contents of header2 AFTER to_replace_with_assignment:"
    cat header2
    # -------------------------

    # -------------------------
    # [0] Modify filetemp column values : 
    echo "Modify filetemp column values:"
    
    # 1. remove [best match header word=repword] VALUE from columns 3, 4, 5
    # Get length of filetemp
    export n=$(cat filetemp | wc -l)
    echo "n: "
    echo $n
    
    for r in $( seq 1 $n )
    do 
      # Select the entire row in filetemp
      export col1_before=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 1 | tr -d '\r')
      export col2_before=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 2 | tr -d '\r')
      export col3_before=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 3 | tr -d '\r') # do not erase the substring count values
      # export col4_before=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 4 | tr -d '\r')
      # export col5_before=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 5 | tr -d '\r')
      # export col6_before=$(cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 6 | tr -d '\r')
      
      # After assignment : signifies that this row needs to be re-evaluated for a file-header match
      
      # If col2_before == repword, replace with X,
      if [ $col2_before == $1 ]; then
         export col2_after=$(echo 'X')
      else
         export col2_after=$(echo $col2_before)
      fi
      
      # Make matrix of columns 3,5,6
      cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 3 | tr "," '\n' >> file0
      cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 5 | tr "," '\n' >> file1
      cat filetemp | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 6 | tr "," '\n' >> file2
      paste file0 file1 file2 -d " " >> file3
      
      # Remove [best match header word=repword] from column 6
      cat file3 | sed "/$1/d" > file4
      
      #export col3_after=$(cat file4 | cut -d ' ' -f 1 | paste -s -d "," | tr -d '\r')
      export col5_after=$(cat file4 | cut -d ' ' -f 2 | paste -s -d "," | tr -d '\r')
      export col6_after=$(cat file4 | cut -d ' ' -f 3 | paste -s -d "," | tr -d '\r')
      
      # Recalculate max for column 4 using the updated column 5
      export col4_after=$(cat file4 | cut -d ' ' -f 2 | sort -n | tail -n 1 | tr -d '\r')
      
      export to_replace=$(cat filetemp | head -n $r | tail -n $(($r-($r-1)))| tr -d '\r')
      echo "to_replace"
      echo $to_replace
      
      export to_replace_with=$(echo $col1_before' '$col2_after' '$col3_before' '$col4_after' '$col5_after' '$col6_after)
      echo "to_replace_with"
      echo $to_replace_with
      
      # Update filetemp
      cat filetemp | sed "s/$to_replace/$to_replace_with/g" > file5
      mv file5 filetemp
      
      rm file0 file1 file2 file3 file4
    done
    
    echo "filetemp after removing repword:"
    cat filetemp
    # -------------------------

    # -------------------------
    # [1] Modify filetemp row values 
    # -------------------------
    # [filetemp modification] delete the row that was assigned from filetemp

    # Use the to_replace value because these are unique values from file.
    cat filetemp | sed "/$2/d" > temp
    mv temp filetemp
    
    echo "filetemp after deleting matched row:"
    cat filetemp
    # -------------------------
    
    # ***** OUTPUT [filetemp] *****
 }

# ---------------------------

reevaluation_assignment(){

    echo "reevaluation_assignment"

    # Inputs:
    # filetemp
        
    # -------------------------
    # When it falls out only unique and unassigned values of to_replace_with are left - reevalutate with model score
    
    # Make a temporary new "header2" with remaining col1 words
    cat filetemp | awk '{print $1, $6}' > filetemp_reevaluate
    
    # Delete filetemp for it to be recreated in similarity_assignment:model_evaluation
    rm filetemp
    
    # Get length of filetemp_reevaluate
    export n=$(cat filetemp_reevaluate | wc -l)
    echo "n: "
    echo $n
    
    for r in $( seq 1 $n )
    do  
        cat filetemp_reevaluate | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 1 | tr -d '\r' > header2reevaluate_per_row 
        echo "Verify header2reevaluate_per_row: "
        cat header2reevaluate_per_row
        
        cat filetemp_reevaluate | head -n $r | tail -n $(($r-($r-1))) | cut -d ' ' -f 2 | tr -d '\r' | sed 's/,/ /g' | sed -Ee '/[[:space:]]+$/s///' | sed 's/ /\n/g'  > tot_headerreevaluate_per_row
        echo "Verify tot_headerreevaluate_per_row: "
        cat tot_headerreevaluate_per_row
        
        # Re-run
        similarity_assignment header2reevaluate_per_row tot_headerreevaluate_per_row
        # ***** OUTPUT [filetemp] *****
        
        echo "filetemp during reevaluation_assignment LOOP :"
        cat filetemp
        
        rm header2reevaluate_per_row tot_headerreevaluate_per_row
    done
    
    rm filetemp_reevaluate
    
    echo "filetemp after RUNNING reevaluation_assignment :"
    cat filetemp
    # -------------------------
}

# ---------------------------

evaluation_reevaluation_assignment(){

    echo "evaluation_reevaluation_assignment"

    # Inputs:
    # filetemp
    # header2  # file (ie: ride_id\nrideable_type\nstarted_at)
        
    # -------------------------
    # Evaluation of assignment and reassignment
    # -------------------------
    # Evaluation of model score matches, to prevent no repeating matches and logical (lexical, meaning) matches
    # Stay in while loop until all header2 values [column 1 in filetemp] have matches
    
    # Check if filetemp is empty: break loop
    export empty=$(cat filetemp | wc -l)
    while [[ $empty != 0 ]]
    do
        # Get unique column 2 values [best match header=repword=to_replace_with=column 2 of filetemp]
        cat filetemp | cut -d ' ' -f 2 | sort -u | tr " " '\n' > uqtemp
        
        echo "uqtemp: "
        cat uqtemp

        for repword in $(cat uqtemp)
        do
           # -------------------------
           # Testing only
           # export repword=$(echo "ride_id")  # end_station_id end_station_name ride_id
           echo "repword: "
           echo $repword
           # -------------------------
           
           # -------------------------
           # Get the rows of filetemp for repword
           # export rows_that_repword_appear=$(cat filetemp | cut -d ' ' -f 2 | sed -n '/'$repword'/=')
           cat filetemp | cut -d ' ' -f 2 | sed -n '/'$repword'/=' | tr " " '\n' > rows_that_repword_appear
           echo "rows_that_repword_appear: "
           cat rows_that_repword_appear
           
           # Get model scores for repword
           get_modelscores_for_repword
           # export modelscores=$(echo $?)  # OUTPUT of function
           export modelscores=$(cat modelscores)  # OUTPUT of function
           echo "modelscores: "
           echo $modelscores
           
           # Get the maxvalue of model scores for repword
           export maxvalue=$(echo $modelscores | tr " " '\n' | sort -n | tail -n 1)
           echo "maxvalue: "
           echo $maxvalue
           
           # Check if the maxvalue repeats, to find cases where the model equally interprets a match
           export count=$(grep -o $maxvalue <<<"$modelscores" | grep -c .)
           echo "count: "
           echo $count
           # -------------------------
           
           get_to_replace_assignment $repword $maxvalue $count
           export to_replace_assignment=$(cat to_replace_assignment)  # OUTPUT of function
           rm to_replace_assignment
           
           # -------------------------
           
           # Assign model score matches to header2/csv, delete model score matches from filetemp
           modify_filetemp_header2 $repword $to_replace_assignment
           # OUTPUT : filetemp (should become empty exactly at the last loop)
           
        done # END for loop [for repword in $(cat uqtemp)]

        # OUTPUT : header2, filetemp
        
        # -------------------------
        
        # Check if filetemp is empty: break loop
        export empty=$(cat filetemp | wc -l)
        
        # OR
        if [[ $empty != 0 ]]; then
            
            reevaluation_assignment
            # ***** OUTPUT [filetemp] *****
            
            # Check if filetemp is empty: break loop
            export empty=$(cat filetemp | wc -l)
            
            if [[ $empty != 0 ]]; then
                echo "**** filetemp contains entries : redo evaluation_reevaluation_assignment ****"
            else
                break  # break while loop
            fi
        else
            break  # break while loop
        fi

    done # END while loop [while [[ $empty != 0 ]]]
}



check_if_header2_is_similar_to_totheader(){

    echo "check_if_header2_is_similar_to_totheader"

    # Inputs:
    # $1 = filename
    # header2
    # tot_header
    
    # ---------------------------
    # Determine if files are in the same table or a different table, OR if it is worth it to do a similarity analysis
    # ---------------------------

    # I checked similarity of header2 and tot_header AFTER similarity_assignment because it is a final check (maybe some misspelled words cause it to not be similar)

    # If it has at least one column match, include it in tot_header
    if [ -f count ]; then
        rm count
    fi
    
    # load tot_header, put bars between words, put in a file named test
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
      
      # Count each word in header2 in tot_header
      # Count fixed strings (-F) from a file per line
      export loc_in_curheader=$(grep -n -F $genheader_bars1 test)
      # echo "loc_in_curheader:"
      # echo $loc_in_curheader
      
      # Make a binary file showing which words are in tot_header: 0=not_in_file, 1=in_file
      if [ ! -f $loc_in_curheader ]; then
        
        if [[ $OPTION -eq "0" ]]; then
           # OPTION 0 : replace word in file by empty space
      	   export to_replace=$(echo $header2_word)
      	   export to_replace_with=$(echo "")
      	   # Purposely do not change the length of header2 ( | sed '/^$/d') to keep for loop index
      	   cat header2 | sed "s/$to_replace/$to_replace_with/g" > temp
      	   mv temp header2
      	elif [[ $OPTION -eq "1" ]]; then
      	   # OPTION 1 : count
           echo 1 >> count
        fi
      else
        # No match found, insert null column
        if [[ $OPTION -eq "0" ]]; then
      	   # 
      	   echo ""
        elif [[ $OPTION -eq "1" ]]; then
      	   # OPTION 1 : count
           echo 0 >> count
        fi
      fi
    done
    
    # Sum to get total number of header2 words in tot_header
    export sum=$(cat count | paste -s -d "+" | bc)
    echo "sum: "
    echo $sum

    # ---------------------------
    if [[ "$sum" -gt 0 ]];then
      # Update tot_header with header2 values : one or more header2 values are in tot_header
      cat tot_header header2 | sort -u | sed '/^$/d' > temp
      mv temp tot_header
    else
      # Move the csv to another folder : NO header2 values are in tot_header
      mkdir no_match_header
      mv $1 no_match_header
    fi
    # ---------------------------

}



# ---------------------------
# Functions END
# ---------------------------





# [Step 0] Obtain a global header [tot_header] for similarily labeled datasets 

initial_setup
# ***** OUTPUT [file_list, Create tot_header] *****



# Loop through the list of csv files in the directory
for filename in $(cat file_list)
do
    echo "filename: "  
    echo $filename  # (ie: 202005-divvy-tripdata.csv)
    
    # [Create header2] Clean header from csv file and put in a new file
    clean_csv_header $filename     # (ie: ride_id \n rideable_type \n started_at)
    mv dummy_name header2
    
    echo "header2 : AFTER clean_csv_header"
    cat header2
    
    # Make temporary environmental variables for tot_header and header2
    tot_header_ev=$(cat tot_header | paste -s -d "," | tr -d '\r')
    echo "tot_header_ev: "  
    echo $tot_header_ev
    
    header2_ev=$(cat header2 | paste -s -d "," | tr -d '\r')
    echo "header2_ev: "  
    echo $header2_ev
    
    # Check if tot_header and header2 have text
    if [[ -n "$tot_header_ev" ]] || [[ -n "$header2_ev" ]]; then
        echo "tot_header and header2 are NOT EMPTY, continue with ingestion"
        
        # Check if tot_header and header2 are equal
        if [[ "$tot_header_ev" != "$header2_ev" ]]; then
            echo "*** headers are NOT exact match ***"
            
            unset $tot_header_ev
            unset $header2_ev
            
            # header2 and tot_header are NOT equal
            
            reduce_header2_to_unique_words
            
            echo "header2 : AFTER reduce_header2_to_unique_words"
            cat header2
            
            
            # ------- Problem here
            # Correct words in header2 that may have the same meaning as words in tot_header
            similarity_assignment header2 tot_header
            # OUTPUT : filetemp -- the file contains model score matches
            
            # Ensure that filetemp exists
            if [ -f filetemp ]; then
                evaluation_reevaluation_assignment
            fi
            # OUTPUT : header2 (where tot_header was compared with header2, and non-unique matches were saved to header2)
            
        else
            # EXACT match : header1 == header2, merge (one of them) header2 with tot_header
            echo "*** headers are exact match ***"
        fi
        
        check_if_header2_is_similar_to_totheader $filename
        
    else
        echo "tot_header and/or header2 are EMPTY, go to next file"
        mkdir empty_header
        mv $filename empty_header
    fi
    
    # Delete any program related files
    delete_temp_files
    
done # end of [for filename in $(cat folder_list2)]



