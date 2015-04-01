#include "ConfigurationFileGeneration.hpp"

int main(int argc, char * argv[]){

//	std::cout << "There are " << argc << " arguments:" << std::endl;

	if ((argc != 9) || strcmp(argv[1], "-home") || strcmp(argv[3], "-data") || strcmp(argv[5], "-output") || strcmp(argv[7], "-driver")) {
		std::cout << ERROR_MESSAGE << std::endl;
		getchar();
		exit(-1);
	}
	else {
		string homePath     = argv[2];
		string dataPath		= argv[4];
		string outputPath	= argv[6];
		string driverName	= argv[8];
		std::cout << "The home path is " + homePath + "\nThe data path is " + dataPath + "\nThe output path is " << outputPath << + "\nDriver name is " << driverName << std::endl;
		CreateIniFile(homePath, dataPath, outputPath, driverName);
	}
	getchar();
	return 0;
}