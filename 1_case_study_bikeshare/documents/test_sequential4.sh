#!/bin/bash


export project_id=$(echo "northern-eon-377721")
gcloud config set project $project_id

export dataset_name=$(echo "google_analytics")
bq mk $project_name:$dataset_name


    
    

export TABLE_name=$(echo "Products_info")
export CSV_NAME=$(echo "Products.csv")


    
# Automatically detect the schema
bq load \
--source_format=CSV \
--skip_leading_rows=1 \
--autodetect \
$dataset_name.$TABLE_name \
./$CSV_NAME

