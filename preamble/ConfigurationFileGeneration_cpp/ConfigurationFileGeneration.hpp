#include <iostream>
#include <string>

#define ERROR_MESSAGE "ERROR:\nPlease add to input arugments into test.bat file in the following format:\n\n\tConfigurationFileGeneration.exe -data DATA_PATH -output OUTPUT_PATH\n\nPress any key to exit..."

using namespace std;

void CreateIniFile(string datapath, string outputpath);