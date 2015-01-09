# Lane_Change_Prediction
Lane_Change_Prediction

Please run the code contained in this folder in the following sequence:
0. Change the configuration file to set the program home path and data repository path.
	* configuration.ini
1. Strating time exraction pahse
	* start_time_generate.m
2. Synchronization phase
	* synchronization_1.m
	* synchronization_2.m
	* synchronization_3.m
3. Signal processing phase
	* signal_preprocessing.m
4. Postnormalization phase
	* par_post_normalization_1.m (if want to use parallel computing)
	* post_normalization_1.m
	* post_normalization_2.m
	* post_normalization_3.m
5. Training and Testing phase
	* Train_Test.m