# Convert-PascalVoc2MatlabTable
Simple function that converts from pascal voc format (xml) to matlab table that can bi used to create box/image datastores for training/testing object detection nnets...\n
Use convertAllFiles function if you want to convert multiple xml files at specific folder path to MATLAB table. Resulting MATLAB table will have Nx1 rows where N is equal to number of processed XML files.
