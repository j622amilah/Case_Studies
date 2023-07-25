-------------------------------------
Step 0 : Figure out which lifestyle group corresponds to each kmeans label
-------------------------------------

- Did a count query to determine the maximum counts per cluster. And matched the label as
1 = Light_Active, 2 = Active, 3 = Sedentary 4 = Moderate_Active

+-----------------+--------------+--------------+-----------+
|    lifestyle    | lifesyle_NUM | kmeans_label | max_count |
+-----------------+--------------+--------------+-----------+
| Sedentary       |            1 |            3 |    724950 |
| Light_Active    |            3 |            1 |     51435 |
| Moderate_Active |            2 |            3 |     52650 |  # 3 is taken by Sedentary so let this group be Moderate_Active=4
| Active          |            4 |            2 |      8100 |
+-----------------+--------------+--------------+-----------+


-------------------------------------
Step 1 : Look at the mean of the 4 features and confirm that the data makes logical sense with the assignment of these cluster groups.
Figure out which lifestyle group corresponds to each kmeans label.
-------------------------------------
Numerical feature:
mean_steps
I0720 10:25:31.654829 140283291202880 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
+----------+--------------------+
| category |        mean        |
+----------+--------------------+
|        2 | 13952.709677419389 |
|        1 | 10495.238805970133 |
|        4 |  7418.750000000008 |
|        3 |  297.1307291666687 |
+----------+--------------------+
Numerical feature:
mean_total_distance
I0720 10:25:34.262447 139741584086336 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
+----------+--------------------+
| category |        mean        |
+----------+--------------------+
|        2 | 10.355403200272507 |
|        1 |  7.307238835007453 |
|        4 |   5.04535714217598 |
|        3 | 0.2003802077524562 |
+----------+--------------------+
Numerical feature:
mean_calories
I0720 10:25:36.611809 140595090158912 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
+----------+--------------------+
| category |        mean        |
+----------+--------------------+
|        2 |   3014.45161290323 |
|        1 | 2529.6417910447494 |
|        4 |  2291.982142857137 |
|        3 | 1736.6692708333583 |
+----------+--------------------+
Numerical feature:
mean_hr
I0720 10:25:39.068351 140517274256704 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
+----------+-------------------+
| category |       mean        |
+----------+-------------------+
|        3 |  82.0109830818046 |
|        4 | 81.79351970599234 |
|        2 | 78.98634597694367 |
|        1 | 76.79526224126202 |
+----------+-------------------+
Numerical feature:
sleep_duration
I0720 10:25:41.417542 139715729474880 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
+----------+--------------------+
| category |        mean        |
+----------+--------------------+
|        1 | 431.33762469029716 |
|        2 |  413.3834687830469 |
|        3 |  402.5575733897062 |
|        4 | 364.44050474858057 |
+----------+--------------------+

# These groups are in order from most to least of the following numerical features: mean_steps, mean_total_distance, mean_calories
# 2 = Active, 1 = Light_Active, 4 = Moderate_Active, 3 = Sedentary


-------------------------------------
Step 2 : Now that it is confirmed that the label is 2 = Active, 1 = Light_Active, 4 = Moderate_Active, 3 = Sedentary
-------------------------------------
Numerical feature:
mean_steps
I0721 22:03:39.219891 139992548513088 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
rm: remove table 'northern-eon-377721:google_analytics_exercise.TABLE_name_probcount_NUMERICAL'? (y/N) y
I0721 22:03:43.777057 140030150509888 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
Waiting on bqjob_r71d65d5d1c3f6b4d_000001897a0d1024_1 ... (1s) Current status: DONE   
+---------+-----------------+---------+----------------------+
| row_num | kmeans_CATlabel |  wday   |      prob_perc       |
+---------+-----------------+---------+----------------------+
|       1 | Active          | weekday |    2.613885531044661 |
|       3 | Light_Active    | weekday |     2.00343638442924 |
|       6 | Moderate_Active | weekday |        1.42397185309 |
|       7 | Sedentary       | weekday | 0.054410657041594715 |
|       2 | Active          | weekend |    6.866634957826329 |
|       4 | Light_Active    | weekend |   5.0331078922807535 |
|       5 | Moderate_Active | weekend |   3.5363506749944866 |
|       8 | Sedentary       | weekend |   0.1518482658844506 |
+---------+-----------------+---------+----------------------+
I0721 22:03:48.461475 140003458151744 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
+---------+-----------------+---------+----------------------+--------------------+--------------------+----------------------+
| row_num | kmeans_CATlabel |  wday   |      prob_perc       |      pop_mean      |      pop_std       | z_critical_onesample |
+---------+-----------------+---------+----------------------+--------------------+--------------------+----------------------+
|       1 | Active          | weekday |    2.613885531044661 | 2.7104557770739395 | 2.3638930302675147 | -0.04085220642084214 |
|       3 | Light_Active    | weekday |     2.00343638442924 | 2.7104557770739395 | 2.3638930302675147 | -0.29909111097327784 |
|       6 | Moderate_Active | weekday |        1.42397185309 | 2.7104557770739395 | 2.3638930302675147 |  -0.5442225631666386 |
|       7 | Sedentary       | weekday | 0.054410657041594715 | 2.7104557770739395 | 2.3638930302675147 |  -1.1235893866702453 |
|       2 | Active          | weekend |    6.866634957826329 | 2.7104557770739395 | 2.3638930302675147 |    1.758192577894291 |
|       4 | Light_Active    | weekend |   5.0331078922807535 | 2.7104557770739395 | 2.3638930302675147 |   0.9825538150277326 |
|       5 | Moderate_Active | weekend |   3.5363506749944866 | 2.7104557770739395 | 2.3638930302675147 |  0.34937913321191316 |
|       8 | Sedentary       | weekend |   0.1518482658844506 | 2.7104557770739395 | 2.3638930302675147 |   -1.082370258902933 |
+---------+-----------------+---------+----------------------+--------------------+--------------------+----------------------+
I0721 22:03:50.884605 139660474922304 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
rm: remove table 'northern-eon-377721:google_analytics_exercise.TABLE_name_probcount_NUMERICAL'? (y/N) y
Numerical feature:
mean_total_distance
I0721 22:03:59.009962 140408184255808 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
BigQuery error in rm operation: Not found: Table northern-
eon-377721:google_analytics_exercise.TABLE_name_probcount_NUMERICAL
I0721 22:04:01.496368 140254600262976 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
Waiting on bqjob_r814f8fe62daa07e_000001897a0d555c_1 ... (1s) Current status: DONE   
+---------+-----------------+---------+---------------------+
| row_num | kmeans_CATlabel |  wday   |      prob_perc      |
+---------+-----------------+---------+---------------------+
|       1 | Active          | weekday |  2.7826662685102552 |
|       3 | Light_Active    | weekday |  1.9756716956805767 |
|       6 | Moderate_Active | weekday |  1.3766125002012344 |
|       7 | Sedentary       | weekday | 0.05210528289099534 |
|       2 | Active          | weekend |   7.111599260814157 |
|       4 | Light_Active    | weekend |   4.972370006756713 |
|       5 | Moderate_Active | weekend |   3.399115394940613 |
|       8 | Sedentary       | weekend | 0.14481271939000928 |
+---------+-----------------+---------+---------------------+
I0721 22:04:06.031268 140065621488960 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
+---------+-----------------+---------+---------------------+--------------------+--------------------+----------------------+
| row_num | kmeans_CATlabel |  wday   |      prob_perc      |      pop_mean      |      pop_std       | z_critical_onesample |
+---------+-----------------+---------+---------------------+--------------------+--------------------+----------------------+
|       1 | Active          | weekday |  2.7826662685102552 | 2.7268691411480694 | 2.4181465265184987 | 0.023074336790715126 |
|       3 | Light_Active    | weekday |  1.9756716956805767 | 2.7268691411480694 | 2.4181465265184987 | -0.31065009387542014 |
|       6 | Moderate_Active | weekday |  1.3766125002012344 | 2.7268691411480694 | 2.4181465265184987 |  -0.5583849556423915 |
|       7 | Sedentary       | weekday | 0.05210528289099534 | 2.7268691411480694 | 2.4181465265184987 |  -1.1061214979838454 |
|       2 | Active          | weekend |   7.111599260814157 | 2.7268691411480694 | 2.4181465265184987 |   1.8132607232775746 |
|       4 | Light_Active    | weekend |   4.972370006756713 | 2.7268691411480694 | 2.4181465265184987 |   0.9286041358467968 |
|       5 | Moderate_Active | weekend |   3.399115394940613 | 2.7268691411480694 | 2.4181465265184987 |  0.27800062834091505 |
|       8 | Sedentary       | weekend | 0.14481271939000928 | 2.7268691411480694 | 2.4181465265184987 |   -1.067783276754345 |
+---------+-----------------+---------+---------------------+--------------------+--------------------+----------------------+
I0721 22:04:08.457894 140463777662272 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
rm: remove table 'northern-eon-377721:google_analytics_exercise.TABLE_name_probcount_NUMERICAL'? (y/N) y
Numerical feature:
mean_calories
I0721 22:04:14.542232 139831750329664 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
BigQuery error in rm operation: Not found: Table northern-eon-377721:google_analytics_exercise.TABLE_name_probcount_NUMERICAL
I0721 22:04:16.732836 140404138550592 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
Waiting on bqjob_r1dcce73aa051ff7_000001897a0d90df_1 ... (1s) Current status: DONE   
+---------+-----------------+---------+--------------------+
| row_num | kmeans_CATlabel |  wday   |     prob_perc      |
+---------+-----------------+---------+--------------------+
|       1 | Active          | weekday | 0.6328787708455136 |
|       3 | Light_Active    | weekday |  0.531263976668993 |
|       6 | Moderate_Active | weekday |  0.484298895003764 |
|       7 | Sedentary       | weekday |  0.365053266205282 |
|       2 | Active          | weekend | 1.6004947711016488 |
|       4 | Light_Active    | weekend | 1.3409511667735643 |
|       5 | Moderate_Active | weekend | 1.2067670311937393 |
|       8 | Sedentary       | weekend | 0.9212319439915988 |
+---------+-----------------+---------+--------------------+
I0721 22:04:21.414157 140341590680896 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
+---------+-----------------+---------+--------------------+-------------------+---------------------+----------------------+
| row_num | kmeans_CATlabel |  wday   |     prob_perc      |     pop_mean      |       pop_std       | z_critical_onesample |
+---------+-----------------+---------+--------------------+-------------------+---------------------+----------------------+
|       1 | Active          | weekday | 0.6328787708455136 | 0.885367477723013 | 0.45422936303259953 |  -0.5558617020964772 |
|       3 | Light_Active    | weekday |  0.531263976668993 | 0.885367477723013 | 0.45422936303259953 |  -0.7795698162045204 |
|       6 | Moderate_Active | weekday |  0.484298895003764 | 0.885367477723013 | 0.45422936303259953 |  -0.8829648969445086 |
|       7 | Sedentary       | weekday |  0.365053266205282 | 0.885367477723013 | 0.45422936303259953 |   -1.145487839103851 |
|       2 | Active          | weekend | 1.6004947711016488 | 0.885367477723013 | 0.45422936303259953 |   1.5743748678072842 |
|       4 | Light_Active    | weekend | 1.3409511667735643 | 0.885367477723013 | 0.45422936303259953 |   1.0029815906415862 |
|       5 | Moderate_Active | weekend | 1.2067670311937393 | 0.885367477723013 | 0.45422936303259953 |    0.707571063493004 |
|       8 | Sedentary       | weekend | 0.9212319439915988 | 0.885367477723013 | 0.45422936303259953 |  0.07895673240748154 |
+---------+-----------------+---------+--------------------+-------------------+---------------------+----------------------+
I0721 22:04:24.049922 140155489039680 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
rm: remove table 'northern-eon-377721:google_analytics_exercise.TABLE_name_probcount_NUMERICAL'? (y/N) y
Numerical feature:
mean_hr
I0721 22:04:43.897716 140438597338432 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
BigQuery error in rm operation: Not found: Table northern-eon-377721:google_analytics_exercise.TABLE_name_probcount_NUMERICAL
I0721 22:04:45.864409 140238175495488 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
Waiting on bqjob_r6f29f18d749a93f8_000001897a0e02ab_1 ... (1s) Current status: DONE   
+---------+-----------------+---------+---------------------+
| row_num | kmeans_CATlabel |  wday   |      prob_perc      |
+---------+-----------------+---------+---------------------+
|       1 | Active          | weekday | 0.38721973884100075 |
|       3 | Light_Active    | weekday | 0.37123156813466845 |
|       6 | Moderate_Active | weekday |  0.4044813597159126 |
|       7 | Sedentary       | weekday |  0.3978236128859887 |
|       2 | Active          | weekend |  0.9560253635729457 |
|       4 | Light_Active    | weekend |   0.945550532842494 |
|       5 | Moderate_Active | weekend |  0.9822262817527799 |
|       8 | Sedentary       | weekend |  1.0083741728619213 |
+---------+-----------------+---------+---------------------+
I0721 22:04:50.380335 140713387922752 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
+---------+-----------------+---------+---------------------+--------------------+-------------------+----------------------+
| row_num | kmeans_CATlabel |  wday   |      prob_perc      |      pop_mean      |      pop_std      | z_critical_onesample |
+---------+-----------------+---------+---------------------+--------------------+-------------------+----------------------+
|       1 | Active          | weekday | 0.38721973884100075 | 0.6816165788259639 | 0.312238179102836 |  -0.9428598412624076 |
|       3 | Light_Active    | weekday | 0.37123156813466845 | 0.6816165788259639 | 0.312238179102836 |  -0.9940648884871629 |
|       6 | Moderate_Active | weekday |  0.4044813597159126 | 0.6816165788259639 | 0.312238179102836 |  -0.8875763364568447 |
|       7 | Sedentary       | weekday |  0.3978236128859887 | 0.6816165788259639 | 0.312238179102836 |  -0.9088989910055415 |
|       2 | Active          | weekend |  0.9560253635729457 | 0.6816165788259639 | 0.312238179102836 |   0.8788444306697192 |
|       4 | Light_Active    | weekend |   0.945550532842494 | 0.6816165788259639 | 0.312238179102836 |   0.8452968652805367 |
|       5 | Moderate_Active | weekend |  0.9822262817527799 | 0.6816165788259639 | 0.312238179102836 |   0.9627576736149548 |
|       8 | Sedentary       | weekend |  1.0083741728619213 | 0.6816165788259639 | 0.312238179102836 |    1.046501087646746 |
+---------+-----------------+---------+---------------------+--------------------+-------------------+----------------------+
I0721 22:04:52.722564 139694839113024 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
rm: remove table 'northern-eon-377721:google_analytics_exercise.TABLE_name_probcount_NUMERICAL'? (y/N) y
Numerical feature:
sleep_duration
I0721 22:04:57.749671 140682170778944 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
BigQuery error in rm operation: Not found: Table northern-eon-377721:google_analytics_exercise.TABLE_name_probcount_NUMERICAL
I0721 22:04:59.701134 139973476447552 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
Waiting on bqjob_r81ad47fd7c19006_000001897a0e38b8_1 ... (1s) Current status: DONE   
+---------+-----------------+---------+---------------------+
| row_num | kmeans_CATlabel |  wday   |      prob_perc      |
+---------+-----------------+---------+---------------------+
|       1 | Active          | weekday | 0.42057956952821957 |
|       3 | Light_Active    | weekday |  0.4482136543684808 |
|       6 | Moderate_Active | weekday | 0.36145575059195006 |
|       7 | Sedentary       | weekday |   0.418709576750043 |
|       2 | Active          | weekend |  1.0552122262005743 |
|       4 | Light_Active    | weekend |   1.074225939437099 |
|       5 | Moderate_Active | weekend |   0.954896952253091 |
|       8 | Sedentary       | weekend |  0.9914466383002619 |
+---------+-----------------+---------+---------------------+
I0721 22:05:04.155054 140568128144704 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.
+---------+-----------------+---------+---------------------+-------------------+--------------------+----------------------+
| row_num | kmeans_CATlabel |  wday   |      prob_perc      |     pop_mean      |      pop_std       | z_critical_onesample |
+---------+-----------------+---------+---------------------+-------------------+--------------------+----------------------+
|       1 | Active          | weekday | 0.42057956952821957 | 0.715592538428715 | 0.3271954445255897 |   -0.901641431249886 |
|       3 | Light_Active    | weekday |  0.4482136543684808 | 0.715592538428715 | 0.3271954445255897 |  -0.8171840058712145 |
|       6 | Moderate_Active | weekday | 0.36145575059195006 | 0.715592538428715 | 0.3271954445255897 |  -1.0823402151892372 |
|       7 | Sedentary       | weekday |   0.418709576750043 | 0.715592538428715 | 0.3271954445255897 |  -0.9073566476731707 |
|       2 | Active          | weekend |  1.0552122262005743 | 0.715592538428715 | 0.3271954445255897 |   1.0379719322323817 |
|       4 | Light_Active    | weekend |   1.074225939437099 | 0.715592538428715 | 0.3271954445255897 |   1.0960831118183114 |
|       5 | Moderate_Active | weekend |   0.954896952253091 | 0.715592538428715 | 0.3271954445255897 |   0.7313806406178747 |
|       8 | Sedentary       | weekend |  0.9914466383002619 | 0.715592538428715 | 0.3271954445255897 |    0.843086615314941 |
+---------+-----------------+---------+---------------------+-------------------+--------------------+----------------------+
I0721 22:05:06.501202 139857512662336 bigquery_client.py:730] There is no apilog flag so non-critical logging is disabled.






