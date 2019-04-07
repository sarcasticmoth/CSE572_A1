% feature extraction

clear all
clc

workingdir = pwd;
P1_DataPath = fullfile(workingdir, 'P1_Data');
endpath = fullfile(workingdir, 'P2_Data');

if ~exist(endpath, 'dir')
    mkdir(endpath);
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

% loop through users
% get eat data and non-eat data per user
% use xlsread(file, A:A) to pull columns

% take max
% normalize
% save result