# Convert-PascalVoc2MatlabTable
Simple function __convertPascalVOC2Table__ that converts from pascal voc format (xml) to matlab table that can be used to create box/image datastores for training/testing object detection nnets...

Use __convertAllFilesPascalVOC2Table__ function if you want to convert multiple xml files at specific folder to MATLAB table. 
Resulting MATLAB table will have N rows where N is equal to number of processed XML files.

## About

Use these function to convert xml files (pascalVOC format) in more suitable matlab table. 

Resulting matlab table size is __Nx6__, where _N_ is equal to number of xml files (every xml file corresponds to single image in dataset).  
Table has six columns:
1. filename 
2. path 
3. source
4. segmented
5. size
6. objects

__Filename__ - the relative path of the image which is annotated (string column)

__Path__ - an absolute path of the output file after annotations (string column)

__Source__ - struct column (matlab struct with single field _datastore_ which is string representing name of datastore)

__Segmented__ 

__Size__ - column representing size of corresponding input image (vector: [width height channels])

__Objects__ - column representing objects in input image (cell array with single element that is struct array with fields {name,pose,truncated,difficulty,bndbox}). Size of struct array is M, where M is equal to numbers of objects in input image. Bndbox is also struct with fields {xmin,ymin,xmax,ymax}


## How to use

If you want to convert single xml file (pascalVOC format) to matlab table, you should use __convertPascalVOC2Table__ function. 
This function expects two input arguments:
* XML file path (required)
* logging flag (optional) - used to log (print) transformation steps and details about processed xml file (filename,path,size,objects...)


If you have multiple xml files stored in a single folder/dir (which is most likely the case) and want to convert them all to joined matlab table, use __convertAllFilesPascalVOC2Table__ function. 
This function expects two input arguments:
* Folder/directory path (required) - folder/dir where xml files are stored
* logging flag (optional) - same as in function above 
