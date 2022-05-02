function [outTable] = convertPascalVOC2Table(filePath, log)
% Convert xml file (Pascal VOC format) into MATLAB table
% Convert xml file (Pascal VOC format) into more suitable MATLAB table tha
% can be passed as argument to box label datastore

if nargin == 1
    log = false;
elseif nargin > 2 
    error('convertPascalVOC2Table:TooManyInputs', ...
        'requires at most 1 optional input');
end

FILENAME_TAG = "filename";
PATH_TAG = "path";
SOURCE_TAG = "source";
SIZE_TAG = "size";
SEGMENTED_TAG = "segmented";
WIDTH_TAG = "width";
HEIGHT_TAG = "height";
OBJECT_TAG = "object";
CHANNEL_TAG = "depth";
NAME_TAG = "name";
POSE_TAG = "pose";
TRUNCATED_TAG = "truncated";
DIFFICULT_TAG = "difficult";
BOUNDARY_BOX_TAG = "bndbox";

% structure to be converted later to table
structure = struct;

if log
    fprintf("Converting xml file at path: %s...\nInformations:\n", filePath);
end
documentNode = xmlread(filePath);
% annotation node is first (single) child node of document node
annotationNode = item(documentNode.getChildNodes,0);

% extract informations from content nodes (filename,path,segmented)
arr = [FILENAME_TAG,PATH_TAG,SOURCE_TAG,SEGMENTED_TAG];
for i=1:length(arr)
    elements = getElementsByTagName(annotationNode,arr(i));
    node = item(elements,0);
    if ~isequal(arr(i),SOURCE_TAG)
        content = string(node.getTextContent);
        structure.(arr(i)) = string(content);
        if log
            fprintf('\t%s: %s\n', arr(i), content);
        end
    else
        % handle source as struct with single text filed 'database'
        sourceStruct = struct;
        databaseNode = getNextSibling(node.getFirstChild);
        content = databaseNode.getTextContent;
        sourceStruct.database = string(content);
        if log
            fprintf('\t%s: %s\n', "database", content);
        end
        structure.(arr(i)) = sourceStruct;
    end
end

% extract size
elements = getElementsByTagName(annotationNode,SIZE_TAG);
sizeNode = item(elements,0);
widthNode = item(sizeNode.getElementsByTagName(WIDTH_TAG),0);
heightNode = item(sizeNode.getElementsByTagName(HEIGHT_TAG),0);
channelNode = item(sizeNode.getElementsByTagName(CHANNEL_TAG),0);
width = str2double(widthNode.getTextContent);
height = str2double(heightNode.getTextContent);
channels = str2double(channelNode.getTextContent);
size = [width height channels];
structure.(SIZE_TAG) = size;
if log
    fprintf('\t%s: [width: %i,height: %i, channels: %i]\n', SIZE_TAG, size(1),size(2),size(3));
end

% extract all objects
objectNodes = getElementsByTagName(annotationNode,OBJECT_TAG);
bndboxRepStruct = struct("xmin",0,"ymin",0,"xmax",0,"ymax",0);
repStruct = struct(NAME_TAG,"",POSE_TAG,"",TRUNCATED_TAG,0,...
                    DIFFICULT_TAG,0,BOUNDARY_BOX_TAG, bndboxRepStruct);
objects = repmat(repStruct,objectNodes.getLength,1);
if log 
    fprintf("\tobjects:\n");
end
for i=0:(objectNodes.getLength-1)
    currentObjectNode = item(objectNodes,i);
    object_struct = struct();
    arr = [NAME_TAG,POSE_TAG,TRUNCATED_TAG,DIFFICULT_TAG];
    if log 
        fprintf("\t\tObject [%i]:\n", i+1);
    end
    for j=1:length(arr)
        elements = getElementsByTagName(currentObjectNode,arr(j));
        node = item(elements,0);
        content = node.getTextContent;
        if isequal(arr(j),TRUNCATED_TAG) || isequal(arr(j),DIFFICULT_TAG)
            content = str2double(content);
        else 
            content = string(content);
        end
        object_struct.(arr(j)) = content;
        if log
            if isnumeric(content) 
                content = string(content);
            end
            fprintf("\t\t\t%s: %s\n", arr(j), content)
        end
    end
    bndboxNode = item(getElementsByTagName(currentObjectNode,BOUNDARY_BOX_TAG),0); 
    bndboxStruct = struct();
    arr = ["xmin","ymin","xmax","ymax"]; 
    for j=1:length(arr)
        elements = getElementsByTagName(bndboxNode,arr(j));
        node = item(elements,0);
        content = str2double(node.getTextContent);
        bndboxStruct.(arr(j)) = content;
    end
    if log
        fprintf('\t\t\tbndbox: {xmin: %i, ymin: %i, xmax: %i, ymax: %i}\n', ...
                 bndboxStruct.(arr(1)),bndboxStruct.(arr(2)),...
                 bndboxStruct.(arr(3)),bndboxStruct.(arr(4)));
    end
    object_struct.(BOUNDARY_BOX_TAG) = bndboxStruct;
    objects(i+1) = object_struct;
end
structure.objects = objects;

% create return table
outTable = struct2table(structure,'AsArray',true);

end

