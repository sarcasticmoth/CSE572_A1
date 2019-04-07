clear all
clc

% file variables
workingDir = 'C:\Users\rando\OneDrive\Graduate School\SPRING 2019\CSE572_Data_Mining\CSE572_A1\';
dataPath = fullfile(workingDir, 'Data', filesep);
myoDataPath = fullfile(dataPath, 'MyoData', filesep);
gtDataPath = fullfile(dataPath, 'groundTruth', filesep);
endPath = fullfile(workingDir, 'P1_Data', filesep);

if ~exist(endPath, 'dir')
    mkdir(endPath);
end

% remove folders . and ..
list = dir(gtDataPath);
list = list(~ismember({list.name},{'.','..'}));

% predefined variables
imu_EA=[];
imu_NEA=[];

% for each folder in the Data folder
% should return 6 users/folders
for i = 1:size(list, 1)
    % get the user fork path
    forkPath = fullfile(gtDataPath, list(i,:).name, "fork");
    
    % get the list of files in the folder
    forklist = dir(forkPath);
    forklist = forklist(~ismember({forklist.name},{'.','..'}));
    
    % read the ground truth file for this user
    gtFileData = dlmread(fullfile(strtrim(forklist(1,:).folder), strtrim(forklist(1,:).name)));
    
    % get my myoData for fork
    myo = dir(myoDataPath);
    myo = myo(~ismember({myo.name},{'.','..'}));
    
    myoFork = fullfile(strtrim(myo(i,:).folder), strtrim(myo(i,:).name), "fork");
    myoFolders = dir(myoFork);
    myoFolders = myoFolders(~ismember({myoFolders.name},{'.','..'}));
    
    % get eating action of fork for this user %
    for j = 1:size(myoFolders,1)
        if contains(myoFolders(j,:).name, "IMU")
            IMUfile = dlmread(fullfile(strtrim(myoFolders(j,:).folder), strtrim(myoFolders(j,:).name)));
        end
        
        if contains(myoFolders(j,:).name, "EMG")
            EMGfile = dlmread(fullfile(strtrim(myoFolders(j,:).folder), strtrim(myoFolders(j,:).name)));
        end
    end
    
    % for the eating data
    % we synchornize the frames where an eating action occurs
    % with the IMU and EMG data.
    % data outside of these start and end frames are non-eating
    imu_EA=[];
    for j = 1: size(gtFileData, 1)
        % convert frames to sample numbers
        
        % for IMU data it is 50 Hz and 30 FPS
        s = floor(gtFileData(j, 1) * (50/30));
        e = floor(gtFileData(j, 2) * (50/30));
        
        found = IMUfile(s:e, 2:size(IMUfile, 2));
        
        % compare the found rows to the matrix columns
        % since the data is transposed
        if size(found, 1) > size(imu_EA, 2) && j > 1
            a = size(imu_EA, 1);
            b = size(imu_EA, 2);
            c = size(found, 1);
            d = size(found, 2);
            
            newCols = c;
            newRows = a + d;
            
            temp = zeros(newRows, newCols);
            temp(1:a, 1:b) = imu_EA;
            
            imu_EA = temp;
            
            imu_EA((a+1):newRows, 1:newCols) = found';
        else
            if size(found, 1) < size(imu_EA, 2)
                x = found';
                x = [x zeros(size(x, 1), size(imu_EA, 2) - size(x, 2))];
                imu_EA = [imu_EA; x];
            else
                imu_EA = [imu_EA; found'];
            end
        end        
    end
    
    % for the non-eating data
    % we synchornize the frames where a non-eating action occurs
    % with the IMU and EMG data.
    % the data is located between an end frame and the next start frame
    imu_NEA=[];
    for j = 2:size(gtFileData, 1)
        % convert frames to sample numbers
        
        % for IMU data it is 50 Hz and 30 FPS
        s = floor(gtFileData(j - 1, 2) * (50/30));
        e = floor(gtFileData(j, 1) * (50/30));
        
        found = IMUfile(s:e, 2:size(IMUfile, 2));
        
        % compare the found rows to the matrix columns
        % since the data is transposed
        if size(found, 1) > size(imu_NEA, 2) && j > 1
            a = size(imu_NEA, 1);
            b = size(imu_NEA, 2);
            c = size(found, 1);
            d = size(found, 2);
            
            newCols = c;
            newRows = a + d;
            
            temp = zeros(newRows, newCols);
            temp(1:a, 1:b) = imu_NEA;
            
            imu_NEA = temp;
            
            imu_NEA((a+1):newRows, 1:newCols) = found';
        else
            if size(found, 1) < size(imu_NEA, 2)
                x = found';
                x = [x zeros(size(x, 1), size(imu_NEA, 2) - size(x, 2))];
                imu_NEA = [imu_NEA; x];
            else
                imu_NEA = [imu_NEA; found'];
            end
        end
    end
    
    % matrices are organized in this way:
    % action OriX
    % action OriY
    % action OriZ
    % action OriW
    % action AccX
    % action AccY
    % action AccZ
    % action GyroX
    % action GyroY
    % action GyroZ

    % the number of rows in each matrix divided by the total
    % number of sensors gives estimate of number of actions
    sensors = 10;
    EA_actions = size(imu_EA, 1) / sensors;
    NEA_actions = size(imu_NEA, 1) / sensors;

    mat_EA = {};
    mat_NEA = {};
    OriX = [];
    OriY = [];
    OriZ = [];
    OriW = [];
    AccX = [];
    AccY = [];
    AccZ = [];
    GyrX = [];
    GyrY = [];
    GyrZ = [];

    a = 1;
    for k=1:10:size(imu_EA)
    %     fprintf('OriX: %i \n',i);
        OriX = [OriX imu_EA(k,:)];
        OriY = [OriY imu_EA(k + 1, :)];
        OriZ = [OriZ imu_EA(k + 2, :)];
        OriW = [OriW imu_EA(k + 3, :)];
        AccX = [AccX imu_EA(k + 4, :)];
        AccY = [AccY imu_EA(k + 5, :)];
        AccZ = [AccZ imu_EA(k + 6, :)];
        GyrX = [GyrX imu_EA(k + 7, :)];
        GyrY = [GyrY imu_EA(k + 8, :)];
        GyrZ = [GyrZ imu_EA(k + 9, :)];

        ox = num2cell(OriX);
        oy = num2cell(OriY);
        oz = num2cell(OriZ);
        ow = num2cell(OriW);
        ax = num2cell(AccX);
        ay = num2cell(AccY);
        az = num2cell(AccZ);
        gx = num2cell(GyrX);
        gy = num2cell(GyrY);
        gz = num2cell(GyrZ);

        % insert sensor values
        mat_EA{a,1} = strcat('EatingAction', num2str(a));
        mat_EA{a,2} = ox;
        mat_EA{a,3} = oy;
        mat_EA{a,4} = oz;
        mat_EA{a,5} = ow;
        mat_EA{a,6} = ax;
        mat_EA{a,7} = ay;
        mat_EA{a,8} = az;
        mat_EA{a,9} = gx;
        mat_EA{a,10} = gy;
        mat_EA{a,11} = gz;

        % reset
        a = a + 1;
        OriX = [];
        OriY = [];
        OriZ = [];
        OriW = [];
        AccX = [];
        AccY = [];
        AccZ = [];
        GyrX = [];
        GyrY = [];
        GyrZ = [];
    end

    % move the non-eating actions into a cell array

    a = 1;
    for k=1:10:size(imu_NEA)
    %     fprintf('OriX: %i \n',i);
        OriX = [OriX imu_EA(k,:)];
        OriY = [OriY imu_EA(k + 1, :)];
        OriZ = [OriZ imu_EA(k + 2, :)];
        OriW = [OriW imu_EA(k + 3, :)];
        AccX = [AccX imu_EA(k + 4, :)];
        AccY = [AccY imu_EA(k + 5, :)];
        AccZ = [AccZ imu_EA(k + 6, :)];
        GyrX = [GyrX imu_EA(k + 7, :)];
        GyrY = [GyrY imu_EA(k + 8, :)];
        GyrZ = [GyrZ imu_EA(k + 9, :)];

        ox = num2cell(OriX);
        oy = num2cell(OriY);
        oz = num2cell(OriZ);
        ow = num2cell(OriW);
        ax = num2cell(AccX);
        ay = num2cell(AccY);
        az = num2cell(AccZ);
        gx = num2cell(GyrX);
        gy = num2cell(GyrY);
        gz = num2cell(GyrZ);

        % insert sensor values
        mat_NEA{a,1} = strcat('NonEatingAction', num2str(a));
        mat_NEA{a,2} = ox;
        mat_NEA{a,3} = oy;
        mat_NEA{a,4} = oz;
        mat_NEA{a,5} = ow;
        mat_NEA{a,6} = ax;
        mat_NEA{a,7} = ay;
        mat_NEA{a,8} = az;
        mat_NEA{a,9} = gx;
        mat_NEA{a,10} = gy;
        mat_NEA{a,11} = gz;

        % reset
        a = a + 1;
        OriX = [];
        OriY = [];
        OriZ = [];
        OriW = [];
        AccX = [];
        AccY = [];
        AccZ = [];
        GyrX = [];
        GyrY = [];
        GyrZ = [];
    end

    % save files as .mat files
    % unable to save either a cell array or Table properly into a .csv file

    % tables
    table_EA = cell2table(mat_EA, 'VariableNames', {'EA', 'OriX', 'OriY', 'OriZ', 'OriW', 'AccX', 'AccY', 'AccZ', 'GyrX', 'GyrY', 'GyrZ'});
    table_NEA = cell2table(mat_NEA, 'VariableNames', {'EA', 'OriX', 'OriY', 'OriZ', 'OriW', 'AccX', 'AccY', 'AccZ', 'GyrX', 'GyrY', 'GyrZ'});

    user = list(i,:).name;
    ea_cellarray_file = fullfile(endPath, user + "_IMU_Eating.csv");
    ea_table_file = fullfile(endPath, user + "_IMU_Eating_Table.csv");  
    
    h = array2str(mat_EA{1,2});
    
    disp(ea_cellarray_file);
%     writecell(mat_EA, ea_cellarray_file);
    
    disp(ea_table_file);
%     writetable(table_EA, ea_table_file);


end



disp('end');