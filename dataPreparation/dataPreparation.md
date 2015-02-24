# Data preparation

### prepareData.m
* _program type_: procedure

* _description_: This program is the main file for data preparation.
In data preparation process, all the record data of each signal (7 singals in total) of each video. Following are seven signals and their correspoding files:

|singal index | singal type |   file name  |
|-------------|-------------|--------------|
|	 1		      |     GSR     |  GSR.csv     |
|	 2          |     ECG     |  ECG.csv     |
|	 3          |     RSP     |  RSP.csv     |
|	 4          |     GSR raw |  GSRraw.csv  |
|	 5          |     ECG raw |  ECGraw.csv  |
|	 6          |     RSP raw |  RSPraw.csv  |
|	 7		      |     OBD     |  OBD.csv     |

* _output_: saved file **'prepedData.mat'** in **OUTPUT_PATH** set in the configuration file.
  * **prepedData** - a struct including 7 signals (see dataDescription.md)
    * **structGSR** - a struct contains parameters of GSR sigal and data
      * params - the params of GSR signal
      * startTime - the record staring time of GSR signal
      * data - the data of GSR signal
    * **structECG** - same as **structGSR**
    * **structRSP** - same as **structGSR**
    * **structGSRraw** - same as **structGSR**
    * **structRSPraw** - same as **structGSR**
    * **structOBD** - a struct contains record date, starting time, parameters of GSR sigal and data
      * startDate - the record date of OBD signal
      * startTime - the record starting time of OBD signal
      * initLocation - the starting position of this record
      * params - the params of OBD signal
      * targetParams -  the taget params that user used in this project. (can be manully set)
      * data - the data of OBD signal

##### calling programs:
* getDatasetInfo.m
* analysisRecordFiles.m

#### getDatasetInfo.m
* _program type_: function
* _signature_: [numRecordData, nameRecordData] = getDatasetInfo(dataPath)
* _input params_:
  * dataPath - path of storing recorded data
* _output params_:
  * numRecodData   - number of record data/videos
  * nameRecordData - the folder name (usually is the index number) of each record data folder
* _description_: this function get the infomation of input dataset, and return the number of recorded data collection in this dataset, and the name of each data collection.

#### analysisRecordFiles.m
* _program type_: function
* _signature_: prepData = analysisRecordFiles(recordDataPathList, signalVector)
* _input params_:
  * recordDataPathList - the list of each record data folder path
  * signalVector - the vector of singals used in this project (7 singals)
* _output params_:
  * prepedData - the prepared dataset in .mat format.
* _description_: This function is called to convert data of each reacord data collection from csv file into **.mat** file to be used in the following procedures.

##### calling programs:
* extractSiginfo.m

#### extractSiginfo.m
* _program type_: function
* _signature_: signal = extractSiginfo(sigName, recordDataPath)
* _input params_:
  * sigName - the name/type of signal
  * recordDataPath - the folder path of record data collection
* _output params_:
	* signal - a data structure containg information we want about a specific type of signal.
* _description_: This function is called to extract the data and information of a given signal type and specific record data collection.

###### signal data structure
* Physiological signal
  * signal starting time
  * signal parameters
  * signal data 
* OBD signal:
  * signal record date
  * signal starting time
  * initial GPS location (longitude, latitude)
  * signal parameters
  * singal data