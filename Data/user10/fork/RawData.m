clear all
clc

pIMU = readmatrix('1503512024740_IMU.txt');
pEMG = readmatrix('1503512024740_EMG.txt');
pVID = readmatrix('1503512024740.txt');

% create a matrix of 'converted' frame values to sample values from the 
% ground truth file
matrixFrames = pVID(:,1:2);
matrixFramesData = floor(matrixFrames * (50/30));

ea_EMG = [];
nea_EMG = [];
ea_IMU = [];
nea_IMU = [];

ea_OriX=[];
ea_OriY=[];
ea_OriZ=[];
ea_OriW=[];
ea_AccX=[];
ea_AccY=[];
ea_AccZ=[];
ea_GyrX=[];
ea_GyrY=[];
ea_GyrZ=[];

nea_OriX=[];
nea_OriY=[];
nea_OriZ=[];
nea_OriW=[];
nea_AccX=[];
nea_AccY=[];
nea_AccZ=[];
nea_GyrX=[];
nea_GyrY=[];
nea_GyrZ=[];

action = 1;

for i=1:size(matrixFramesData,1)
    s = matrixFramesData(i,1);
    e = matrixFramesData(i,2);
    
    ea_OriX = [ea_OriX pIMU(s:e,2)'];
    ea_OriY = [ea_OriY pIMU(s:e,3)'];
    ea_OriZ = [ea_OriZ pIMU(s:e,4)'];
    ea_OriW = [ea_OriW pIMU(s:e,5)'];
    ea_AccX = [ea_AccX pIMU(s:e,6)'];
    ea_AccY = [ea_AccY pIMU(s:e,7)'];
    ea_AccZ = [ea_AccZ pIMU(s:e,8)'];
    ea_GyrX = [ea_GyrX pIMU(s:e,9)'];
    ea_GyrY = [ea_GyrY pIMU(s:e,10)'];
    ea_GyrZ = [ea_GyrZ pIMU(s:e,11)'];
    
    ea_IMU = [ea_IMU, ea_OriX; ea_OriY; ea_OriZ; ea_OriW; ea_AccX; ea_AccY; ea_AccZ; ea_GyrX; ea_GyrY; ea_GyrZ;];
    action = action + 1;
end