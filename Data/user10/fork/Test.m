clear all
clc

pIMU = dlmread('1503512024740_IMU.txt');
pEMG = dlmread('1503512024740_EMG.txt');
vidFile = dlmread('1503512024740.txt');

% size(a,b) where a is rows and b is columns
% size(pIMU) = 24297 11

EA1 = [];
% 2 to 11
for i = 2:size(pIMU,2)
    % orientation X
    EA1 = [EA1 pIMU(floor(vidFile(1,1)*50/30):floor(vidFile(1,2)*50/30),i)'];
end
for i = 1:8
    EA1 = [EA1 pEMG(floor(vidFile(1,1)*200/30):floor(vidFile(1,2)*200/30),i+1)'];
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

% append zeros
%EA1 = [EA1 zeros(1, 5554-3226)];

% graphs
% plot(pIMU(floor(vidFile(1,2)*50/30):floor(vidFile(1,2)*50/30),i));
% plot(pIMU(floor(vidFile(2,2)*50/30):floor(vidFile(2,2)*50/30),i));

% fast fourier transform (FFT)
OriXFFT = fft(pIMU(floor(vidFile(1,1)*50/30):floor(vidFile(1,2)*50/30),i));

% absolute value
absOriXFFT = abs(OriXFFT);
% figure;plot(absOriXFFT);

% take 25-35 from FFT

%explanations by including graphs in reports

% create new feature matrix
newFFTFeatureEA1 = abs(OriXFFT(25:35));

% mean of OriX
meanOriX = mean(pIMU(floor(vidFile(1,1)*50/30):floor(vidFile(1,2)*50/30),i));

% feature
% feature
% feature

% first eating action of user 10
%[newFFTFeatureA1 meanOriX -rest of features-];
FEA1 = [newFFTFeatureA1 meanOriX];

% second eating action of user 10
FEA2 = [];

% third eating action of user 10
FEA3 = [];

%
%
%

MatrixOfFeaturesU1 = [FEA1 FEA2 FEA3];

MatrixOfFeaturesU2 = [];

MatrixOfFeaturesU3 = [];






