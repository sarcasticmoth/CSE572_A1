clear all
clc

pIMU = dlmread('1503512024740_IMU.txt');
pEMG = dlmread('1503512024740_EMG.txt');
groundTruthFile = dlmread('1503512024740.txt');

