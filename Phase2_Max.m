% feature extraction

clear all


workingdir = pwd;
P1_DataPath = fullfile(workingdir, 'P1_Data');
endpath = fullfile(workingdir, 'P2_Data', 'Max');
endpatheatall = fullfile(workingdir, 'P2_Data', 'Eat');
endpathneatall = fullfile(workingdir, 'P2_Data', 'NotEat');

if ~exist(endpath, 'dir')
    mkdir(endpath);
end

if ~exist(endpatheatall, 'dir') | ~exist(endpathneatall, 'dir')
    mkdir(endpatheatall);
    mkdir(endpathneatall);
end

% list of files in the P1 Data Path
% remove folders . and ..
cd(P1_DataPath);
tmp = dir('*.csv');
cd('..');

% create a string array of the file names
list = [];
for i=1:size(tmp, 1)
    list = [list; cellstr(tmp(i).name)];
end

% assume the number of users is half the number of
% files in the P1_Data folder

tmp2 = dir(fullfile(workingdir, 'Data', 'MyoData'));
tmp2 = tmp2(~ismember({tmp2.name},{'.','..'}));
users = [];
for i=1:size(tmp2, 1)
    users = [users; cellstr(tmp2(i).name)];
end

all_ea_max_matrix=[];
all_nea_max_matrix=[];

ea_matrix=[];
nea_matrix=[];

for i=1:size(users, 1)
    userfiles = list(contains(list, users(i,:)));
    
    % eating action data
    eat = userfiles(contains(userfiles, '_Eat'));
    usereatfile = fullfile(P1_DataPath, eat);
    
    % load into matrix
    ea_matrix = readmatrix(usereatfile{1,1});
    
    % mean calculations
    % means of each sensor/column are stored
    ea_imu_max = max(ea_matrix);
    
    all_ea_max_matrix = [all_ea_max_matrix; ea_imu_max];
    
    % non-eating action data
    noneat = userfiles(contains(userfiles, '_NotEat'));
    usernoneatfile = fullfile(P1_DataPath, noneat);
    
    % load into matrix
    nea_matrix = readmatrix(usernoneatfile{1,1});
    
    % mean calculations
    % means of each sensor/column are stored
    nea_imu_max = max(nea_matrix);
    
    all_nea_max_matrix = [all_nea_max_matrix; nea_imu_max];
    
    % save output to file
    user = users(i,:);
    eafileoutput = fullfile(endpath, user + "_" + 'IMU_Eat.csv');
    neafileoutput = fullfile(endpath, user + "_" + 'IMU_NotEat.csv');
    
    disp(eafileoutput);
    writematrix(ea_imu_max, eafileoutput);
    disp(neafileoutput);
    writematrix(nea_imu_max, neafileoutput);
    
end

% save all mean data for all users %
alleafileoutput = fullfile(endpatheatall, 'IMU_Max_Eat.csv');
disp(alleafileoutput);
writematrix(all_ea_max_matrix, alleafileoutput);
allneafileoutput = fullfile(endpathneatall, 'IMU_Max_NotEat.csv');
disp(allneafileoutput);
writematrix(all_nea_max_matrix, allneafileoutput);

% Graph %
endgraphpath = fullfile(workingdir, 'P2_Graphs', 'Max');

if ~exist(endgraphpath, 'dir')
    mkdir(endgraphpath);
end

% the graph will have data from all users per sensor
% eating data vs non-eating data

% variables for graph
sensors = ["OriX", "OriY", "OriZ", "OriW", "AccX", "AccY", "AccZ", "GyroX", "GyroY", "GyroZ"];
u = categorical(users);

labels = ["Eating", "Non-Eating"];

% loop through all the sensors, left to right
% matrices for eating and non-eating are the same size
for i=1:size(all_ea_max_matrix,1)
    eat = all_ea_max_matrix(:,i);
    noteat = all_nea_max_matrix(:,i);
    
    graph = plot(u, eat, 'm');
    hold on;
    graph = plot(u, noteat, 'g');
    title(sensors(i) + " Max");
    legend(labels);
    set(gcf, 'Units', 'Normalized');
    hold off;
    path = fullfile(endgraphpath, sensors(i) + "_max.jpg");
    saveas(graph, path, 'jpg');
end

