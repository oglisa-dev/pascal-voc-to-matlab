# Convert-PascalVoc2MatlabTable
Simple function __convertPascalVOC2Table__ that converts from pascal voc format (xml) to matlab table that can be used to create box/image datastores for training/testing object detection nnets...

Use __convertAllFilesPascalVOC2Table__ function if you want to convert multiple xml files at specific folder to MATLAB table. 
Resulting MATLAB table will have N rows where N is equal to number of processed XML files.

## About


## How to use

If you want to convert single xml file (pascalVOC format) to matlab table, you should use __convertPascalVOC2Table__ function. 
This function expects two input arguments:
* XML file path (required)
* logging flag (optional) - used to log (print) transformation steps and details about processed xml file (filename,path,size,objects...)


If you have multiple xml files stored in a single folder/dir (which is most likely the case) and want to convert them all to joined matlab table, use __convertAllFilesPascalVOC2Table__ function. 
This function expects two input arguments:
* Folder/directory path (required) - folder/dir where xml files are stored
* logging flag (optional) - same as in function above 
