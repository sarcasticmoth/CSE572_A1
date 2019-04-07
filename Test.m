clear all
clc

pIMU = dlmread('C:\Users\rando\OneDrive\Graduate School\SPRING 2019\CSE572_Data_Mining\CSE572_A1\Data\MyoData\user10\fork\1503512024740_IMU.txt');
pEMG = dlmread('C:\Users\rando\OneDrive\Graduate School\SPRING 2019\CSE572_Data_Mining\CSE572_A1\Data\MyoData\user10\fork\1503512024740_EMG.txt');
vidFile = dlmread('C:\Users\rando\OneDrive\Graduate School\SPRING 2019\CSE572_Data_Mining\CSE572_A1\Data\groundTruth\user10\fork\1503512024740.txt');

% size(a,b) where a is rows and b is columns
% size(pIMU) = 24297 11

% IMU columns
% 2 - OriX
% 3 - OriY
% 4 - OriZ
% 5 - OriW
% 6 - AccX
% 7 - AccY
% 8 - AccZ
% 9 - GyroX
% 10 - GyroY
% 11 - GyroZ

EA1 = [];
% 2 to 11, eat of the IMU
for i = 2:size(pIMU,2)
    EA1 = [EA1; pIMU(floor(vidFile(1,1)*50/30):floor(vidFile(1,2)*50/30),i)'];
end
for i = 1:8
    EA1 = [EA1; pEMG(floor(vidFile(1,1)*200/30):floor(vidFile(1,2)*200/30),i+1)'];
end

EA2 = [];
for i = 2:size(pIMU,2)
    EA2 = [EA2 pIMU(floor(vidFile(2,1)*50/30):floor(vidFile(2,2)*50/30),i)'];
end
for i = 1:8
    EA2 = [EA2 pEMG(floor(vidFile(2,1)*200/30):floor(vidFile(2,2)*200/30),i+1)'];
end

nEA1 = [];
for i = 2:size(pIMU,2)
    nEA1 = [nEA1 pIMU(floor(vidFile(1,2)*50/30):floor(vidFile(2,1)*50/30),i)'];
end
for i = 1:8
    nEA1 = [nEA1 pEMG(floor(vidFile(1,2)*200/30):floor(vidFile(2,2)*200/30),i+1)'];
end

nEA2 = [];
for i = 2:size(pIMU,2)
    nEA2 = [nEA2 pIMU(floor(vidFile(2,2)*50/30):floor(vidFile(3,1)*50/30),i)'];
end
for i = 1:8
    nEA2 = [nEA2 pEMG(floor(vidFile(2,2)*200/30):floor(vidFile(3,2)*200/30),i+1)'];
end

% Eating actions should be the same length
EA1 = [EA1 zeros(1, 5554-3226)];

% Second Part:
% manually plot the signals and try to visualize the unique characteristics

% orientation X (OriX)
% plot(pIMU(floor(vidFile(2,1)*50/30):floor(vidFile(2,2)*50/30),i));

% take orientation X on the second row (EA2)
    % time domain to frequency domain %
EA2OriXFFT = fft(pIMU(floor(vidFile(2,1)*50/30):floor(vidFile(2,2)*50/30),i));
EA2absOriXFFT = abs(EA2OriXFFT);

% only need values 25-25 from absOriXFFT for the feature
EA2newFFTFeature = abs(EA2OriXFFT(25:35));

% mean of this feature (use raw data)
% why the mean? explain using graphs in the report
EA2MeanOriX = mean(pIMU(floor(vidFile(2,1)*50/30):floor(vidFile(2,2)*50/30),i));

% other features....
EA1OriXFFT = fft(pIMU(floor(vidFile(1,1)*50/30):floor(vidFile(1,2)*50/30),i));
EA1newFFTFeature = abs(EA1OriXFFT(25:35));
EA1MeanOriX = mean(pIMU(floor(vidFile(1,1)*50/30):floor(vidFile(1,2)*50/30),i));

% Feature Matrix per EA
FEA1 = [EA1newFFTFeature; EA1MeanOriX];
FEA2 = [EA2newFFTFeature; EA2MeanOriX];
FEA3 = [];
FEA4 = [];

% Matrix of Features for this User
MatFeaturesU1 = [FEA1; FEA2; FEA3;];
MatFeaturesU2 = [];
MatFeaturesU3 = [];

% can pass MatFeaturesU1 to PCA

% or big matrix to PCA
BigMatrix = [MatFeaturesU1; MatFeaturesU2; MatFeaturesU3;];

disp('end');
