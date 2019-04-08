clear all
clc

% PCA helps distinguish features but keeping features
% that have the maximum distance between eating
% and non-eating actions

workigndir = pwd
endpath = fullfile(workingdir, "P3_Data");
pcaendpath = fullfile(endpath, "PCA");

if ~exist(endpath, 'dir')
    mkdir(endpath);
    mkdir(pcaendpath);
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

% build the feature matrix
% each matrix is per user


