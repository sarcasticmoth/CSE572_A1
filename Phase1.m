clear all
clc

% file variables
workingDir = pwd;
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
% should return 10 users/folders
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
        
        imu_EA = [imu_EA; found];      
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
        
        imu_NEA = [imu_NEA; found];
    end
    
    % matrices are organized in this way:
    % for all actions for a user
    % OriX OriY OriZ OriW AccX AccY AccZ GyroX GyroY GyroZ

    % save to files
    user = list(i,:).name;
    EAfile = fullfile(endPath, user + "_" + 'IMU_Eat.csv');
    NEAfile = fullfile(endPath, user + "_" + 'IMU_NotEat.csv');
    
    disp(EAfile);
    writematrix(imu_EA, EAfile);
    disp(NEAfile);
    writematrix(imu_NEA, NEAfile);
end



disp('end');