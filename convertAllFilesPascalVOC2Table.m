function [outputTable] = convertAllFilesPascalVOC2Table(folderPath,log)
% Convert all xml files (Pascal VOC format) in folder at folderPath into
% joined MATLAB table.
% This function will iterate on each xml file present in folder at
% specified folder path and convert it to matlab table. All individual
% tables will be joined in single table. Resulting joined table will be passed
% back to user.

if nargin == 1
    log = false;
elseif nargin > 2 
    error('converAllFilesPascalVOC2Table:TooManyInputs', ...
        'requires at most 1 optional input');
end

% List all xml files in folder
% files is a struct array with fields: {name,folder,date,bytes,isdir,datenum}
files = dir(fullfile(folderPath,"*.xml"));
fprintf("Convering all xml files from folder at path: %s\n", folderPath);
for i=1:numel(files)
    filePath = fullfile(files(i).folder,files(i).name);
    table = convertPascalVOC2Table(filePath,log);
    if i == 1
       outputTable = table;
    else
       outputTable = [outputTable;table];
    end
end 

end