Lane Departure Prediction prototype system implementation
=================================================

**copyright:** University of Michigan Dearborn - Intelligent System Laboratory
**editor:** [Yuan Ma](http://www-personal.umd.umich.edu/~myuan)
**email:** [myuan@umich.edu](mailto:myuan@umich.edu)

[//]: # (This may be the most platform independent comment)

----------

### Table of contents

[TOC]

------------------


Project description
-------------

This project wants to predict driver's lane departure event in advanced using drivers' physiological signal feature.

Dataset
---------
> **Note:**

> - Dataset is forbidden to share on Github.
> - For more details about data description, please read **dataDescription.md** file.

----------


Program Architecture
-------------------

Please run this project program in the following sequence:
| Step index | Objective | Code path   |
| :-------   | :----     | :---       |
| 1 	     | [Environmental Variable Configuration](#environmental-variable-configuration) | **./preamble** |
| 2          | [Data Preparation](#data-preparation)     | **./dataPreparation**       |
| 3          | [Data Preprocessing](#data-preprocessing) | **./dataPreprocessing**     |
| 4          | [Data Clean](#data-clean)  			     | **./dataClean**  		       |
| 5			 | [Data Synchronization](#data-synchronization) | **./dataSynchronization**   |
| 6 		 | [Signal Selection](#signal-selection)  	 | **./signalSelection**       |
| 7   		 | [Feature Generation](#feature-generation) | **./featureGeneration**	  |
| 8			 | [Trainingset Generation](#trainingset-generation) | **./trainingsetGeneration** |
| 9          | [Model Selection](#model-selection)       | **./modelSelection**		  |
| 10		 | [Event-based Training and Testing](#event-based-training-and-testing)     | **./eventTrainTest**  	      |
| 11 	  	 | [Real-time Training and Testing](#real-time-training-and-testing) 		| **./realtimeTrainTest**     |

### <i class="icon-code"></i>  Environmental Variable Configuration

> **Note:** For more details, please go to _folder_ **preamble** and read the file **preamble.md**.


### <i class="icon-code"></i> Data Preparation

> **Note:** For more details, please go to _folder_ **dataPreparation** and read the file **dataPreparation.md**.

### <i class="icon-code"></i> Data Preprocessing

> **Note:** For more details, please go to _folder_ **dataPreprocessing** and read the file **dataPreprocessing.md**.

### <i class="icon-code"></i> Data Clean
> **Note:** For more details, please go to _folder_ **dataClean** and read the file **dataClean.md**.


### <i class="icon-code"></i> Data Synchronization
> **Note:** For more details, please go to _folder_ **dataSynchronization** and read the file **dataSynchronization.md**.


### <i class="icon-code"></i> Signal Selection
> **Note:** For more details, please go to _folder_ **signalSelection** and read the file **signalSelection.md**.


### <i class="icon-code"></i> Feature Generation
> **Note:** For more details, please go to _folder_ **featureGeneration** and read the file **featureGeneration.md**.


### <i class="icon-code"></i> Trainingset Generation
> **Note:** For more details, please go to _folder_ **trainingsetGeneration** and read the file **trainingsetGeneration.md**.


### <i class="icon-code"></i> Model Selection
> **Note:** For more details, please go to _folder_ **modelSelection** and read the file **modelSelection.md**.


### <i class="icon-code"></i> Event-based Training and Testing
> **Note:** For more details, please go to _folder_ **eventTrainTest** and read the file **eventTrainTest.md**.


### <i class="icon-code"></i> Real-time Training and Testing
> **Note:** For more details, please go to _folder_ **realtimeTrainTest** and read the file **realtimeTrainTest.md**.

----------


Support StackEdit
---------------------
[![](https://cdn.monetizejs.com/resources/button-32.png)](https://monetizejs.com/authorize?client_id=ESTHdCYOi18iLhhO&summary=true)

  [^stackedit]: [StackEdit](https://stackedit.io/) is a full-featured, open-source Markdown editor based on PageDown, the Markdown library used by Stack Overflow and the other Stack Exchange sites.
 