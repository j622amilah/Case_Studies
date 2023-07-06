#!/bin/bash

export cur_path=$(pwd)

cd /home/oem2/Documents/PROGRAMMING/Github_analysis_PROJECTS/GCP_ingestion_analysis_tools/git2/GCP_ingestion_analysis_tools

source ./GCP_bigquery_case_study_library.sh
source ./GCP_bigquery_case_study_library.sh
source ./GCP_common_header.sh

cd $cur_path




# ---------------------------
# Functions START
# ---------------------------

step0_download_data(){

		
	# ---------------------------------------------
	# Set Desired location
	# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
	# ---------------------------------------------
	# Set the project region/location
	export region=$(echo "eu-west-3")

	# Set desired output format
	export output=$(echo "text")  # json, yaml, yaml-stream, text, table

	# ---------------------------------------------



	# ---------------------------------------------
	# Setup ROOT AWS credentials 
	# ---------------------------------------------
	export val=$(echo "X0")

	if [[ $val == "X0" ]]
	then 
	    # Generate a new ROOT access key : This information gets sent to the /home/oem2/.aws/credentials and /home/oem2/.aws/config files
	    # AWS site: Go to https://aws.amazon.com/fr/ 
	    # 	- Services - Security, Identity, & Compliance - IAM
	    # 	- To go to root user settings : Quick Links - My security credentials
	    # 	- Open CloudShell - aws iam create-access-key
	    # 
	    #}   "CreateDate": "2023-06-21T09:20:32+00:00"ZY2s6SVxna6uvGfCCDK",
	    #{
	    #"AccessKey": {
	    #    "AccessKeyId": "AKIAUZDPRVKIJFUOJANI",
	    #    "Status": "Active",
	    #    "SecretAccessKey": "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",
	    #    "CreateDate": "2023-06-21T09:20:32+00:00"
	    #}
	    #
	    # OR
	    # 
	    # PC terminal (did not work) - aws iam create-access-key
	    
	    # Set configuration file : aws_access_key_id and aws_secret_access_key are automatically put in /home/oem2/.aws/credentials and /home/oem2/.aws/config files
	    aws configure set region $region
	    aws configure set output $output
	    
	    export AWS_ACCESS_KEY_ID=$(echo "AKIAUZDPRVKIJFUOJANI")
	    export AWS_SECRET_ACCESS_KEY=$(echo "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")
	else
	    echo "Do not setup ROOT AWS credentials"
	fi



	# ---------------------------------------------
	# Setup USER AWS credentials 
	# ---------------------------------------------
	export val=$(echo "X1")

	if [[ $val == "X0" ]]
	then 
	    # Follow instructions at CREATE a username
	    
	    export USERNAME=$(echo "jamilah")
	    
	    aws iam create-access-key --user-name $USERNAME
	    
	    # Set configuration file: put information into /home/oem2/.aws/credentials and /home/oem2/.aws/config files
	    aws configure set aws_access_key_id AKIAUZDPRVKIPHOVBEXG --profile $USERNAME
	    aws configure set aws_secret_access_key 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 --profile $USERNAME
	    aws configure set region $region --profile $USERNAME
	    aws configure set output $output --profile $USERNAME
	    
	    # Set environmental variables
	    export AWS_ACCESS_KEY_ID=$(echo "AKIAUZDPRVKIPHOVBEXG")
	    export AWS_SECRET_ACCESS_KEY=$(echo "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")
	else
	    echo "Do not setup USER AWS credentials"
	fi




	# ---------------------------------------------
	# Make random number for creating variable or names
	# ---------------------------------------------
	if [[ $val == "X1" ]]
	then 
	    let "randomIdentifier=$RANDOM*$RANDOM"
	else
	    let "randomIdentifier=202868496"
	fi

	# ---------------------------------------------





	# ---------------------------------------------
	# Storage S3 commands
	# ---------------------------------------------
	export val=$(echo "X0")

	if [[ $val == "X0" ]]
	then 
	    # List buckets and objects
	    aws s3 ls
	    
	    # Download files from a public S3 Bucket
	    export bucket_name=$(echo "divvy-tripdata")  # https://divvy-tripdata.s3.amazonaws.com/index.html
	    
	    export cur_path=$(pwd)
	    echo "cur_path"
	    echo $cur_path

	    export folder_2_organize=$(echo "bike_casestudy/dataORG")
	    echo "folder_2_organize"
	    echo $folder_2_organize

	    export path_folder_2_organize=$(echo "${cur_path}/${folder_2_organize}")

	    aws s3 cp --recursive s3://$bucket_name $path_folder_2_organize
	    
	else
	    echo ""
	fi

	# ---------------------------------------------


}




organize_zip_files_from_datasource_download(){

	# Open the zip files and move the files to three folders: zipdata, csvdata, remaining_files
	
	
	# ---------------------------------------------
	# Make ingestion folder and transfer files
	# ---------------------------------------------
	export val=$(echo "X0")

	if [[ $val == "X0" ]]
	then

	    mkdir $path_ingestion_folder
	    cp -a $path_folder_2_organize/. $path_ingestion_folder
		
	fi

	# ---------------------------------------------




	# ---------------------------------------------
	# Unzip files
	# ---------------------------------------------
	export val=$(echo "X0")

	if [[ $val == "X0" ]]
	then 

	    # Unzip file options
	    # -f  freshen existing files, create none
	    # -n  never overwrite existing files
	    # -o  overwrite files WITHOUT prompting

	    cd $path_ingestion_folder

	    ls *.zip > arr
	    
	    for i in $(cat arr)
	    do
	       unzip -o $i
	    done

	    mkdir zipdata
	    mv *.zip zipdata

	    # Clean-up treatment files
	    rm arr
	    
	fi

	# ---------------------------------------------




	# ---------------------------------------------
	# Secondary clean up of files
	# ---------------------------------------------
	export val=$(echo "X0")

	if [[ $val == "X0" ]]
	then 
	    
	    # get main path
	    # export cur_path=$(pwd)
	    # echo "cur_path:"
	    # echo $cur_path
	    
	    # Get path of folder to search
	    # export path_ingestion_folder=$(echo "${cur_path}/${folder_2_organize}")
	    # echo "path_ingestion_folder:"
	    # echo $path_ingestion_folder
	    # /home/oem2/Documents/COURS_ONLINE/Spécialisation_Google_Data_Analytics/3_Google_Data_Analytics_Capstone_Complete_a_Case_Study/bike_casestudy/dataORG
	    
	    # find folders inside of the folder to search
	    cd $path_ingestion_folder
	    
	    # Rename all the files so they do not have any spaces
	    for f in *\ *; do mv "$f" "${f// /_}"; done
	    
	    # write folder names in file
	    ls -d */ >> folder_list
	   
	    # move folder contents into data
	    # export i=$(echo "Divvy_Stations_Trips_2013/")
	    for i in $(cat folder_list)
	    do
	      export new_path=$(echo "${path_ingestion_folder}/${i}")
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
		mv $new_path2 $path_ingestion_folder 
	      done
	      
	      # delete folders
	      rm folder_list2
	      
	      cd $path_ingestion_folder
	      
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
	    
	    find $path_ingestion_folder -maxdepth 1 -type f >> nondir_folder_list
	    
	    # remove the directory items from the file all_file_list
	    for i in $(cat nondir_folder_list)
	    do
	      mv $i remaining_files
	    done
	    
	    rm remaining_files/nondir_folder_list
	    # --------------

	fi

	# ---------------------------------------------
	


}



# ---------------------------
# Functions END
# ---------------------------






# ---------------------------------------------
# Setup google cloud sdk path settings
# ---------------------------------------------
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
    # Google is SDK is not setup correctly - one needs to relink to the gcloud CLI everytime you restart the PC
    source '/usr/lib/google-cloud-sdk/path.bash.inc'
    source '/usr/lib/google-cloud-sdk/completion.bash.inc'
    export PATH="/usr/lib/google-cloud-sdk/bin:$PATH"
    
    # Get latest version of the Google Cloud CLI (does not work)
    gcloud components update
else
    echo "Do not setup google cloud sdk PATH"
fi



# ---------------------------------------------
# Obtenir des informations Authorization
# ---------------------------------------------
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
    # Way 0 : gcloud init


    # Way 1 : gcloud auth login

    # A browser pop-up allows you to authorize with your Google account
    gcloud auth login

    # ******* need to set up this
    # gcloud auth login --no-launch-browser
    # gcloud auth login --cred-file=CONFIGURATION_OR_KEY_FILE
    
    # Allow for google drive access, moving files to/from GCP and google drive
    # gcloud auth login --enable-gdrive-access
    
else
    echo ""
    # echo "List active account name"
    # gcloud auth list
fi




# ---------------------------------------------
# Make random number for creating variable or names
# ---------------------------------------------
if [[ $val == "X1" ]]
then 
    let "randomIdentifier=$RANDOM*$RANDOM"
else
    let "randomIdentifier=202868496"
fi

# ---------------------------------------------



# ---------------------------------------------
# Set Desired location
# https://cloud.google.com/bigquery/docs/locations
# ---------------------------------------------
# Set the project region/location
# export location=$(echo "europe-west9-b")  # Paris
export location=$(echo "europe-west9")  # Paris
# export location=$(echo "EU")
# export location=$(echo "US")   # says US is the global option

# ---------------------------------------------





# ---------------------------------------------
# ENABLE API Services
# ---------------------------------------------
export val=$(echo "X0")

if [[ $val == "X0" ]]
then

    gcloud services enable iam.googleapis.com \
        bigquery.googleapis.com \
        logging.googleapis.com
  
fi

# ---------------------------------------------






# ---------------------------------------------
# SELECT PROJECT_ID
# ---------------------------------------------
export val=$(echo "X0")

if [[ $val == "X0" ]]
then 
    # List projects
    # gcloud config list project
    
    # Set project
    export PROJECT_ID=$(echo "northern-eon-377721")
    gcloud config set project $PROJECT_ID

    # List DATASETS in the current project
    # bq ls $PROJECT_ID:
    # OR
    # bq ls

    #  datasetId         
    #  ------------------------ 
    #   babynames               
    #   city_data               
    #   google_analytics_cours  
    #   test       

    # ------------------------

fi

# ---------------------------------------------







# ---------------------------------------------
# SELECT dataset_name
# ---------------------------------------------
export val=$(echo "X0")

if [[ $val == "X0" ]]
then 

    # Create a new DATASET named PROJECT_ID
    # export dataset_name=$(echo "google_analytics_exercise")
    # bq --location=$location mk $PROJECT_ID:$dataset_name

    # OR 

    # Use existing dataset
    export dataset_name=$(echo "google_analytics_exercise")

    # ------------------------

    # List TABLES in the dataset
    # echo "bq ls $PROJECT_ID:$dataset_name"
    # bq --location=$location ls $PROJECT_ID:$dataset_name

    #           tableId            Type    Labels   Time Partitioning   Clustered Fields  
    #  -------------------------- ------- -------- ------------------- ------------------ 
    #   avocado_data               TABLE                                                  
    #   departments                TABLE                                                  
    #   employees                  TABLE                                                  
    #   orders                     TABLE                                                  
    #   student-performance-data   TABLE                                                  
    #   warehouse                  TABLE

    # ------------------------

    # echo "bq show $PROJECT_ID:$dataset_name"
    # bq --location=$location show $PROJECT_ID:$dataset_name

    #    Last modified             ACLs             Labels    Type     Max time travel (Hours)  
    #  ----------------- ------------------------- -------- --------- ------------------------- 
    #   08 Mar 11:40:52   Owners:                            DEFAULT   168                      
    #                       j622amilah@gmail.com,                                               
    #                       projectOwners                                                       
    #                     Writers:                                                              
    #                       projectWriters                                                      
    #                     Readers:                                                              
    #                       projectReaders  

    # ------------------------

fi


# ---------------------------------------------







# ---------------------------------------------
# Download data from datasource (AWS)
# ---------------------------------------------
# step0_download_data




# ---------------------------------------------
# Organize zip files
# ---------------------------------------------
# export path_folder_2_organize=$(echo "/home/oem2/Documents/ONLINE_CLASSES/Spécialisation_Google_Data_Analytics/3_Google_Data_Analytics_Capstone_Complete_a_Case_Study/exercise_casestudy")

# export ingestion_folder=$(echo "ingestion_folder_bikeshare")

# export path_outside_of_ingestion_folder=$(echo "/home/oem2/Documents/ONLINE_CLASSES/Spécialisation_Google_Data_Analytics/3_Google_Data_Analytics_Capstone_Complete_a_Case_Study")

# organize_zip_files_from_datasource_download $path_folder_2_organize $ingestion_folder $path_outside_of_ingestion_folder



# ---------------------------------------------
# Organize files into separate csv files
# ---------------------------------------------
run_GCP_common_header_program


# ---------------------------------------------
# Upload csv files from the PC to GCP
# ---------------------------------------------
# ******* CHANGE *******
# export cur_path=$(echo "/home/oem2/Documents/ONLINE_CLASSES/Spécialisation_Google_Data_Analytics/3_Google_Data_Analytics_Capstone_Complete_a_Case_Study/$ingestion_folder/csvdata")
# ******* CHANGE *******

# echo "cur_path"
# echo $cur_path
    
# upload_csv_files $location $cur_path $dataset_name



# -------------------------
# Join the TABLES 
# -------------------------





# -------------------------
# View the tables in the dataset
# -------------------------
# bq --location=$location ls $PROJECT_ID:$dataset_name




# -------------------------
# View the columns in a TABLE
# -------------------------
# export TABLE_name=$(echo "bikeshare_full")
# export TABLE_name=$(echo "bikeshare_full_clean0")
# export TABLE_name=$(echo "bikeshare_full_clean1")
# VIEW_the_columns_of_a_table $location $PROJECT_ID $dataset_name $TABLE_name 




# -------------------------
# Initially Clean the TABLE :  Identify the main features for the analysis
# -------------------------
# CLEAN_TABLE_exercise_full_clean0



