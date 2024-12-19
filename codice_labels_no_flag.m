clc;
close all;
clear;

folderPath = 'C:\Users\valer\OneDrive\Desktop\Envisat_nofla\labels';
files = dir(fullfile(folderPath, '*.txt'));

for k = 1:3
    filepath = fullfile(folderPath, files(k).name);
    T = readmatrix(filepath);
    i = 5; 
    
    while j < length(T)
        j = i + 3;
        if j > length(T) % Check if j exceeds the length of T
            break;
        end
        
         
         T(j) = [];
         j = j-1;
         i = j;        
        
    end
    
    %T
    folderName = 'C:\Users\valer\OneDrive\Desktop\Envisat_nofla\train_images';
    New_name =files(k).name;
    filePath = fullfile(folderName, New_name);
    ID = fopen(filePath, 'w');
    
    if ID == -1
        error('Failed to open the file for writing: %s', filePath);
    end
    
    fprintf(ID, '%g\t', T);
    fclose(ID);
end