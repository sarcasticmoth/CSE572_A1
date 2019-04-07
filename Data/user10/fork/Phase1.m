clear all
clc

pIMU = dlmread('1503512024740_IMU.txt');
pEMG = dlmread('1503512024740_EMG.txt');
vidFile = dlmread('1503512024740.txt');

% to get the eating actions, we use the floor(vidFile(i,1)*(50/30)) and end frame to
% get the rows in IMU where an eating action occurs.
% The frames in between the floor(vidFile(i,2)*(50/30)) end and next floor(vidFile(i,1)*(50/30)) are non-eating actions

% for each row in frame data
%     get floor(vidFile(i,1)*(50/30)) frame, calculate first IMURow
%     get floor(vidFile(i,2)*(50/30)) frame, caulcalte end IMURow
%     Get eating action data
% 
%  for each row in frame data floor(vidFile(i,1)*(50/30)) at 2
%      get floor(vidFile(i,2)*(50/30)) frame, calculate IMURow
%      get first frame from previous row, calculate IMURow
%      get non eating action data

totalFrames = size(vidFile, 1);
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

EAS={};
NEAS={};

for i = 1:totalFrames          
%     OriX = [OriX; {strcat('Eating Action',num2str(eatingAction)),'OriX'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 2)'];
%     OriY = [OriY; {strcat('Eating Action',num2str(eatingAction)),'OriY'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 3)'];
%     OriZ = [OriZ; {strcat('Eating Action',num2str(eatingAction)),'OriZ'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 4)'];
%     OriW = [OriW; {strcat('Eating Action',num2str(eatingAction)),'OriW'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 5)'];
%     AccX = [AccX; {strcat('Eating Action',num2str(eatingAction)),'AccX'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 6)'];
%     AccY = [AccY; {strcat('Eating Action',num2str(eatingAction)),'AccY'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 7)'];
%     AccZ = [AccZ; {strcat('Eating Action',num2str(eatingAction)),'AccZ'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 8)'];
%     GyrX = [GyrX; {strcat('Eating Action',num2str(eatingAction)),'GyrX'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 9)'];
%     GyrY = [GyrY; {strcat('Eating Action',num2str(eatingAction)),'GyrY'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 10)'];
%     GyrZ = [GyrZ; {strcat('Eating Action',num2str(eatingAction)),'GyrZ'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 11)'];
    
    OriX = [OriX pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 2)'];
    OriY = [OriY pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 3)'];
    OriZ = [OriZ pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 4)'];
    OriW = [OriW pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 5)'];
    AccX = [AccX pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 6)'];
    AccY = [AccY pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 7)'];
    AccZ = [AccZ pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 8)'];
    GyrX = [GyrX pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 9)'];
    GyrY = [GyrY pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 10)'];
    GyrZ = [GyrZ pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 11)']; 
    
%     EA = [EA; OriX; OriY; OriZ; OriW; AccX; AccY; AccZ; GyrX; GyrY; GyrZ;]
%     EA = [EA OriX OriY OriZ OriW AccX AccY AccZ GyrX GyrY GyrZ]
	EA = {strcat('Eating Action',num2str(eatingAction)), OriX, OriY, OriZ, OriW, AccX, AccY, AccZ, GyrX, GyrY, GyrZ};
        
    EAS = [EAS; EA];
    
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

% this is the table of Non Eating actions and the IMU data
EAT = cell2table(EAS, 'VariableNames', {'EA', 'OriX', 'OriY', 'OriZ', 'OriW', 'AccX', 'AccY', 'AccZ', 'GyrX', 'GyrY', 'GyrZ'});
% writetable(EAT, '1503512024740_EatingActions_Table.csv');
% writecell(EAS, '1503512024740_EatingActions.csv');

% non-eating actions:
nonEatingAction = 1;

for i = 2:totalFrames       
%     OriX = [OriX; {strcat('Non-Eating Action',num2str(nonEatingAction)),'OriX'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 2)'];
%     OriY = [OriY; {strcat('Non-Eating Action',num2str(nonEatingAction)),'OriY'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 3)'];
%     OriZ = [OriZ; {strcat('Non-Eating Action',num2str(nonEatingAction)),'OriZ'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 4)'];
%     OriW = [OriW; {strcat('Non-Eating Action',num2str(nonEatingAction)),'OriW'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 5)'];
%     AccX = [AccX; {strcat('Non-Eating Action',num2str(nonEatingAction)),'AccX'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 6)'];
%     AccY = [AccY; {strcat('Non-Eating Action',num2str(nonEatingAction)),'AccY'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 7)'];
%     AccZ = [AccZ; {strcat('Non-Eating Action',num2str(nonEatingAction)),'AccZ'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 8)'];
%     GyrX = [GyrX; {strcat('Non-Eating Action',num2str(nonEatingAction)),'GyrX'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 9)'];
%     GyrY = [GyrY; {strcat('Non-Eating Action',num2str(nonEatingAction)),'GyrY'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 10)'];
%     GyrZ = [GyrZ; {strcat('Non-Eating Action',num2str(nonEatingAction)),'GyrZ'}, pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 11)'];
    
    OriX = [OriX pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 2)'];
    OriY = [OriY pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 3)'];
    OriZ = [OriZ pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 4)'];
    OriW = [OriW pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 5)'];
    AccX = [AccX pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 6)'];
    AccY = [AccY pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 7)'];
    AccZ = [AccZ pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 8)'];
    GyrX = [GyrX pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 9)'];
    GyrY = [GyrY pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 10)'];
    GyrZ = [GyrZ pIMU(floor(vidFile(i,1)*(50/30)):floor(vidFile(i,2)*(50/30)), 11)'];
       
%   NEA = [EA; OriX; OriY; OriZ; OriW; AccX; AccY; AccZ; GyrX; GyrY; GyrZ;]
%   NEA = [EA OriX OriY OriZ OriW AccX AccY AccZ GyrX GyrY GyrZ]
	NEA = {strcat('Non Eating Action',num2str(nonEatingAction)), OriX, OriY, OriZ, OriW, AccX, AccY, AccZ, GyrX, GyrY, GyrZ};
        
    NEAS = [NEAS; NEA];
    
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

% this is the table of Non Eating actions and the IMU data
NEAT = cell2table(NEAS, 'VariableNames', {'EA', 'OriX', 'OriY', 'OriZ', 'OriW', 'AccX', 'AccY', 'AccZ', 'GyrX', 'GyrY', 'GyrZ'});
% writecell(NEAS, '1503512024740_NonEatingActions.csv');
% writetable(NEAT, '1503512024740_NonEatingActions_Table.csv');

% sample, get OriX values for EA1
x = EAT.OriX{1,1};
y = NEAT.OriX{1,1};

hold off;



