# Lane Change Prediction prototype code
**copyright**: @Univeristy of Michigan Dearborn - Intelligent System Laboratory

**editor**: myuan@umich.edu


#### Description
This project want to predict driver's lane change envent in advanced using drivers' physiological signal feature.

#### Dataset
Dataset is forbidden to share on the Github.

#### Code
##### Please run the code contained in this folder in the following sequence:
1. Change the **configuration file** to set the program home path and data repository path.
	* configuration.ini
2. **Strating time exraction pahse**
	* start_time_generate.m
3. Synchronization phase
	* synchronization_1.m
	* synchronization_2.m
	* synchronization_3.m
4. **Signal processing phase**
	* signal_preprocessing.m
5. **Postnormalization phase**
	* par_post_normalization_1.m (if want to use parallel computing)
	* post_normalization_1.m
	* post_normalization_2.m
	* post_normalization_3.m
6. **Training and Testing phase**
	* Train_Test.m