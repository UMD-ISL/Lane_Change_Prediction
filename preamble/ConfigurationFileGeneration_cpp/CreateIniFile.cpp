#include "ConfigurationFileGeneration.hpp"
#include <fstream>

void CreateIniFile(string datapath, string outputpath) {
	std::cout << "Start Creating .ini file" << std::endl;
	string filename = "configuration.ini";
	ofstream iniFile(filename);
	iniFile << "[Global Path Setting]\n";
	iniFile << "DATA_PATH=" << datapath << std::endl;
	iniFile << "OUTPUT_PATH=" << outputpath << std::endl;
	iniFile << std::endl;
	iniFile << "[Signal Selection]\n";
	iniFile << "FIGURE_OUTPUT_PATH=./Figures\n";
	iniFile.close();

} 