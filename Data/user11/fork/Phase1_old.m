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

% EMG1=[];
% EMG2=[];
% EMG3=[];
% EMG4=[];
% EMG5=[];
% EMG6=[];
% EMG7=[];
% EMG8=[];

EA=[];

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
       
%     % first column
% 	emgStart = floor(groundTruthFile(i,1)*(200/30));
%     % second column
%     emgLast = floor(groundTruthFile(i,2)*(200/30));
%     
%     if(emgStart < size(pEMG,1))
%         EMG1=[EMG1; {strcat('Eating Action',num2str(eatingAction)),'EMG1'}, pEMG(emgStart:emgLast, 2)'];
%         EMG2=[EMG2; {strcat('Eating Action',num2str(eatingAction)),'EMG2'}, pEMG(emgStart:emgLast, 3)'];
%         EMG3=[EMG3; {strcat('Eating Action',num2str(eatingAction)),'EMG3'}, pEMG(emgStart:emgLast, 4)'];
%         EMG4=[EMG4; {strcat('Eating Action',num2str(eatingAction)),'EMG4'}, pEMG(emgStart:emgLast, 5)'];
%         EMG5=[EMG5; {strcat('Eating Action',num2str(eatingAction)),'EMG5'}, pEMG(emgStart:emgLast, 6)'];
%         EMG6=[EMG6; {strcat('Eating Action',num2str(eatingAction)),'EMG6'}, pEMG(emgStart:emgLast, 7)'];
%         EMG7=[EMG7; {strcat('Eating Action',num2str(eatingAction)),'EMG7'}, pEMG(emgStart:emgLast, 8)'];
%         EMG8=[EMG8; {strcat('Eating Action',num2str(eatingAction)),'EMG8'}, pEMG(emgStart:emgLast, 9)'];
%     end
      
%     EA = [EA; OriX; OriY; OriZ; OriW; AccX; AccY; AccZ; GyrX; GyrY; GyrZ; EMG1; EMG2; EMG3; EMG4; EMG5; EMG6; EMG7; EMG8;]
%     EA = [EA; OriX; OriY; OriZ; OriW; AccX; AccY; AccZ; GyrX; GyrY; GyrZ;]
     EA = [EA OriX OriY OriZ OriW AccX AccY AccZ GyrX GyrY GyrZ]
    
    % reset variables
    eatingAction = eatingAction + 1;
    
%     OriX=[];
%     OriY=[];
%     OriZ=[];
%     OriW=[];
%     AccX=[];
%     AccY=[];
%     AccZ=[];
%     GyrX=[];
%     GyrY=[];
%     GyrZ=[];

%     EMG1=[];
%     EMG2=[];
%     EMG3=[];
%     EMG4=[];
%     EMG5=[];
%     EMG6=[];
%     EMG7=[];
%     EMG8=[];

end

% graph each measurement over time
% figure('Name','OriX');plot(OriX);
% figure('Name','OriY');plot(OriY);
% figure('Name','OriZ');plot(OriZ);
% figure('Name','OriW');plot(OriW);
% figure('Name','AccX');plot(AccX);
% figure('Name','AccY');plot(AccY);
% figure('Name','AccZ');plot(AccZ);
% figure('Name','GyrX');plot(GyrX);
% figure('Name','GyrY');plot(GyrY);
% figure('Name','GyrZ');plot(GyrZ);
