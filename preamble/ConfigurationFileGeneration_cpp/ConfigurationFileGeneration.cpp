#include "ConfigurationFileGeneration.hpp"

int main(int argc, char * argv[]){

//	std::cout << "There are " << argc << " arguments:" << std::endl;

	if ((argc != 5) || strcmp(argv[1], "-data") || strcmp(argv[3], "-output")) {
		std::cout << ERROR_MESSAGE << std::endl;
		getchar();
		exit(-1);
	}
	else {
		string dataPath		= argv[2];
		string outputPath	= argv[4];
		std::cout << "The data path is " + dataPath + "\nThe output path is " << outputPath << std::endl;
		CreateIniFile(dataPath, outputPath);
	}
	getchar();
	return 0;
}