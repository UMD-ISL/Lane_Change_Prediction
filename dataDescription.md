# Signal description
Two different classes of signals are used in this project:
* Physiological Signals (6)
* On-board diagnostics (OBD) signal

#### Physiological signals
Six physiological signal data are used in this project:
* GSR
* ECG
* RSP
* GSR raw
* ECG raw
* RSP raw

##### GSR (galvanic skin response) signal description
* data file name: **GSR.csv**
* columns in data file:

| GSR | SCL | SCR | Timestamp | Duration | 
|-----|-----|-----|-----------|----------|

* data resolution: 0.5 Hz (2 seconds/sample)

##### ECG (Electrocardiogram) signal description
* data file name: **ECG.csv**
* columns in data file:

| HR | RR | Timestamp | Duration | 
|----|----|-----------|----------|

* data resolution: 1/0.7 Hz (0.7 second/sample)

##### RSP (respiration) signal description
* data file name: **RSP.csv**
* columns in data file (17 in total):
  * Exp Vol, Insp Vol, qDEEL, Resp Rate, Resp Rate
  * Inst, Te, Ti, Ti/Te, Ti/Tt, Tpef/Te, Tt, Vent, Vt/Ti
  * Work of Breathing, Timestamp, Duration

* data resolution: has variance in sample frequency 0.2Hz ~ 0.5Hz

##### GSR raw (galvanic skin response) signal description (need to be modified)
* data file name: **GSRraw.csv**
* columns in data file:

|DateTime | GSR (raw) | GSR (microSiemens)|
|---------|-----------|-------------------|

* data resolution: 2 Hz

##### ECG raw (Electrocardiogram) signal description
* data file name: **ECGraw.csv**
* columns in data file:

| SEM_ecg1 | SEM_ecg2 | Timestamp | Duration |
|----------|----------|-----------|----------|

* data resolution: 256 Hz

##### RSP raw (respiration) signal description
* data file name: **RSP.csv**
* columns in data file:

| SEM_belt | Timestamp | Duration |
|----------|-----------|----------|

* data resolution: 25.6 Hz

#### OBD (On-board diagnostics) signal description
* data file name: **OBD.csv**
* columns in data file (17 in total):
  * time [s], RPM [rpm], speed [mph], distance [km], power output [kW], torque output [N.m], gear [-], heading [degs], change in heading [degs], corner radius [m], GPS altitude [m], GPS heading [degs], GPS time [s], GPS vel raw [mph], GPS long [degs], GPS lat [degs], Water temp [C], Throttle position [-], Ignition angle [degs], Boost pressure [bar]
* data resolution: 100 Hz