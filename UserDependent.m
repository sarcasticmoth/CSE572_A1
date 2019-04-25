clear all
clc
% User Dependent Analysis

% read from P2_Data
% for each user, build a feature matrix
% save to new file

% pca for each user
% pca([eat]; [not-eat])
% new feature matrix per user
% seperate 60/40
% Train

workingdir = pwd;
originaldatapath = fullfile(workingdir, "Data", "MyoData");
datapath = fullfile(workingdir, "A2_P1_UserData");
endpath = datapath

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

