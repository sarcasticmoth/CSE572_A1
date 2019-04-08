%graphs%

clear all
clc

EA = 'C:\Users\rando\OneDrive\Graduate School\SPRING 2019\CSE572_Data_Mining\CSE572_A1\P1_Data\user10_IMU_Eat.csv'
NEA = 'C:\Users\rando\OneDrive\Graduate School\SPRING 2019\CSE572_Data_Mining\CSE572_A1\P1_Data\user10_IMU_NotEat.csv'

EA_matrix = readmatrix(EA);
NEA_matrix = readmatrix(NEA);

EA_OriX = EA_matrix(:,1);
EA_OriY = EA_matrix(:,2);
EA_OriZ = EA_matrix(:,3);
EA_OriW = EA_matrix(:,4);
EA_AccX = EA_matrix(:,5);
EA_AccY = EA_matrix(:,6);
EA_AccZ = EA_matrix(:,7);
EA_GyroX = EA_matrix(:,8);
EA_GyroY = EA_matrix(:,9);
EA_GyroZ = EA_matrix(:,10);

NEA_OriX = NEA_matrix(:,1);
NEA_OriY = NEA_matrix(:,2);
NEA_OriZ = NEA_matrix(:,3);
NEA_OriW = NEA_matrix(:,4);
NEA_AccX = NEA_matrix(:,5);
NEA_AccY = NEA_matrix(:,6);
NEA_AccZ = NEA_matrix(:,7);
NEA_GyroX = NEA_matrix(:,8);
NEA_GyroY = NEA_matrix(:,9);
NEA_GyroZ = NEA_matrix(:,10);

%plot of OriX
plot(EA_matrix);
hold on;
% plot(NEA_matrix);
% hold off;
% legend({'EA Accx','NEA AccX'});



