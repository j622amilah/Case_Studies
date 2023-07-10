#!/bin/bash



# cd /home/oem2/Documents/PROGRAMMING/Github_analysis_PROJECTS/Case_Studies/git2/Case_Studies/2_case_study_exercise


clear

# /home/oem2/Documents/PROGRAMMING/Github_analysis_PROJECTS/Case_Studies/git2/Case_Studies/1_case_study_bikeshare
export cur_path=$(pwd)

cd /home/oem2/Documents/PROGRAMMING/Github_analysis_PROJECTS/GCP_ingestion_analysis_tools/git2/GCP_ingestion_analysis_tools

source ./GCP_bigquery_case_study_library.sh
source ./GCP_bigquery_statistic_library.sh
source ./GCP_common_header.sh

cd $cur_path




# ---------------------------
# Functions START
# ---------------------------


join_multiple_tables(){
	
    # Inputs:
    # $1 = location
    # $2 = PROJECT_ID
    # $3 = dataset_name
    
	# dailyActivity_merged.csv T0
	# [Id, ActivityDate, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories]
	
	# minuteCaloriesWide_merged.csv T1
#Id,ActivityHour,Calories00,Calories01, Calories02, Calories03, Calories04, Calories05, Calories06, Calories07, Calories08, Calories09, Calories10, Calories11, Calories12, Calories13, Calories14, Calories15, Calories16, Calories17, Calories18, Calories19, Calories20, Calories21, Calories22, Calories23, Calories24, Calories25, Calories26, Calories27, Calories28, Calories29, Calories30, Calories31, Calories32, Calories33, Calories34, Calories35, Calories36, Calories37, Calories38, Calories39,Calories40, Calories41, Calories42, Calories43, Calories44, Calories45, Calories46, Calories47, Calories48, Calories49, Calories50, Calories51, Calories52, Calories53, Calories54, Calories55, alories56, Calories57, Calories58, Calories59]
     
	# dailyCalories_merged.csv T2
	# [Id, ActivityDay, Calories]
	
	# minuteIntensitiesNarrow_merged.csv T3
	# [Id, ActivityMinute, Intensity
	
	# dailyIntensities_merged.csv T4
	# [Id, ActivityDay, SedentaryMinutes, LightlyActiveMinutes, FairlyActiveMinutes, VeryActiveMinutes, SedentaryActiveDistance, LightActiveDistance, ModeratelyActiveDistance, VeryActiveDistance]

	# minuteIntensitiesWide_merged.csv T5
	# Id, ActivityHour, Intensity00, Intensity01, Intensity02, Intensity03, Intensity04, Intensity05, Intensity06, Intensity07,Intensity08,Intensity09,Intensity10,Intensity11,Intensity12,Intensity13,Intensity14,Intensity15,Intensity16,Intensity17,Intensity18,Intensity19,Intensity20,Intensity21,Intensity22,Intensity23,Intensity24,Intensity25,Intensity26,Intensity27,Intensity28,Intensity29,Intensity30,Intensity31,Intensity32,Intensity33,Intensity34,Intensity35,Intensity36,Intensity37,Intensity38,Intensity39,Intensity40,Intensity41,Intensity42,Intensity43,Intensity44,Intensity45,Intensity46,Intensity47,Intensity48,Intensity49,Intensity50,Intensity51,Intensity52,Intensity53,Intensity54,Intensity55,Intensity56,Intensity57,Intensity58,Intensity59

	# dailySteps_merged.csv T6
	# Id, ActivityDay, StepTotal
	
	# minuteMETsNarrow_merged.csv T7
	# [Id, ActivityMinute, METs]
	
	# heartrate_seconds_merged.csv T8
	# [Id, Time, Value]
	
	# *** Failed to join with dailyActivity_merged
	# minuteSleep_merged.csv T9
	# [Id, date, value, logId]
	
	# hourlyCalories_merged.csv T10
	# [Id, ActivityHour, Calories]
	
	# minuteStepsNarrow_merged.csv T11
	# [Id, ActivityMinutes, Steps]
	
	# hourlyIntensities_merged.csv T12
	# [Id, ActivityHour, TotalIntensity, AverageIntensity]
	
	# minuteStepsWide_merged.csv T13
	# [Id, ActivityHour, Steps00 to Steps59]
	
	# hourlySteps_merged.csv T14
	# Id, ActivityHour, StepTotal]
	
	# *** Failed to join with dailyActivity_merged
	# sleepDay_merged.csv T15
	# Id, SleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed]
	
	# minuteCaloriesNarrow_merged.csv T16 
	# Id, ActivityMinute, Calories]
	
	# weightLogInfo_merged.csv T17
	# [Id, Date, WeightKg, WeightPounds, Fat, BMI, IsManualReport, LogId]
	
	# export x=$(echo "weightLogInfo_merged")
	# VIEW_the_columns_of_a_table $location $PROJECT_ID $dataset_name $x
     
	# T1.ActivityHour AS hour_calories,
	# T2.ActivityDay AS day_calories,
        # T3.ActivityMinute min_intensity, 
        # T3.Intensity,
        # T7.METs,
        
     #INNER JOIN `'$2'.'$3'.minuteCaloriesWide_merged` AS T1 ON T0.Id = T1.Id
     #INNER JOIN `'$2'.'$3'.dailyCalories_merged` AS T2 ON T0.Id = T2.Id
     #INNER JOIN `'$2'.'$3'.minuteIntensitiesNarrow_merged` AS T3 ON T0.Id = T3.Id
     #INNER JOIN `'$2'.'$3'.minuteMETsNarrow_merged` AS T7 ON T0.Id = T7.Id
     
     bq rm -t $2:$3.exercise_full
     
     export TABLE_name_join=$(echo "exercise_full")

     bq query \
            --location=$1 \
            --destination_table $2:$3.$TABLE_name_join \
            --allow_large_results \
            --use_legacy_sql=false \
            'SELECT 
            T0.ActivityDate, 
            T0.TotalSteps, 
            T0.TotalDistance, 
            T0.VeryActiveDistance,
            T0.ModeratelyActiveDistance, 
            T0.LightActiveDistance, 
            T0.SedentaryActiveDistance, 
            T0.VeryActiveMinutes,
            T0.FairlyActiveMinutes,
            T0.LightlyActiveMinutes,
            T0.SedentaryMinutes,
            T0.Calories,
            T8.Value AS heartrate_time,
            T8.Value AS heartrate,
            T15.TotalTimeInBed AS sleep_duration, 
            T17.WeightKg,
            T17.WeightPounds,
            T17.Fat,
            T17.BMI
            FROM `'$2'.'$3'.dailyActivity_merged` AS T0
	 JOIN `'$2'.'$3'.heartrate_seconds_merged` AS T8 ON T0.Id = T8.Id
	 JOIN `'$2'.'$3'.sleepDay_merged` AS T15 ON T0.Id = T15.Id
	 JOIN `'$2'.'$3'.weightLogInfo_merged` AS T17 ON T0.Id = T17.Id;'   

}

# When you create a query by using a JOIN, consider the order in which you are merging the data. The GoogleSQL query optimizer can determine which table should be on which side of the join, but it is still recommended to order your joined tables appropriately. As a best practice, place the table with the largest number of rows first, followed by the table with the fewest rows, and then place the remaining tables by decreasing size.

# When you have a large table as the left side of the JOIN and a small one on the right side of the JOIN, a broadcast join is created. A broadcast join sends all the data in the smaller table to each slot that processes the larger table. It is advisable to perform the broadcast join first.


# ---------------------------

# WORKED
join_2_tables(){
	
    # Inputs:
    # $1 = location
    # $2 = PROJECT_ID
    # $3 = dataset_name
    # $4 = OUTPUT_TABLE_name

     bq query \
            --location=$1 \
            --destination_table $2:$3.$4 \
            --allow_large_results \
            --use_legacy_sql=false \
            'SELECT 
            T0.Id,
            T0.ActivityDate, 
            T0.TotalSteps, 
            T0.TotalDistance, 
            T0.VeryActiveDistance,
            T0.ModeratelyActiveDistance, 
            T0.LightActiveDistance, 
            T0.SedentaryActiveDistance, 
            T0.VeryActiveMinutes,
            T0.FairlyActiveMinutes,
            T0.LightlyActiveMinutes,
            T0.SedentaryMinutes,
            T0.Calories,
            T8.Value AS heartrate_time,
            T8.Value AS heartrate,
            T15.TotalTimeInBed AS sleep_duration
            FROM `'$2'.'$3'.dailyActivity_merged` AS T0
INNER JOIN `'$2'.'$3'.heartrate_seconds_merged` AS T8 ON T0.Id = T8.Id;'   

}
    


# ---------------------------


# ---------------------------




    
# ---------------------------
    



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
# Download data from datasource
# ---------------------------------------------
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	export path_outside_of_ingestion_folder=$(echo "/home/oem2/Documents/PROGRAMMING/Github_analysis_PROJECTS/Case_Studies/git2/Case_Studies/2_case_study_exercise")
	export NAME_OF_DATASET=$(echo "arashnic/fitbit")
	
	download_data_Kaggle $path_outside_of_ingestion_folder $NAME_OF_DATASET
fi

# OUTPUT : Creates a folder called downloaded_files




# ---------------------------------------------
# Organize zip files
# ---------------------------------------------
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	export path_folder_2_organize=$(echo "/home/oem2/Documents/PROGRAMMING/Github_analysis_PROJECTS/Case_Studies/git2/Case_Studies/2_case_study_exercise")

	export ingestion_folder=$(echo "ingestion_folder_exercise")

	export path_outside_of_ingestion_folder=$(echo "/home/oem2/Documents/ONLINE_CLASSES/Spécialisation_Google_Data_Analytics/3_Google_Data_Analytics_Capstone_Complete_a_Case_Study")

	organize_zip_files_from_datasource_download $path_folder_2_organize $ingestion_folder $path_outside_of_ingestion_folder

fi



# ---------------------------------------------
# Upload csv files from the PC to GCP
# ---------------------------------------------
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	# ******* CHANGE *******
	export cur_path=$(echo "/home/oem2/Documents/ONLINE_CLASSES/Spécialisation_Google_Data_Analytics/3_Google_Data_Analytics_Capstone_Complete_a_Case_Study/ingestion_folder_exercise/csvdata")
	# ******* CHANGE *******

	echo "cur_path"
	echo $cur_path
	    
	upload_csv_files $location $cur_path $dataset_name

fi




# -------------------------
# Get table info
# -------------------------


export TABLE_name=$(echo "exercise_full")

export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	bq query \
		    --location=$location \
		    --allow_large_results \
		    --use_legacy_sql=false \
	    'SELECT COUNT(*)
	     FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`;'



	VIEW_the_columns_of_a_table $location $PROJECT_ID $dataset_name $TABLE_name
fi



# -------------------------
# Join the TABLES : logic of joining large tables
# -------------------------


export OUTPUT_TABLE_name=$(echo "exercise_2tables_full")

export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	join_2_tables $location $PROJECT_ID $dataset_name $OUTPUT_TABLE_name
	
fi






# -------------------------
# Initially Clean the TABLE :  Identify the main features for the analysis
# -------------------------

export OUTPUT_TABLE_name=$(echo "exercise_full_clean0") 
	
bq rm -t $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name

export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	
	
	# Partition the table by Id, ActivityDate
	# Id     | ActivityDate | TotalSteps |  TotalDistance   | VeryActiveDistance | ModeratelyActiveDistance | LightActiveDistance | SedentaryActiveDistance | VeryActiveMinutes | FairlyActiveMinutes | LightlyActiveMinutes | SedentaryMinutes | Calories | heartrate_time | heartrate 
     bq query \
            --location=$location \
            --destination_table $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name \
            --allow_large_results \
            --use_legacy_sql=false \
    'SELECT Id, 
    ActivityDate,
    AVG(TotalSteps) AS mean_steps, 
    AVG(TotalDistance) AS mean_total_distance,
    AVG(VeryActiveDistance) AS mean_active_distance,
    AVG(ModeratelyActiveDistance) AS mean_moderateactive_distance,
    AVG(LightActiveDistance) AS mean_lightactive_distance,
    AVG(SedentaryActiveDistance) AS mean_sedentary_distance,
    AVG(FairlyActiveMinutes) AS mean_fairlyactive_distance,
    AVG(LightlyActiveMinutes) AS mean_light_distance,
    AVG(Calories) AS mean_calories,
    AVG(heartrate) AS mean_hr
    FROM `'$PROJECT_ID'.'$dataset_name'.exercise_2tables_full` 
GROUP BY Id, ActivityDate
ORDER BY Id, ActivityDate;'

fi



# -------------------------
# Join the TABLES : 
# -------------------------
export OUTPUT_TABLE_name=$(echo "exercise_2tables_full2")

bq rm -t $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name

export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	bq query \
            --location=$location \
            --destination_table $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name \
            --allow_large_results \
            --use_legacy_sql=false \
            'SELECT 
            T0.Id,
            T0.ActivityDate, 
            T0.mean_steps, 
            T0.mean_total_distance,
            T0.mean_active_distance,
            T0.mean_moderateactive_distance,
            T0.mean_lightactive_distance,
            T0.mean_sedentary_distance,
            T0.mean_fairlyactive_distance,
            T0.mean_light_distance,
            T0.mean_calories,
            T0.mean_hr,
            T15.TotalTimeInBed AS sleep_duration,
            FROM `'$PROJECT_ID'.'$dataset_name'.exercise_full_clean0` AS T0
FULL JOIN `'$PROJECT_ID'.'$dataset_name'.sleepDay_merged` AS T15 ON T0.Id = T15.Id;'   
	
fi


# -------------------------
# Clean the TABLE :  Identify the main features for the analysis
# -------------------------

export OUTPUT_TABLE_name=$(echo "exercise_full_clean1") 
	
bq rm -t $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name

export val=$(echo "X0")

if [[ $val == "X0" ]]
then 
	
     bq query \
            --location=$location \
            --destination_table $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name \
            --allow_large_results \
            --use_legacy_sql=false \
    'SELECT Id, 
    ActivityDate,
    AVG(mean_steps) AS mean_steps, 
    AVG(mean_total_distance) AS mean_total_distance,
    AVG(mean_active_distance) AS mean_active_distance,
    AVG(mean_moderateactive_distance) AS mean_moderateactive_distance,
    AVG(mean_lightactive_distance) AS mean_lightactive_distance,
    AVG(mean_sedentary_distance) AS mean_sedentary_distance,
    AVG(mean_fairlyactive_distance) AS mean_fairlyactive_distance,
    AVG(mean_light_distance) AS mean_light_distance,
    AVG(mean_calories) AS mean_calories,
    AVG(mean_hr) AS mean_hr,
    COALESCE(AVG(sleep_duration),(SELECT AVG(sleep_duration) FROM `northern-eon-377721.google_analytics_exercise.exercise_2tables_full2`)) AS sleep_duration
    FROM `northern-eon-377721.google_analytics_exercise.exercise_2tables_full2`
    WHERE Id IS NOT NULL
GROUP BY Id, ActivityDate
ORDER BY Id, ActivityDate;'

fi







# ---------------------------------------------
# Statistical Analysis : Hypothesis Testing
# ---------------------------------------------

# TYPE A RESULTS : probability of a categorical event happening 

# Additive rule of probability: P(A or B) = P(A) + P(B) - P(A and B)
# ie: the probablity of a ([casual user being female] OR [casual user being male]) AND [casual user using an electric_bike]
# (Reponse)  (0.004766284784788248 + 0.007837291891818123) * 0.08795399798808465

# Multiplicative rule of probability: P(A and B) = P(A) * P(B)
# ie: the probablity of a [casual user being female] AND [casual user using an electric_bike]
# (Reponse)  0.004766284784788248 * 0.08795399798808465


# Statistical significance of probablistic count for CATEGORICAL features
# *** NOT AUTOMATED, but written out *** 
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
    
    export TABLE_name=$(echo "exercise_full_clean1")
    
    export TABLE_name_probcount=$(echo "bikeshare_full_clean1_CATprobcount")

    # Calculation of percentage/probability of occurence across all samples
    bq query \
            --location=$location \
            --destination_table $PROJECT_ID:$dataset_name.$TABLE_name_probcount \
            --allow_large_results \
            --use_legacy_sql=false \
    'SELECT ROW_NUMBER() OVER(ORDER BY member_casual) AS row_num,
    member_casual, 
    rideable_type, 
    gender, 
    COUNT(*)/(SELECT COUNT(*) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`) AS prob_perc
     FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`
     GROUP BY member_casual, rideable_type, gender
     ORDER BY member_casual, rideable_type, gender;'


    # Is the probability occurence (percentage) per group across all samples statistically significant?
    # Could improve this and add the p-value function as a new column
    export prob_perc=$(echo "prob_perc")  # name of numerical column to find z-statistic values per row
    ONE_SAMPLE_TESTS_zstatistic_per_row $location $prob_perc $PROJECT_ID $dataset_name $TABLE_name_probcount
  
    
fi



# ---------------------------------------------


# Statistical significance of probablistic count for NUMERICAL features per BIN_NUMBER
# *** NOT AUTOMATED, but written out *** 
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	export TABLE_name=$(echo "bikeshare_full_clean1")
	export TABLE_name_probcount=$(echo "TABLE_name_probcount")

	# Calculation of percentage/probability of occurence of a numerical feature (workout_minutes) for a bin_number [ie: days (weekday=5, weekend=2)] across all samples
    bq query \
            --location=$location \
            --destination_table $PROJECT_ID:$dataset_name.$TABLE_name_probcount \
            --allow_large_results \
            --use_legacy_sql=false \
    'WITH tab2 AS
(
  SELECT *, 
  (SELECT SUM(workout_minutes)/bin_number FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE wday ="weekend") AS pop_weekend 
  FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`)
)
SELECT lifestyle, wday, (SUM(workout_minutes)/bin_number)/AVG(pop_weekend) AS prob_perc 
FROM tab2
GROUP BY lifestyle, wday
ORDER BY wday, lifestyle;'


    # Is the probability occurence (percentage) per group across all samples statistically significant?
    # Could improve this and add the p-value function as a new column
    export prob_perc=$(echo "prob_perc")  # name of numerical column to find z-statistic values per row
    ONE_SAMPLE_TESTS_zstatistic_per_row $location $prob_perc $PROJECT_ID $dataset_name $TABLE_name_probcount

fi






# ---------------------------------------------


# TYPE B RESULTS : statistial probability of numerical features being different for categorical events

# ---------------------------------------------
# Run NUMERICAL FEATURES ONE SAMPLE TESTS (AUTOMATED)
# ---------------------------------------------
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	export TABLE_name=$(echo "bikeshare_full_clean1")
	
	declare -a NUM_FEATS=('trip_distance' 'trip_time' 'birthyear_INT');
	
	# ********* CHANGE *********
	echo "Categorical feature:"
	export category_FEAT_name=$(echo "member_casual")
	echo $category_FEAT_name
	# ********* CHANGE *********
	
	for samp1_FEAT_name in "${NUM_FEATS[@]}"
	do	
		echo "Numerical feature:"
		echo $samp1_FEAT_name
   		ONE_SAMPLE_TESTS_t_and_zstatistic_of_NUMfeat_perCategory $location $samp1_FEAT_name $PROJECT_ID $dataset_name $TABLE_name $category_FEAT_name
	done
	
fi
# ---------------------------------------------




# ---------------------------------------------
# Run CATEGORICAL FEATURES ONE SAMPLE TESTS (NOT AUTOMATED)
# ---------------------------------------------
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	export TABLE_name=$(echo "bikeshare_full_clean1")
	
	# ********* CHANGE *********
	echo "Categorical feature:"
	export category_FEAT_name=$(echo "member_casual")
	echo $category_FEAT_name
	
	echo "Transform categorical feature into a Numerical feature:"
	echo "gender"  # Need to copy paste into function
	ONE_SAMPLE_TESTS_t_and_zstatistic_of_CATfeat_perCategory $location $PROJECT_ID $dataset_name $TABLE_name $category_FEAT_name
	# ********* CHANGE *********
	
	# Confirm the numerical values with the categories
	bq query \
            --location=$location \
            --allow_large_results \
            --use_legacy_sql=false \
    'SELECT gender, transformed_FEAT, COUNT(*)
     FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`
     GROUP BY gender, transformed_FEAT;'
fi
# ---------------------------------------------





# ---------------------------------------------
# Run NUMERICAL FEATURES TWO SAMPLE TEST (AUTOMATED)
# ---------------------------------------------
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	export TABLE_name=$(echo "bikeshare_full_clean1")
	
	declare -a NUM_FEATS=('trip_distance' 'trip_time' 'birthyear_INT');
	
	# ********* CHANGE *********
	echo "Categorical feature:"
	export category_FEAT_name=$(echo "member_casual")
	export category_FEAT_name_VAR1=$(echo "'member'")
	export category_FEAT_name_VAR2=$(echo "'casual'")
	echo $category_FEAT_name" where variables are "$category_FEAT_name_VAR1" and "$category_FEAT_name_VAR2
	# ********* CHANGE *********
	
	for samp1_FEAT_name in "${NUM_FEATS[@]}"
	do	
		echo "Numerical feature:"
		echo $samp1_FEAT_name
   		TWO_SAMPLE_TESTS_zstatistic_perbinarycategory $location $samp1_FEAT_name $PROJECT_ID $dataset_name $TABLE_name $category_FEAT_name $category_FEAT_name_VAR1 $category_FEAT_name_VAR2
	done

fi
# ---------------------------------------------










# ---------------------------------------------





# ---------------------------------------------





# ---------------------------------------------





# ---------------------------------------------





# ---------------------------------------------



# ---------------------------------------------


export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
    
    echo "---------------- Query Delete Tables ----------------"
    
    export TABLE_name_join=$(echo "bikeshare_full")
    
    # bq rm -t $PROJECT_ID:$dataset_name.$TABLE_name_join
    bq rm -t $PROJECT_ID:$dataset_name.exercise_2tables_full
    # 
    # bq rm -t $PROJECT_ID:$dataset_name.twosample_table
    
fi


# ---------------------------------------------

