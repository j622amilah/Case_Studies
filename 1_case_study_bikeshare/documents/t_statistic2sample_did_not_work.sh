  bq query \
            --location=$location \
            --allow_large_results \
            --use_legacy_sql=false \
    'CREATE TEMP FUNCTION z_statistic_TWO_SAMPLE(samp1_mean FLOAT64, samp2_mean FLOAT64, samp1_std FLOAT64, samp2_std FLOAT64, samp1_len INT64, samp2_len INT64)
AS (
    (samp1_mean - samp2_mean)/SQRT( ((samp1_std*samp1_std)/samp1_len) + ((samp2_std*samp2_std)/samp2_len))
    );
    
    CREATE TEMP FUNCTION t_statistic_TWO_SAMPLE(samp1_sum FLOAT64, samp2_sum FLOAT64, samp1_mean FLOAT64, samp2_mean FLOAT64, samp1_std FLOAT64, samp2_std FLOAT64, samp1_len INT64, samp2_len INT64)
AS (
    (samp1_mean - samp2_mean)/ ( SQRT( (samp1_sum + samp2_sum ) / (samp1_len + samp2_len - 2) ) * SQRT( 1/samp1_len + 1/samp2_len ) )
    );
    
    
  SELECT 
  z_statistic_TWO_SAMPLE(samp1_mean, samp2_mean, samp1_std, samp2_std, samp1_len, samp2_len) AS z_critical_twosample,
  t_statistic_TWO_SAMPLE(samp1_sum, samp2_sum, samp1_mean, samp2_mean, samp1_std, samp2_std, samp1_len, samp2_len) AS t_critical_twosample FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLETEMP_twosample_table'`'
	


# ---------------------------------------------

	# export TABLETEMP_twosample_table=$(echo "twosample_table")
	#  --destination_table $PROJECT_ID:$dataset_name.$TABLETEMP_twosample_table \

export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	export TABLE_name=$(echo "bikeshare_full_clean2")
	
	# ********* CHANGE *********
	# Numerical feature:
	# export samp1_FEAT_name=$(echo "trip_distance")
	export samp1_FEAT_name=$(echo "trip_time")
	# export samp1_FEAT_name=$(echo "birthyear_INT")
	
	# Categorical feature:
	export category_FEAT_name=$(echo "member_casual")
	export category_FEAT_name_VAR1=$(echo "'member'")
	export category_FEAT_name_VAR2=$(echo "'casual'")
	
	export TABLETEMP_twosample_table=$(echo "twosample_table") 
	# ********* CHANGE *********
	# [2] t_OR_Z_statistic_TWO_SAMPLE : Comparing the the means of two sample populations
     
	# Bigqury returns a full table when the outputs should be scalar
     
	# --destination_table $PROJECT_ID:$dataset_name.$TABLE_name_clean \
	bq query \
            --location=$location \
            --allow_large_results \
            --use_legacy_sql=false \
            'WITH shorttab2 AS
(
  SELECT
  (SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') AS samp1_mean,
  (SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2') AS samp2_mean,
  (SELECT STDDEV(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') AS samp1_std,
  (SELECT STDDEV(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2') AS samp2_std,
  (SELECT CAST(COUNT(*) AS INT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') AS samp1_len,
  (SELECT CAST(COUNT(*) AS INT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2') AS samp2_len
  FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`
  )
SELECT * FROM shorttab2;'

fi




# ---------------------------------------------


export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	# Step 0: Add zero_col to the full table
	export TABLE_name=$(echo "bikeshare_full_clean1")
	export TABLE_name_clean=$(echo "bikeshare_full_clean2")
	
	bq query \
            --location=$location \
            --destination_table $PROJECT_ID:$dataset_name.$TABLE_name_clean \
            --allow_large_results \
            --use_legacy_sql=false \
            'WITH shorttab2 AS
        (
        SELECT ROW_NUMBER() OVER() AS num_row,
        fin_trip_ID,
	rideable_type,
	trip_time,
	fin_stsname,
	fin_stsID,
	fin_esname,
	fin_esID,
	trip_distance,
	member_casual,
	bikeid_INT,
	gender,
	birthyear_INT
	FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`
	)
	SELECT num_row*0 as zero_col,
	fin_trip_ID,
	rideable_type,
	trip_time,
	fin_stsname,
	fin_stsID,
	fin_esname,
	fin_esID,
	trip_distance,
	member_casual,
	bikeid_INT,
	gender,
	birthyear_INT
	FROM shorttab2
	;'

fi


# ---------------------------------------------

export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	export TABLE_name=$(echo "bikeshare_full_clean2")
	# ********* CHANGE *********
	# Numerical feature:
	# export samp1_FEAT_name=$(echo "trip_distance")
	export samp1_FEAT_name=$(echo "trip_time")
	# export samp1_FEAT_name=$(echo "birthyear_INT")
	
	# Categorical feature:
	export category_FEAT_name=$(echo "member_casual")
	export category_FEAT_name_VAR1=$(echo "'member'")
	export category_FEAT_name_VAR2=$(echo "'casual'")
	
	export TABLETEMP_twosample_table=$(echo "twosample_table") 
	# ********* CHANGE *********
	
	# this works for scalars, but can we put the vectors in 
	# looks like you can only multiply or add an existing scalar (making a scalar like AVG(x) gives an aggregation error)
	
	bq query \
		    --location=$location \
		    --allow_large_results \
		    --use_legacy_sql=false \
		    'WITH shorttab2 AS
	(
	  SELECT CAST('$samp1_FEAT_name' AS FLOAT64) AS samp1,
	  zero_col+(SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') AS samp1_mean_vec,
	  zero_col+(SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2') AS samp2_mean_vec
	  FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`
          WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1'
	  )
	SELECT 
	SUM(POW(samp1 - samp1_mean_vec, 2)) AS samp1_sum,
	SUM(POW(samp1 - samp2_mean_vec, 2)) AS samp1_sum,
	WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1'
	FROM shorttab2;'

fi



# ---------------------------------------------


export val=$(echo "X1")

if [[ $val == "X0" ]]
then 
	export TABLE_name=$(echo "bikeshare_full_clean2")
	# ********* CHANGE *********
	# Numerical feature:
	# export samp1_FEAT_name=$(echo "trip_distance")
	export samp1_FEAT_name=$(echo "trip_time")
	# export samp1_FEAT_name=$(echo "birthyear_INT")
	
	# Categorical feature:
	export category_FEAT_name=$(echo "member_casual")
	export category_FEAT_name_VAR1=$(echo "'member'")
	export category_FEAT_name_VAR2=$(echo "'casual'")
	
	export TABLETEMP_twosample_table=$(echo "twosample_table") 
	# ********* CHANGE *********


	bq query \
		    --location=$location \
		    --allow_large_results \
		    --use_legacy_sql=false \
         'SELECT 
         CAST('$samp1_FEAT_name' AS FLOAT64) AS samp1,
	  zero_col+(SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1'),
	  zero_col+(SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2')
	  FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`
          WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1'
	  ;'

fi





CAST('$samp1_FEAT_name' AS FLOAT64) AS x, ROW_NUMBER() OVER(ORDER BY fin_trip_ID) AS num_row 

 WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1'
    FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`
    )
    SELECT
    SUM(POW(x - (samp1_mean+(num_row*0)), 2)) AS samp1_sum,

(SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1')

(SELECT CAST('$samp1_FEAT_name' AS FLOAT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1')


SUM(POW((SELECT CAST('$samp1_FEAT_name' AS FLOAT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') - ((SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1')+(SELECT zero_col FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1')), 2)) AS samp1_sum,


Idea 0 : could work if I save t
WITH shorttab2 AS
(
  SELECT
  (SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') AS samp1_mean,
  (SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2') AS samp2_mean,
  (SELECT STDDEV(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') AS samp1_std,
  (SELECT STDDEV(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2') AS samp2_std,
  (SELECT CAST(COUNT(*) AS INT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') AS samp1_len,
  (SELECT CAST(COUNT(*) AS INT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2') AS samp2_len,
  SUM(POW((SELECT CAST('$samp1_FEAT_name' AS FLOAT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') - ((SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1')+(SELECT zero_col FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1')), 2)) AS samp1_sum,
  SUM(POW( CAST('$samp1_FEAT_name' AS FLOAT64) - AVG(CAST('$samp1_FEAT_name' AS FLOAT64))+zero_col, 2)) AS samp1_sum
  FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`
  WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2'
  )
SELECT * FROM shorttab2;



bq query \
            --location=$location \
            --allow_large_results \
            --use_legacy_sql=false \
    'CREATE TEMP FUNCTION z_statistic_TWO_SAMPLE(samp1_mean FLOAT64, samp2_mean FLOAT64, samp1_std FLOAT64, samp2_std FLOAT64, samp1_len INT64, samp2_len INT64)
AS (
    (samp1_mean - samp2_mean)/SQRT( ((samp1_std*samp1_std)/samp1_len) + ((samp2_std*samp2_std)/samp2_len))
    );
    
    CREATE TEMP FUNCTION t_statistic_TWO_SAMPLE(samp1_sum FLOAT64, samp2_sum FLOAT64, samp1_mean FLOAT64, samp2_mean FLOAT64, samp1_std FLOAT64, samp2_std FLOAT64, samp1_len INT64, samp2_len INT64)
AS (
    (samp1_mean - samp2_mean)/ ( SQRT( (samp1_sum + samp2_sum ) / (samp1_len + samp2_len - 2) ) * SQRT( 1/samp1_len + 1/samp2_len ) )
    );
    
    
    WITH shorttab2 AS
(
  SELECT
  AVG('$samp1_FEAT_name') AS avg_samp1_VAR,
  (SELECT CAST('$samp1_FEAT_name' AS FLOAT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') AS samp1,
  (SELECT CAST('$samp1_FEAT_name' AS FLOAT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2') AS samp2,
  (SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') AS samp1_mean,
  (SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2') AS samp2_mean,
  (SELECT STDDEV(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') AS samp1_std,
  (SELECT STDDEV(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2') AS samp2_std,
  (SELECT CAST(COUNT(*) AS INT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1')  AS samp1_len,
  (SELECT CAST(COUNT(*) AS INT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR2')  AS samp2_len,
  FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'`
  )
  SELECT
  z_statistic_TWO_SAMPLE(samp1_mean, samp2_mean, samp1_std, samp2_std, samp1_len, samp2_len) AS z_critical_twosample,
  t_statistic_TWO_SAMPLE(SUM(POW(samp1 - samp1_mean, 2)), SUM(POW(samp2 - samp2_mean, 2)), samp1_mean, samp2_mean, samp1_std, samp2_std, samp1_len, samp2_len) AS t_critical_twosample
  FROM shorttab2;'
  
  
  
  
	# need to solve : SUM(POW(x - samp1_mean, 2) )
	# first do POW(x - samp1_mean, 2)
	
  #POW(samp1 - samp1_mean_vec, 2)
  
  SUM(POW( CAST('$samp1_FEAT_name' AS FLOAT64) - AVG(CAST('$samp1_FEAT_name' AS FLOAT64))+zero_col, 2)) AS samp2_sum
  

  SUM(POW((SELECT CAST('$samp1_FEAT_name' AS FLOAT64) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1') - ((SELECT AVG(CAST('$samp1_FEAT_name' AS FLOAT64)) FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1')+(SELECT zero_col FROM `'$PROJECT_ID'.'$dataset_name'.'$TABLE_name'` WHERE '$category_FEAT_name'='$category_FEAT_name_VAR1')), 2)) AS samp1_sum,

