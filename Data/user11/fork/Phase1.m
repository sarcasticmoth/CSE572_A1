clear all
clc

pIMU = dlmread('1503513662628_IMU.txt');
pEMG = dlmread('1503513662628_EMG.txt');
groundTruthFile = dlmread('1503513662628.txt');

% to get the eating actions, we use the start and end frame to
% get the rows in IMU where an eating action occurs.
% The frames in between the last end and next start are non-eating actions

% for each row in frame data
%     get start frame, calculate first IMURow
%     get last frame, caulcalte end IMURow
%     Get eating action data
% 
%  for each row in frame data start at 2
%      get last frame, calculate IMURow
%      get first frame from previous row, calculate IMURow
%      get non eating action data

totalFrames = size(groundTruthFile, 1);
eatingAction = 1;

OriX=[];
OriY=[];
OriZ=[];
OriW=[];
AccX=[];
AccY=[];
AccZ=[];
GyrX=[];
GyrY=[];
GyrZ=[];

EA=[];
NEA=[];

for i = 1:totalFrames
    % first column
	start = floor(groundTruthFile(i,1)*(50/30));
    % second column
    last = floor(groundTruthFile(i,2)*(50/30));
        
%     OriX = [OriX; {strcat('Eating Action',num2str(eatingAction)),'OriX'}, pIMU(start:last, 2)'];
%     OriY = [OriY; {strcat('Eating Action',num2str(eatingAction)),'OriY'}, pIMU(start:last, 3)'];
%     OriZ = [OriZ; {strcat('Eating Action',num2str(eatingAction)),'OriZ'}, pIMU(start:last, 4)'];
%     OriW = [OriW; {strcat('Eating Action',num2str(eatingAction)),'OriW'}, pIMU(start:last, 5)'];
%     AccX = [AccX; {strcat('Eating Action',num2str(eatingAction)),'AccX'}, pIMU(start:last, 6)'];
%     AccY = [AccY; {strcat('Eating Action',num2str(eatingAction)),'AccY'}, pIMU(start:last, 7)'];
%     AccZ = [AccZ; {strcat('Eating Action',num2str(eatingAction)),'AccZ'}, pIMU(start:last, 8)'];
%     GyrX = [GyrX; {strcat('Eating Action',num2str(eatingAction)),'GyrX'}, pIMU(start:last, 9)'];
%     GyrY = [GyrY; {strcat('Eating Action',num2str(eatingAction)),'GyrY'}, pIMU(start:last, 10)'];
%     GyrZ = [GyrZ; {strcat('Eating Action',num2str(eatingAction)),'GyrZ'}, pIMU(start:last, 11)'];
    
    OriX = [OriX pIMU(start:last, 2)'];
    OriY = [OriY pIMU(start:last, 3)'];
    OriZ = [OriZ pIMU(start:last, 4)'];
    OriW = [OriW pIMU(start:last, 5)'];
    AccX = [AccX pIMU(start:last, 6)'];
    AccY = [AccY pIMU(start:last, 7)'];
    AccZ = [AccZ pIMU(start:last, 8)'];
    GyrX = [GyrX pIMU(start:last, 9)'];
    GyrY = [GyrY pIMU(start:last, 10)'];
    GyrZ = [GyrZ pIMU(start:last, 11)'];
       
%     EA = [EA; OriX; OriY; OriZ; OriW; AccX; AccY; AccZ; GyrX; GyrY; GyrZ;]
%     EA = [EA OriX OriY OriZ OriW AccX AccY AccZ GyrX GyrY GyrZ]
    EA = [EA;OriX];
    EA = [EA OriY];
    EA = [EA OriZ];
    EA = [EA OriW];
    EA = [EA AccX];
    EA = [EA AccY];
    EA = [EA AccZ];
    EA = [EA GyrX];
    EA = [EA GyrY];
    EA = [EA GyrZ];
    
    % reset variables
    eatingAction = eatingAction + 1;
    
    OriX=[];
    OriY=[];
    OriZ=[];
    OriW=[];
    AccX=[];
    AccY=[];
    AccZ=[];
    GyrX=[];
    GyrY=[];
    GyrZ=[];

end

eatingAction = 1;

% graph each measurement over time
% figure('Name','EA_OriX');plot(OriX);
% figure('Name','EA_OriY');plot(OriY);
% figure('Name','EA_OriZ');plot(OriZ);
% figure('Name','EA_OriW');plot(OriW);
% figure('Name','EA_AccX');plot(AccX);
% figure('Name','EA_AccY');plot(AccY);
% figure('Name','EA_AccZ');plot(AccZ);
% figure('Name','EA_GyrX');plot(GyrX);
% figure('Name','EA_GyrY');plot(GyrY);
% figure('Name','EA_GyrZ');plot(GyrZ);

% non-eating actions:
nonEatingAction = 1;

for i = 2:totalFrames
    % first column
	start = floor(groundTruthFile(i - 1, 2)*(50/30));
    % second column
    last = floor(groundTruthFile(i,1)*(50/30));
        
    OriX = [OriX; {strcat('Non-Eating Action',num2str(nonEatingAction)),'OriX'}, pIMU(start:last, 2)'];
    OriY = [OriY; {strcat('Non-Eating Action',num2str(nonEatingAction)),'OriY'}, pIMU(start:last, 3)'];
    OriZ = [OriZ; {strcat('Non-Eating Action',num2str(nonEatingAction)),'OriZ'}, pIMU(start:last, 4)'];
    OriW = [OriW; {strcat('Non-Eating Action',num2str(nonEatingAction)),'OriW'}, pIMU(start:last, 5)'];
    AccX = [AccX; {strcat('Non-Eating Action',num2str(nonEatingAction)),'AccX'}, pIMU(start:last, 6)'];
    AccY = [AccY; {strcat('Non-Eating Action',num2str(nonEatingAction)),'AccY'}, pIMU(start:last, 7)'];
    AccZ = [AccZ; {strcat('Non-Eating Action',num2str(nonEatingAction)),'AccZ'}, pIMU(start:last, 8)'];
    GyrX = [GyrX; {strcat('Non-Eating Action',num2str(nonEatingAction)),'GyrX'}, pIMU(start:last, 9)'];
    GyrY = [GyrY; {strcat('Non-Eating Action',num2str(nonEatingAction)),'GyrY'}, pIMU(start:last, 10)'];
    GyrZ = [GyrZ; {strcat('Non-Eating Action',num2str(nonEatingAction)),'GyrZ'}, pIMU(start:last, 11)'];
    
%     OriX = [OriX pIMU(start:last, 2)'];
%     OriY = [OriY pIMU(start:last, 3)'];
%     OriZ = [OriZ pIMU(start:last, 4)'];
%     OriW = [OriW pIMU(start:last, 5)'];
%     AccX = [AccX pIMU(start:last, 6)'];
%     AccY = [AccY pIMU(start:last, 7)'];
%     AccZ = [AccZ pIMU(start:last, 8)'];
%     GyrX = [GyrX pIMU(start:last, 9)'];
%     GyrY = [GyrY pIMU(start:last, 10)'];
%     GyrZ = [GyrZ pIMU(start:last, 11)'];
       
%     NEA = [EA; OriX; OriY; OriZ; OriW; AccX; AccY; AccZ; GyrX; GyrY; GyrZ;]
%     NEA = [EA OriX OriY OriZ OriW AccX AccY AccZ GyrX GyrY GyrZ]
    
    % reset variables
    nonEatingAction = nonEatingAction + 1;
    
    OriX=[];
    OriY=[];
    OriZ=[];
    OriW=[];
    AccX=[];
    AccY=[];
    AccZ=[];
    GyrX=[];
    GyrY=[];
    GyrZ=[];

end

nonEatingAction = 1;

% graph each measurement over time
% figure('Name','NEA_OriX');plot(OriX);
% figure('Name','NEA_OriY');plot(OriY);
% figure('Name','NEA_OriZ');plot(OriZ);
% figure('Name','NEA_OriW');plot(OriW);
% figure('Name','NEA_AccX');plot(AccX);
% figure('Name','NEA_AccY');plot(AccY);
% figure('Name','NEA_AccZ');plot(AccZ);
% figure('Name','NEA_GyrX');plot(GyrX);
% figure('Name','NEA_GyrY');plot(GyrY);
% figure('Name','NEA_GyrZ');plot(GyrZ);
