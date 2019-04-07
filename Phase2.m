% feature extraction

clear all
clc

workingdir = pwd;
P1_DataPath = fullfile(workingdir, 'P1_Data');
endpath = fullfile(workingdir, 'P2_Data');

if ~exist(endPath, 'dir')
    mkdir(endPath);
end

