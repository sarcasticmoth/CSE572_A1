clear all
clc

% PCA helps distinguish features but keeping features
% that have the maximum distance between eating
% and non-eating actions

workingdir = pwd;
originaldatapath = fullfile(workingdir, "Data", "MyoData");
datapath = fullfile(workingdir, "P2_Data");
endpath = fullfile(workingdir, "A2_P1_UserData");

% make the end folder if does not exist
if ~exist(endpath, 'dir')
    mkdir(endpath);
end

% get list of users
tmp = dir(originaldatapath);
tmp = tmp(~ismember({tmp.name},{'.','..'}));
users = [];
for i=1:size(tmp,1)
    users = [users; cellstr(tmp(i).name)];
end
%disp(users);

% Loop through each user, get eat files for each feature
% Max, Mean, Min, Range, StdDev
ea_max = [];
ea_mean = [];
ea_min = [];
ea_range = [];
ea_stdev = [];
nea_max = [];
nea_mean = [];
nea_min = [];
nea_range = [];
nea_stdev = [];
ea_featurematrix = [];
nea_featurematrix = [];
ea_new_featurematrix = [];
nea_new_featurematrix = [];
train_data = [];
test_data = [];
train_target_data = [];
test_target_data = [];

for i=1:size(users,1)
    user = users{i};
    disp(user);
    
    % Max
    ea_maxfile = fullfile(datapath, "Max", user + "_IMU_Eat.csv");
    ea_max = readmatrix(ea_maxfile);
    nea_maxfile = fullfile(datapath, "Max", user + "_IMU_NotEat.csv");
    nea_max = readmatrix(nea_maxfile);
    
    % Mean
    ea_meanfile = fullfile(datapath, "Mean", user + "_IMU_Eat.csv");
    ea_mean = readmatrix(ea_meanfile);
    nea_meanfile = fullfile(datapath, "Mean", user + "_IMU_NotEat.csv");
    nea_mean = readmatrix(nea_meanfile);
    
    % Min
    ea_minfile = fullfile(datapath, "Min", user + "_IMU_Eat.csv");
    ea_min = readmatrix(ea_minfile);
    nea_minfile = fullfile(datapath, "Min", user + "_IMU_NotEat.csv");
    nea_min = readmatrix(nea_minfile);
    
    % Range
    ea_rangefile = fullfile(datapath, "Range", user + "_IMU_Eat.csv");
    ea_range = readmatrix(ea_rangefile);
    nea_rangefile = fullfile(datapath, "Range", user + "_IMU_NotEat.csv");
    nea_range = readmatrix(nea_rangefile);
    
    % StdDev
    ea_stddevfile = fullfile(datapath, "StdDev", user + "_IMU_Eat.csv");
    ea_stddev = readmatrix(ea_stddevfile);
    nea_stddevfile = fullfile(datapath, "StdDev", user + "_IMU_NotEat.csv");
    nea_stddev = readmatrix(nea_stddevfile);
    
    % create folder
    if ~exist(fullfile(endpath, user), 'dir')
        mkdir(fullfile(endpath, user));
    end
    
    % Feature Matrix   
    ea_featurematrix = [ea_max' ea_mean' ea_min' ea_range' ea_stddev'];
    nea_featurematrix = [nea_max' nea_mean' nea_min' nea_range' nea_stddev'];
    
    fn1 = "Eat_FeatureMatrix.csv";
    fn2 = "NotEat_FeatureMatrix.csv";
    ea_fm_file = fullfile(endpath, user, fn1);
    nea_fm_file = fullfile(endpath, user, fn2);
    
    disp(fn1);
    writematrix(ea_featurematrix, ea_fm_file);
    disp(fn2);
    writematrix(nea_featurematrix, nea_fm_file);
    
    fn3 = "Eat_NewFeatureMatrix.csv";
    fn4 = "NotEat_NewFeatureMatrix.csv";
    ea_new_fm_file = fullfile(endpath, user, fn3);
    nea_new_fm_file = fullfile(endpath, user, fn4);
    
    % PCA
    x = normalize(ea_featurematrix);
    [pca_coeff] = pca(x);
    ea_new_featurematrix = ea_featurematrix * pca_coeff;
    [pca_coeff] = pca(nea_featurematrix);
    nea_new_featurematrix = nea_featurematrix * pca_coeff;
        
    disp(fn3);
    writematrix(ea_new_featurematrix, ea_new_fm_file);
    disp(fn4);
    writematrix(nea_new_featurematrix, nea_new_fm_file);
    
    % creating training data  
    [ea_train_data, ea_valudation, ea_test_data] = dividerand(ea_new_featurematrix', 0.6, 0, 0.4);
    [nea_train_data, nea_valudation, nea_test_data] = dividerand(nea_new_featurematrix', 0.6, 0, 0.4);
    train_data = [ea_train_data'; nea_train_data'];
    test_data = [ea_test_data'; nea_test_data'];
    train_target_data = [ones(size(ea_train_data', 1), 1); zeros(size(nea_train_data', 1), 1)];
    test_target_data = [ones(size(ea_test_data', 1), 1); zeros(size(nea_test_data', 1), 1)];
    
    % save data
    fn5 = "Test_Data.csv";
    fn6 = "Train_Data.csv";
    fn7 = "Train_Test_Data.csv";
    fn8 = "Train_Target_Data.csv";
    
    disp(fn5);
    writematrix(train_data, fullfile(endpath, user, fn5));
    disp(fn6);
    writematrix(test_data, fullfile(endpath, user, fn6));
    disp(fn7);
    writematrix(train_target_data, fullfile(endpath, user, fn7));
    disp(fn8);
    writematrix(test_target_data, fullfile(endpath, user, fn8));
    
    % reset
    ea_max = [];
    ea_mean = [];
    ea_min = [];
    ea_range = [];
    ea_stdev = [];
    nea_max = [];
    nea_mean = [];
    nea_min = [];
    nea_range = [];
    nea_stdev = [];
    ea_featurematrix = [];
    nea_featurematrix = [];
    ea_new_featurematrix = [];
    nea_new_featurematrix = [];
    ea_traindata = [];
    ea_testdata = [];
    nea_traindata = [];
    nea_testdata = [];
    train_data = [];
    test_data = [];
    train_target_data = [];
    test_target_data = [];
end

disp("end");