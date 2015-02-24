#include "ConfigurationFileGeneration.hpp"
#include <fstream>

void CreateIniFile(string homePath, string dataPath, string outputPath, string driverName) {
	std::cout << "Start Creating .ini file" << std::endl;
	string filename = "configuration.ini";
	ofstream iniFile(filename);
	iniFile << "[Global Path Setting]\n";
	iniFile << "HOME_PATH=" << homePath << std::endl;
	iniFile << "DATA_PATH=" << dataPath << std::endl;
	iniFile << "OUTPUT_PATH=" << outputPath << std::endl;
	iniFile << std::endl;
	iniFile << "[Signal Selection]\n";
	iniFile << "FIGURE_OUTPUT_PATH=./Figures\n";
	iniFile << std::endl;
	iniFile << "[Driver Dataset Path]\n";
	iniFile << "DATA_PATH=" + driverName;
	iniFile.close();

} 