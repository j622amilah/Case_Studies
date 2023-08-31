#!/bin/bash


clear


export cur_path=$(pwd)

cd /home/oem2/Documents/PROGRAMMING

source ./GCP_bigquery_case_study_library.sh
source ./GCP_bigquery_statistic_library.sh

cd $cur_path
# cd /home/oem2/Documents/ONLINE_COURS/Specialization_Google_Business_Intelligence_Certificat_Professionnel/case_study_Google_fiber



# ---------------------------
# Functions START
# ---------------------------




# ---------------------------------------------



# ---------------------------------------------




# ---------------------------------------------




# ---------------------------------------------


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
fi

# ---------------------------------------------




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
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 

	# Set the project region/location
	export location=$(echo "europe-west9")  # Paris

	dotenv set location $location

else
    export location=$(dotenv get location)
fi 

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
    export PROJECT_ID=$(echo "")
    gcloud config set project $PROJECT_ID

    # List DATASETS in the current project
    # bq ls $PROJECT_ID:
    # OR
    # bq ls
    
    dotenv set PROJECT_ID $PROJECT_ID

else
    export PROJECT_ID=$(dotenv get PROJECT_ID)
fi

# ---------------------------------------------







# ---------------------------------------------
# SELECT dataset_name
# ---------------------------------------------
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
    # ---------------------------------------------
    # Create a new DATASET named PROJECT_ID
    # ---------------------------------------------
    export dataset_name=$(echo "")
    bq --location=$location mk $PROJECT_ID:$dataset_name
    
    dotenv set dataset_name $dataset_name

else

    # ---------------------------------------------
    # SELECT an existing dataset_name
    # ---------------------------------------------
    export dataset_name=$(dotenv get dataset_name)
    
    # Use existing dataset
    # export dataset_name=$(echo "")

    # ------------------------

    # List TABLES in the dataset
    # echo "bq ls $PROJECT_ID:$dataset_name"
    # bq --location=$location ls $PROJECT_ID:$dataset_name


    # echo "bq show $PROJECT_ID:$dataset_name"
    # bq --location=$location show $PROJECT_ID:$dataset_name

fi


# ---------------------------------------------















# ---------------------------------------------
# Download data from datasource
# ---------------------------------------------
export path_outside_of_ingestion_folder=$(echo "/home/oem2/Documents/ONLINE_COURS/Specialization_Google_Business_Intelligence_Certificat_Professionnel/case_study_Google_fiber")


export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	cd $path_outside_of_ingestion_folder
	
	export NAME_OF_DATASET=$(echo "datazng/telecom-company-churn-rate-call-center-data")
	
	kaggle datasets download -d $NAME_OF_DATASET
	
	sudo mkdir $path_outside_of_ingestion_folder/data_download
	
	sudo chmod 777 $path_outside_of_ingestion_folder/data_download
	
	sudo mv /home/oem2/*.zip $path_outside_of_ingestion_folder/data_download
	
fi








# ---------------------------------------------
# Organize zip files
# ---------------------------------------------
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	export path_folder_2_organize=$(echo $path_outside_of_ingestion_folder/data_download)

	export ingestion_folder=$(echo "ingestion_folder")

	organize_zip_files_from_datasource_download $path_folder_2_organize $ingestion_folder $path_outside_of_ingestion_folder
	
fi








# ---------------------------------------------
# Upload csv files from the PC to GCP
# ---------------------------------------------
export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	export path_folder_2_upload2GCP=$(echo $path_outside_of_ingestion_folder/ingestion_folder/csvdata)
	    
	upload_csv_files $location $path_folder_2_upload2GCP $dataset_name

fi






# -------------------------
# Get table info
# -------------------------
export TABLE_name=$(echo "Telecom_Churn_Rate_Dataset")
dotenv set TABLE_name $TABLE_name


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
# +------------------+-----------+
# |   column_name    | data_type |
# +------------------+-----------+
# | customerID       | STRING    |
# | gender           | STRING    |  M, F
# | SeniorCitizen    | INT64     |
# | Partner          | BOOL      |
# | Dependents       | BOOL      |
# | tenure           | INT64     |
# | PhoneService     | BOOL      |
# | MultipleLines    | STRING    |
# | InternetService  | STRING    | No, DSL, Fiber optic
# | OnlineSecurity   | STRING    |
# | OnlineBackup     | STRING    |
# | DeviceProtection | STRING    |
# | TechSupport      | STRING    | No internet service, Yes, No
# | StreamingTV      | STRING    |
# | StreamingMovies  | STRING    |
# | Contract         | STRING    | One year, Two year, Month-to-month
# | PaperlessBilling | BOOL      |
# | PaymentMethod    | STRING    |
# | MonthlyCharges   | FLOAT64   |
# | TotalCharges     | STRING    |
# | numAdminTickets  | INT64     |
# | numTechTickets   | INT64     |
# | Churn            | BOOL      |
# +------------------+-----------+
	
fi

# ---------------------------------------------






# -------------------------
# Initially Clean the TABLE :  Need to create a column for repeated contact
# 
# Combine columns numAdminTickets and numTechTickets to indicate number_of_times_contacted
# 
# Everytime a ticket is created it means that a customer contacted/called.
# 
# Metric
# Repeat calls = how often customers call customer support two times or more
# 
# https://www.kaggle.com/datasets/datazng/telecom-company-churn-rate-call-center-data
# Fictional call center dataset needs to include:
#     Number of calls
#     Number of repeat calls after first contact
#     Call type
#     Market city
#     Date

# Churn rate, sometimes known as attrition rate, is the rate at which customers stop doing business with a company over a given period of time. Churn may also apply to the number of subscribers who cancel or don't renew a subscription. The higher your churn rate, the more customers stop buying from your business.


# Goal : communicate with the customers to reduce the call volume and increase customer satisfaction and improve operational optimization. 
# -------------------------
export OUTPUT_TABLE_name=$(echo "repeat_call0") 
	

export val=$(echo "X1")

if [[ $val == "X0" ]]
then

     bq rm -t $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name

     bq query \
            --location=$location \
            --destination_table $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name \
            --allow_large_results \
            --use_legacy_sql=false \
    'WITH tabtemp AS (
    SELECT customerID,
    gender,
    InternetService AS market_city, 
    Contract,
    TechSupport,
    CAST(Churn AS INT64) AS Churn_INT,
    numAdminTickets+numTechTickets AS total_problem_type,
    numAdminTickets AS account_mang_problem_type,
    numTechTickets AS tech_troubleshoot_problem_type,
    CASE WHEN Contract = "One year" THEN 12 WHEN Contract = "Two year" THEN 24 WHEN Contract = "Month-to-month" THEN 1 END AS duration
    FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`
    )
    SELECT *, 
    total_problem_type/duration AS total_problem_type_call_freq,
    account_mang_problem_type/duration AS accmang_problem_type_call_freq,
    tech_troubleshoot_problem_type/duration AS techtrob_problem_type_call_freq
    FROM tabtemp;'




fi

# RESULT : create the desired dataset measuring repeated contact for an Internet service company
# OUTPUT TABLE NAME: repeat_call0

# ---------------------------------------------






# -------------------------
# Get table info
# -------------------------
export OUTPUT_TABLE_name=$(echo "repeat_call1") 

export val=$(echo "X1")

if [[ $val == "X0" ]]
then

     bq rm -t $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name

     bq query \
            --location=$location \
            --destination_table $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name \
            --allow_large_results \
            --use_legacy_sql=false \
    'SELECT market_city, 
    Contract, 
    TechSupport, 
    SUM(total_problem_type) AS tot_probtype, 
    SUM(account_mang_problem_type) AS acc_mang_probtype, 
    SUM(tech_troubleshoot_problem_type) AS techtrob_probtype, 
    IF(AVG(Churn_INT) > 0.5, True, False) as churn,
    AVG(total_problem_type_call_freq) AS tot_probtype_call_freq, 
    AVG(accmang_problem_type_call_freq) AS acc_mang_probtype_call_freq, 
    AVG(techtrob_problem_type_call_freq) AS techtrob_probtype_call_freq
    FROM `'$PROJECT_ID'.'$dataset_name'.repeat_call0` 
    GROUP BY market_city, Contract, TechSupport
ORDER BY acc_mang_probtype DESC, techtrob_probtype DESC;'


fi


# ---------------------------------------------

# So Fiber optic InternetService customers contact more than 2 times on average. Women with one year contracts contact the most.

# +-------------+----------------+---------------------+--------------------+---------------------+----------------------+-------+------------------------+-----------------------------+-----------------------------+
# | market_city |    Contract    |     TechSupport     |    tot_probtype    |  acc_mang_probtype  |  techtrob_probtype   | churn | tot_probtype_call_freq | acc_mang_probtype_call_freq | techtrob_probtype_call_freq |
# +-------------+----------------+---------------------+--------------------+---------------------+----------------------+-------+------------------------+-----------------------------+-----------------------------+
# | Fiber optic | Two year       | No                  | 1.4462809917355375 |  0.6942148760330579 |   0.7520661157024796 | false |   0.060261707988980714 |        0.028925619834710745 |         0.03133608815426997 |
# | DSL         | Month-to-month | Yes                 |  0.808259587020649 |  0.6165191740412974 |  0.19174041297935113 | false |      0.808259587020649 |          0.6165191740412974 |         0.19174041297935113 |
# | Fiber optic | Two year       | Yes                 |  1.305194805194805 |  0.5779220779220777 |   0.7272727272727277 | false |     0.0543831168831169 |         0.02408008658008658 |        0.030303030303030304 |
# | Fiber optic | One year       | Yes                 | 1.6769911504424775 |  0.5707964601769911 |    1.106194690265487 | false |    0.13974926253687311 |         0.04756637168141594 |         0.09218289085545726 |
# | No          | Month-to-month | No internet service | 0.5763358778625955 |  0.5515267175572519 | 0.024809160305343515 | false |     0.5763358778625955 |          0.5515267175572519 |        0.024809160305343515 |
# | Fiber optic | One year       | No                  | 1.5878594249201283 |  0.5335463258785943 |    1.054313099041534 | false |    0.13232161874334403 |        0.044462193823216214 |         0.08785942492012778 |
# | DSL         | One year       | Yes                 | 0.8619631901840492 |  0.5306748466257669 |   0.3312883435582823 | false |    0.07183026584867075 |         0.04422290388548057 |         0.02760736196319018 |
# | Fiber optic | Month-to-month | No                  | 1.1069042316258337 |  0.5228285077951008 |   0.5840757238307354 |  true |     1.1069042316258337 |          0.5228285077951008 |          0.5840757238307354 |
# | DSL         | Two year       | Yes                 |  0.791423001949318 |  0.5204678362573101 |   0.2709551656920079 | false |    0.03297595841455489 |        0.021686159844054583 |        0.011289798570500317 |
# | No          | Two year       | No internet service | 0.7586206896551726 |  0.5203761755485891 |  0.23824451410658307 | false |    0.03160919540229886 |          0.0216823406478579 |        0.009926854754440965 |
# | DSL         | One year       | No                  | 0.8770491803278687 | 0.49590163934426224 |   0.3811475409836066 | false |    0.07308743169398906 |         0.04132513661202186 |        0.031762295081967214 |
# | No          | One year       | No internet service | 0.5494505494505495 |  0.4697802197802197 |  0.07967032967032966 | false |    0.04578754578754579 |         0.03914835164835165 |        0.006639194139194141 |
# | DSL         | Two year       | No                  | 0.8347826086956519 |  0.4695652173913043 |   0.3652173913043479 | false |    0.03478260869565218 |        0.019565217391304342 |        0.015217391304347825 |
# | Fiber optic | Month-to-month | Yes                 | 1.1114457831325295 | 0.46686746987951805 |   0.6445783132530121 | false |     1.1114457831325295 |         0.46686746987951805 |          0.6445783132530121 |
# | DSL         | Month-to-month | No                  | 0.5882352941176471 | 0.41176470588235287 |   0.1764705882352941 | false |     0.5882352941176471 |         0.41176470588235287 |          0.1764705882352941 |
# +-------------+----------------+---------------------+--------------------+---------------------+----------------------+-------+------------------------+-----------------------------+-----------------------------+

# -------------------------
# Get table info
# -------------------------
export OUTPUT_TABLE_name=$(echo "repeat_call2") 

export val=$(echo "X1")

if [[ $val == "X0" ]]
then

     bq rm -t $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name

     bq query \
            --location=$location \
            --destination_table $PROJECT_ID:$dataset_name.$OUTPUT_TABLE_name \
            --allow_large_results \
            --use_legacy_sql=false \
    'SELECT market_city, 
    Contract, 
    TechSupport, 
    SUM(total_problem_type) AS tot_probtype, 
    SUM(account_mang_problem_type) AS acc_mang_probtype, 
    SUM(tech_troubleshoot_problem_type) AS techtrob_probtype, 
    IF(AVG(Churn_INT) > 0.5, True, False) as churn,
    AVG(total_problem_type_call_freq) AS tot_probtype_call_freq, 
    AVG(accmang_problem_type_call_freq) AS acc_mang_probtype_call_freq, 
    AVG(techtrob_problem_type_call_freq) AS techtrob_probtype_call_freq
    FROM `'$PROJECT_ID'.'$dataset_name'.repeat_call0` 
    GROUP BY market_city, Contract, TechSupport
ORDER BY techtrob_probtype DESC, acc_mang_probtype DESC;'


fi

# ---------------------------------------------

# +-------------+----------------+---------------------+--------------------+---------------------+----------------------+-------+------------------------+-----------------------------+-----------------------------+
# | market_city |    Contract    |     TechSupport     |    tot_probtype    |  acc_mang_probtype  |  techtrob_probtype   | churn | tot_probtype_call_freq | acc_mang_probtype_call_freq | techtrob_probtype_call_freq |
# +-------------+----------------+---------------------+--------------------+---------------------+----------------------+-------+------------------------+-----------------------------+-----------------------------+
# | Fiber optic | One year       | Yes                 | 1.6769911504424775 |  0.5707964601769911 |    1.106194690265487 | false |    0.13974926253687311 |         0.04756637168141594 |         0.09218289085545726 |
# | Fiber optic | One year       | No                  | 1.5878594249201283 |  0.5335463258785943 |    1.054313099041534 | false |    0.13232161874334403 |        0.044462193823216214 |         0.08785942492012778 |
# | Fiber optic | Two year       | No                  | 1.4462809917355375 |  0.6942148760330579 |   0.7520661157024796 | false |   0.060261707988980714 |        0.028925619834710745 |         0.03133608815426997 |
# | Fiber optic | Two year       | Yes                 |  1.305194805194805 |  0.5779220779220777 |   0.7272727272727277 | false |     0.0543831168831169 |         0.02408008658008658 |        0.030303030303030304 |
# | Fiber optic | Month-to-month | Yes                 | 1.1114457831325295 | 0.46686746987951805 |   0.6445783132530121 | false |     1.1114457831325295 |         0.46686746987951805 |          0.6445783132530121 |
# | Fiber optic | Month-to-month | No                  | 1.1069042316258337 |  0.5228285077951008 |   0.5840757238307354 |  true |     1.1069042316258337 |          0.5228285077951008 |          0.5840757238307354 |
# | DSL         | One year       | No                  | 0.8770491803278687 | 0.49590163934426224 |   0.3811475409836066 | false |    0.07308743169398906 |         0.04132513661202186 |        0.031762295081967214 |
# | DSL         | Two year       | No                  | 0.8347826086956519 |  0.4695652173913043 |   0.3652173913043479 | false |    0.03478260869565218 |        0.019565217391304342 |        0.015217391304347825 |
# | DSL         | One year       | Yes                 | 0.8619631901840492 |  0.5306748466257669 |   0.3312883435582823 | false |    0.07183026584867075 |         0.04422290388548057 |         0.02760736196319018 |
# | DSL         | Two year       | Yes                 |  0.791423001949318 |  0.5204678362573101 |   0.2709551656920079 | false |    0.03297595841455489 |        0.021686159844054583 |        0.011289798570500317 |
# | No          | Two year       | No internet service | 0.7586206896551726 |  0.5203761755485891 |  0.23824451410658307 | false |    0.03160919540229886 |          0.0216823406478579 |        0.009926854754440965 |
# | DSL         | Month-to-month | Yes                 |  0.808259587020649 |  0.6165191740412974 |  0.19174041297935113 | false |      0.808259587020649 |          0.6165191740412974 |         0.19174041297935113 |
# | DSL         | Month-to-month | No                  | 0.5882352941176471 | 0.41176470588235287 |   0.1764705882352941 | false |     0.5882352941176471 |         0.41176470588235287 |          0.1764705882352941 |
# | No          | One year       | No internet service | 0.5494505494505495 |  0.4697802197802197 |  0.07967032967032966 | false |    0.04578754578754579 |         0.03914835164835165 |        0.006639194139194141 |
# | No          | Month-to-month | No internet service | 0.5763358778625955 |  0.5515267175572519 | 0.024809160305343515 | false |     0.5763358778625955 |          0.5515267175572519 |        0.024809160305343515 |
# +-------------+----------------+---------------------+--------------------+---------------------+----------------------+-------+------------------------+-----------------------------+-----------------------------+



# -------------------------
# Display results online: Looker
# https://cloud.google.com/bigquery/docs/looker
# -------------------------
export OUTPUT_TABLE_name=$(echo "repeat_call1") 

export val=$(echo "X1")

if [[ $val == "X0" ]]
then
	# Steps to use Looker with a BigQuery Table
	# Guide (lacks detail for people who do this automatically) : https://cloud.google.com/bigquery/docs/looker
	
	# [Step 0] Enable the bigqueryreservation API
	gcloud services disable bigqueryreservation.googleapis.com 
	
	# -------------------------
	
	# [Step 1] Create a BI Engine reservation
	
	# Using the Console
	# Go to Administration - BI Engine
	# https://console.cloud.google.com/bigquery/admin/bi-engine?_ga=2.218833948.400957854.1693219290-587379685.1693212236
	
	# + Create reservation - Location - GB of capacity=2 - NEXT - Preferred Tables=a number (ie: 311) - select table name - Next - confirm submit - Create - Go to Reservations page  
	
	# OR
	
	# -------------------------
	# Using CLI
	# https://cloud.google.com/bigquery/docs/reservations-tasks#bq
	# -------------------------
	
	# [Step 3] Give role permissions to use the bigqueryreservation
	# https://cloud.google.com/bigquery/docs/access-control
	export SERVICE_ACCOUNT_ID=$(echo "looker-practice") # just make it up
	export SERVICE_ACCOUNT_EMAIL=$(echo "")
	export SERVICE_ACCOUNT=$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com

	# [0] Create a custom service account (ONLY HAVE TO DO ONCE)
	gcloud iam service-accounts create $SERVICE_ACCOUNT_ID --description="Creating a service account for a looker bigquery exchange" --display-name="Looker practice"
    
    	# ---------------------------------------------
	
	# [1] Then, grant access to the existing service account
	
    	# roles/bigquery.admin - serviceaccount
	gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT --role="roles/bigquery.admin"
	
	# roles/bigquery.resourceAdmin - serviceaccount
	gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT --role="roles/bigquery.resourceAdmin"
	
	# roles/bigquery.resourceEditor - serviceaccount
	gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT --role="roles/bigquery.resourceEditor"
	
	# ---------------------------------------------

fi





export val=$(echo "X1")

if [[ $val == "X0" ]]
then	
	# [Step 4] Create a BI Engine reservation
	# Best source: https://cloud.google.com/bigquery/docs/reservations-assignments
	# The BigQuery Reservation API enables you to purchase dedicated slots (called commitments), create pools of slots (called reservations), and assign projects and organizations to those reservations.
	
	# https://cloud.google.com/bigquery/docs/reservations-workload-management#admin-project
	
	# When you create commitments and reservations, they are associated with a Google Cloud project. This project manages the BigQuery Reservations resources, and is the primary source of billing for these resources. This project does not have to be the same project that holds your BigQuery jobs. Google recommends creating a dedicated project for Reservations resources. This project is called the administration project, because it centralizes the billing and management of your commitments. Give this project a descriptive name like bq-COMPANY_NAME-admin. Then create one or more separate projects to hold your BigQuery job
	export ADMIN_PROJECT_ID=$(echo $PROJECT_ID)
	
	export NUMBER_OF_SLOTS=$(echo "100")
	
	# https://cloud.google.com/bigquery/docs/editions-intro
	export EDITION=$(echo "STANDARD")  # BigQuery provides three editions (Standard, Enterprise, and Enterprise Plus)
	# value should be one of <STANDARD|ENTERPRISE|ENTERPRISE_PLUS>
	# BigQuery editions allow you to pick the right feature set for individual workload requirements. For example, the Standard Edition is best for ad-hoc, development, and test workloads, while Enterprise has increased security, governance, machine learning and data management features.
	
	export NUMBER_OF_AUTOSCALING_SLOTS=$(echo "100") # must be a multiple of 100
	export RESERVATION_NAME=$(echo "repeat-call-reservation") # It can only contain lower case alphanumeric characters or dashes. It must start with a letter and must not end with a dash.
	
	# Create a reservation
	
	# Included all the settings
	# bq mk --project_id=$ADMIN_PROJECT_ID --location=$location --reservation --ignore_idle_slots=false --edition=$EDITION --slots=500 --autoscale_max_slots=1000 $RESERVATION_NAME
	# {'error': {'code': 400, 'message': 'STANDARD Reservation can not have baseline slot capacity.', 'status': 'INVALID_ARGUMENT'}}
	
	# Removed autoscale_max_slots
	# bq mk --project_id=$ADMIN_PROJECT_ID --location=$location --reservation --ignore_idle_slots=false --edition=$EDITION --slots=$NUMBER_OF_SLOTS $RESERVATION_NAME
	# {'error': {'code': 400, 'message': 'STANDARD Reservation can not have baseline slot capacity.', 'status': 'INVALID_ARGUMENT'}}
	
	# Changed ignore_idle_slots to true
	# bq mk --project_id=$ADMIN_PROJECT_ID --location=$location --reservation --ignore_idle_slots=true --edition=$EDITION --slots=$NUMBER_OF_SLOTS --autoscale_max_slots=$NUMBER_OF_AUTOSCALING_SLOTS $RESERVATION_NAME
	# {'error': {'code': 400, 'message': 'STANDARD Reservation can not have baseline slot capacity.', 'status': 'INVALID_ARGUMENT'}}
	
	# Kept ignore_idle_slots at true and removed [slots, autoscale_max_slots]
	# bq mk --project_id=$ADMIN_PROJECT_ID --location=$location --reservation --ignore_idle_slots=true --edition=$EDITION $RESERVATION_NAME
	# {'error': {'code': 400, 'message': 'Reservation slot capacity and autoscale max slots are both 0. This is only allowed if ignore_idle_slots is false.', 'status': 'INVALID_ARGUMENT'}}
	
	# bq mk --project_id=$ADMIN_PROJECT_ID --location=$location --reservation --ignore_idle_slots=false --edition=$EDITION $RESERVATION_NAME
	# {'error': {'code': 400, 'message': 'STANDARD Reservation can not share idle slots, please set ignore_idle_slots to true.', 'status': 'INVALID_ARGUMENT'}}
	
	# bq mk --project_id=$ADMIN_PROJECT_ID --location=$location --reservation --ignore_idle_slots=true --edition=$EDITION --slots=2 $RESERVATION_NAME
	# {'error': {'code': 400, 'message': 'STANDARD Reservation can not have baseline slot capacity.', 'status': 'INVALID_ARGUMENT'}}
	
	# As long as ignore_idle_slots is false, a reservation can have a slot count of 0 and still have access to unused slots. 
	# bq mk --project_id=$ADMIN_PROJECT_ID --location=$location --reservation --ignore_idle_slots=false --edition=$EDITION $RESERVATION_NAME
	
	# bq mk --project_id=$ADMIN_PROJECT_ID --location=$location --reservation --ignore_idle_slots=false --edition=$EDITION $RESERVATION_NAME
	
	# -------------------------
	
	# Baseline — to guarantee capacity, you set a baseline. This is the number of guaranteed slots in your reservation. 
# 	bq query --location=$location \
 #            --allow_large_results \
 #            --use_legacy_sql=false \
 #    'CREATE RESERVATION
 #  `'$ADMIN_PROJECT_ID'.region-'$location'.'$RESERVATION_NAME'`
# OPTIONS (
 #  slot_capacity = '$NUMBER_OF_SLOTS',
 #  edition = '$EDITION',
#   autoscale_max_slots = '$NUMBER_OF_AUTOSCALING_SLOTS');'

	# BigQuery error in query operation: STANDARD Reservation can not have baseline slot capacity.
	
	# The maximum number of slots available to the reservation is equal to the baseline slots (1000) plus any committed idle slots not dedicated to the baseline slots
	
	# -------------------------
	
# 	bq query --location=$location \
#             --allow_large_results \
#             --use_legacy_sql=false \
#     'CREATE RESERVATION
#   `'$ADMIN_PROJECT_ID'.region-'$location'.'$RESERVATION_NAME'`
# OPTIONS (
# ignore_idle_slots = true,
# slot_capacity = '$NUMBER_OF_SLOTS',
#   edition = '$EDITION',
#   autoscale_max_slots = '$NUMBER_OF_AUTOSCALING_SLOTS');'
  	
  	# Exists: An active reservation repeat-call-reservation already exists
	
	# This only worked when edition=ENTERPRISE, it gave an error everytime I kept edition=STANDARD
	
	# -------------------------
	
	# Result : using edition=STANDARD does not allow you to make a reservation because the compute model uses autoscaling (and not autoscaling + baseline). You can either set: 0) ignore_idle_slots=false and do not set slot_capacity and autoscale_max_slots, OR 1) ignore_idle_slots=true and set slot_capacity and autoscale_max_slots. 
	
	# For 0) it takes the needed reservations from the idle pool to do the work, and for 1) you assign the amount of slot/resources to use to do the work. 
	
	# In summary : 
	# [a] When you do 0) [ignore_idle_slots=false, do not set slots] it says "STANDARD Reservation can not share idle slots" and tells you to set ignore_idle_slots=true. On a page it says 'As long as ignore_idle_slots is false, a reservation can have a slot count of 0 and still have access to unused slots.' 
	# [b] Then when you do 1) [ignore_idle_slots=true, set slots] it says "STANDARD Reservation can not have baseline slot capacity". 
	# [c] If you do 1) and do not set slots, it says "Reservation slot capacity and autoscale max slots are both 0. This is only allowed if ignore_idle_slots is false."...but we all know that that was the first thing we tried in 0) and it did not work.
	
	# I becomes circular and nothing works.
	
	
	# List the idle slot configuration 
	
	
	
	# Find a project's reservation assignment ID : find out if your project, folder, or organization is assigned to a reservation (you need the assignment_id to delete the reservation)
	# JOB_TYPE: value should be one of <QUERY|PIPELINE|ML_EXTERNAL|BACKGROUND|SPARK>
	export JOB_TYPE=$(echo "None")
	bq show --project_id=$ADMIN_PROJECT_ID --location=$location --reservation_assignment --job_type=BACKGROUND --assignee_id=$PROJECT_ID --assignee_type=PROJECT
	# OR
	bq show --project_id=$ADMIN_PROJECT_ID --location=$location --reservation_assignment --assignee_id=$PROJECT_ID --assignee_type=PROJECT
	
	# OR
	bq query --location=$location \
            --allow_large_results \
            --use_legacy_sql=false \
    'SELECT
    assignment_id
  FROM `region-'$location'`.INFORMATION_SCHEMA.ASSIGNMENTS_BY_PROJECT
  WHERE
    assignee_id = '$ADMIN_PROJECT_ID'
    AND job_type = '$JOB_TYPE';'


	
	
	# Remove a project from a reservation : https://cloud.google.com/bigquery/docs/reservations-assignments
	bq rm --project_id=$ADMIN_PROJECT_ID --location=$location --reservation_assignment $RESERVATION_NAME.ASSIGNMENT_ID

	
	
	# -------------------------
	# Summary of ways to present the results online use a webapp/dashboard
	# -------------------------
	# If you already have a Looker model using a BigQuery dataset with a service account, in a project that is BI Engine-enabled, then no additional configuration is required. 
	
	# way 0: Looker

	# 0) Enable the bigqueryreservation API

	# 1) Create a BI Engine reservation (this is like a compute engine)
	# 	- Create a service account
	# 	- Give role permissions to use bigqueryreservation
	# 	- Create a reservation using bq command (NOT bq mk) - 2GB capacity 

	# 2) Create a connection between the BigQuery database and Looker
	# 	- Console: Go to Looker - Connections from the Database section - Admin panel - Connections - Add Connection -  Looker displays the Connection Settings page
		
	# 	- Automated way:
	# 		- https://developers.looker.com/api/explorer/3.1/methods/Connection/create_connection?sdk=py
	#		- https://developers.looker.com/api/explorer/4.0/methods/Project/deploy_to_production?sdk=py
	# 		- Way 0: make a program using the looker sdk (https://developers.looker.com/api)
	# 			- too complicated to create something fast
			
	# 	- There is a Github Actions method to run Looker and deploy BigQuery data to an html result  
	# 		- https://cloud.google.com/looker/docs/setting-up-git-connection?hl=en#configuring_a_bare_git_repository


	# 	- In the end, it only explains tutorials about sending Looker data to Google Scripts 
 	# 	- It requires a lot more time to understand how to use the looker sdk (I finally found information that there was an sdk, need to install it and set it up)
	# 	https://developers.looker.com/api/getting-started
		
	# -------------------------

	# Way 1 : LookML
	# LookML stands for Looker Modeling Language; it's the language that is used in Looker to create semantic data models. 


	# 	- Building LookML dashboards: https://cloud.google.com/looker/docs/building-lookml-dashboards?hl=en#lookml_dashboards_folder
	# 	- Building Visualizations : https://cloud.google.com/looker/docs/creating-visualizations?hl=en
	# 	https://cloud.google.com/looker/docs/building-lookml-dashboards?hl=en#adding_a_visualization_to_an_existing_lookml_dashboard
			
			
	# https://cloud.google.com/monitoring/api/ref_v3/rest/v1/projects.dashboards/create

	
	
	# Make a connection 
	# bq ls --connection --project_id=$PROJECT_ID --location=$location

	# -------------------------
	
	# Way 2 : Connected Google Sheets with Google Apps Script
	# https://cloud.google.com/bigquery/docs/connected-sheets?hl=en
 
	# Go to Google Sheets - new spreadsheet - Data - Data connectors - Select BigQuery database
	
	# -------------------------

fi

# ---------------------------------------------








# ---------------------------------------------




# -------------------------
# Way 3 to display results : Dashboard
# https://cloud.google.com/monitoring/api/ref_v3/rest/v1/projects.dashboards/create
# These dashboards are only for monitoring information usage on GCP, not for making a dashboard from an SQL database. 
# -------------------------
export OUTPUT_TABLE_name=$(echo "repeat_call1") 

export val=$(echo "X1")

if [[ $val == "X0" ]]
then
	gcloud services enable monitoring.googleapis.com 

	export SERVICE_ACCOUNT_ID=$(echo "dashboard-practice") # just make it up
	export SERVICE_ACCOUNT_EMAIL=$(echo "")
	export SERVICE_ACCOUNT=$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com  

	# [0] Create a custom service account (ONLY HAVE TO DO ONCE)
	gcloud iam service-accounts create $SERVICE_ACCOUNT_ID --description="Creating a service account for a dashboard" --display-name="dashboard practice"
    
    	# View all the roles: 
	# dataflow.worker - serviceaccount
	# monitoring.dashboards.create
	gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT --role="roles/monitoring.editor"
    
monitoring.dashboards.create

	curl 'https://monitoring.googleapis.com/v1/projects/google_business_intelligence/dashboards' \
		--header 'Authorization: Bearer KEY' \
		--header 'Accept: application/json' \
		--compressed

fi

# ---------------------------------------------









export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
    
    echo "---------------- Query Delete Tables ----------------"
    
    export TABLE_name=$(echo "")
    
    bq rm -t $PROJECT_ID:$dataset_name.$TABLE_name
    
fi


# ---------------------------------------------

