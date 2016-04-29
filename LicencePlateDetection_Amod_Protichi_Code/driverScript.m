allFiles = dir('./image/*.jpg')
baseFileNames = {allFiles.name};
numberOfFiles = length(baseFileNames);

for i = 1:numberOfFiles
    
   filename = allFiles(i).name
   Demo(filename);
   
end