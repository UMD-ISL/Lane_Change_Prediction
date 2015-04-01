#include <iostream>
#include <string>

#define ERROR_MESSAGE "ERROR:\nPlease add to input arugments into test.bat file in the following format:\n\n\tConfigurationFileGeneration.exe -home HOME_PATH -data DATA_PATH -output OUTPUT_PATH -driver DRIVER_NAME (e.g.)\n\nPress any key to exit..."

using namespace std;

void CreateIniFile(string homePath, string dataPath, string outputPath, string driverName);