clear all
clc

% PCA helps distinguish features but keeping features
% that have the maximum distance between eating
% and non-eating actions

workingdir = pwd
endpath = fullfile(workingdir, "P3_Data");
pcaendpath = fullfile(endpath, "PCA");
training_endpath = fullfile(workingdir, "A2_P1_UserData");

P2_datapath = fullfile(workingdir, "P2_Data");
P2_eat = fullfile(P2_datapath, "Eat");
P2_neat = fullfile(P2_datapath, "NotEat");

if ~exist(endpath, 'dir')
    mkdir(endpath);
end
if ~exist(training_endpath, 'dir')
    mkdir(training_endpath);
end
if ~exist(pcaendpath, 'dir')
    mkdir(pcaendpath);
end

% list of files in the P2 Eat
% remove folders . and ..
cd(P2_eat);
tmp = dir('*.csv');
cd('..\..');

cd(P2_neat);
tmp2 = dir('*.csv');
cd('..\..');

tmp3 = dir(fullfile(workingdir, 'Data', 'MyoData'));
tmp3 = tmp3(~ismember({tmp3.name},{'.','..'}));

% create a string array of the file names
eatfiles = [];
for i=1:size(tmp, 1)
    eatfiles = [eatfiles; cellstr(tmp(i).name)];
end
neatfiles = [];
for i=1:size(tmp2, 1)
    neatfiles = [neatfiles; cellstr(tmp2(i).name)];
end

users = [];
for i=1:size(tmp3, 1)
    users = [users; cellstr(tmp3(i).name)];
end

% build the feature matrix
% each matrix is per user

ea_feature_matrix=[];
ea_max_matrix=[];
ea_mean_matrix=[];
ea_min_matrix=[];
ea_range_matrix=[];
ea_stddev_matrix=[];

for i = 1:size(eatfiles,1)
    
    p = fullfile(P2_eat, eatfiles(i));
    
    if contains(eatfiles(i), 'Max')
        ea_max_matrix = readmatrix(p);
    end
    if contains(eatfiles(i), 'Mean')
        ea_mean_matrix = readmatrix(p);
    end
    if contains(eatfiles(i), 'Min')
        ea_min_matrix = readmatrix(p);
    end
    if contains(eatfiles(i), 'Range')
        ea_range_matrix = readmatrix(p);
    end
    if contains(eatfiles(i), 'StdDev')
        ea_stddev_matrix = readmatrix(p);
    end
end

ea_max_matrix_app=[];
ea_mean_matrix_app=[];
ea_min_matrix_app=[];
ea_range_matrix_app=[];
ea_stddev_matrix_app=[];

% all the matrices are the same size
for i = 1:size(ea_max_matrix, 1)
    ea_max_matrix_app = [ea_max_matrix_app ea_max_matrix(i,:)];
    ea_mean_matrix_app = [ea_mean_matrix_app ea_mean_matrix(i,:)];
    ea_min_matrix_app = [ea_min_matrix_app ea_min_matrix(i,:)];
    ea_range_matrix_app = [ea_range_matrix_app ea_range_matrix(i,:)];
    ea_stddev_matrix_app = [ea_stddev_matrix_app ea_stddev_matrix(i,:)];
end

% create the feature matrix
ea_feature_matrix = [ea_max_matrix_app' ea_mean_matrix_app' ea_min_matrix_app' ea_range_matrix_app' ea_stddev_matrix_app'];

% PCA
y = normalize(ea_feature_matrix);
[pca_ea_coeff, pca_ea_score, pca_ea_latent] = pca(y);

% coeff - eigenvectors
% latent - eigenvalues

nea_feature_matrix=[];
nea_max_matrix=[];
nea_mean_matrix=[];
nea_min_matrix=[];
nea_range_matrix=[];
nea_stddev_matrix=[];

for i = 1:size(neatfiles,1)
    
    p = fullfile(P2_neat, neatfiles(i));
    
    if contains(neatfiles(i), 'Max')
        nea_max_matrix = readmatrix(p);
    end
    if contains(neatfiles(i), 'Mean')
        nea_mean_matrix = readmatrix(p);
    end
    if contains(neatfiles(i), 'Min')
        nea_min_matrix = readmatrix(p);
    end
    if contains(neatfiles(i), 'Range')
        nea_range_matrix = readmatrix(p);
    end
    if contains(neatfiles(i), 'StdDev')
        nea_stddev_matrix = readmatrix(p);
    end
end

nea_max_matrix_app=[];
nea_mean_matrix_app=[];
nea_min_matrix_app=[];
nea_range_matrix_app=[];
nea_stddev_matrix_app=[];

for i = 1:size(nea_max_matrix, 1)
    nea_max_matrix_app = [nea_max_matrix_app nea_max_matrix(i,:)];
end
for i = 1:size(nea_mean_matrix, 1)
    nea_mean_matrix_app = [nea_mean_matrix_app nea_mean_matrix(i,:)];
end
for i = 1:size(nea_min_matrix, 1)
    nea_min_matrix_app = [nea_min_matrix_app nea_min_matrix(i,:)];
end
for i = 1:size(nea_range_matrix, 1)
    nea_range_matrix_app = [nea_range_matrix_app nea_range_matrix(i,:)];
end
for i = 1:size(nea_stddev_matrix, 1)
    nea_stddev_matrix_app = [nea_stddev_matrix_app nea_stddev_matrix(i,:)];
end 

% create the feature matrix
nea_feature_matrix = [nea_max_matrix_app' nea_mean_matrix_app' nea_min_matrix_app' nea_range_matrix_app' nea_stddev_matrix_app'];

% PCA
x = normalize(nea_feature_matrix);
[pca_nea_coeff, pca_nea_score, pca_nea_latent] = pca(x);

% new feature matrix
new_ea_feature_matrix = ea_feature_matrix * pca_ea_coeff;
new_nea_feature_matrix = nea_feature_matrix * pca_nea_coeff;

% create training and testing data sets
[ea_train_data, ea_validation, ea_test_data] = dividerand(new_ea_feature_matrix', 0.6, 0, 0.4);
[nea_train_data, nea_validation, nea_test_data] = dividerand(new_nea_feature_matrix', 0.6, 0, 0.4);
%train_data = [ea_train_data'; nea_train_data'];
%test_data = [ea_test_data'; nea_test_data'];
%train_target_data = [ones(size(ea_train_data', 1), 1); zeros(size(nea_train_data', 1), 1)]
%test_target_data = [ones(size(ea_test_data', 1), 1); zeros(size(nea_test_data', 1), 1)]

%fn1 = "Train_Data.csv";
%fn2 = "Test_Data.csv";
%fn3 = "Train_Target_Data.csv";
%fn4 = "Train_Test_Data.csv";
fn1 = "Eat_Train_Data.csv";
fn2 = "Eat_Test_Data.csv";
fn3 = "NotEat_Train_Data.csv";
fn4 = "NotEat_Test_Data.csv";

disp(fn1);
writematrix(ea_train_data', fullfile(training_endpath, fn1));
disp(fn2);
writematrix(ea_test_data', fullfile(training_endpath, fn2));
disp(fn3);
writematrix(nea_train_data', fullfile(training_endpath, fn3));
disp(fn4);
writematrix(nea_test_data', fullfile(training_endpath, fn4));

%disp(fn1);
%writematrix(train_data, fullfile(training_endpath, fn1));
%disp(fn2);
%writematrix(test_data, fullfile(training_endpath, fn2));
%disp(fn3);
%writematrix(train_target_data, fullfile(training_endpath, fn3));
%disp(fn4);
%writematrix(test_target_data, fullfile(training_endpath, fn4));

% graphs
%graph1 = plot(pca_ea_latent);
%title("Eigenvalues Eating Actions");
%path = fullfile(pcaendpath, "EA_EG.jpg");
%saveas(graph1, path, 'jpg');

%graph2 = plot(pca_nea_latent);
%title("Eigenvalues Non-Eating Actions");
%path = fullfile(pcaendpath, "NEA_EG.jpg");
%saveas(graph2, path, 'jpg');

%graph3 = spider(pca_ea_coeff, 'EA Eigenvectors', [], [], {'Max', 'Mean', 'Min', 'Range', 'Std Dev'});
%graph4 = spider(pca_nea_coeff, 'NEA Eigenvectors', [], [], {'Max', 'Mean', 'Min', 'Range', 'Std Dev'});

%path = fullfile(pcaendpath, "EA_EG_spider.jpg");
%saveas(graph3, path, 'jpg');
%path = fullfile(pcaendpath, "NEA_EG_spider.jpg");
%saveas(graph4, path, 'jpg');

% plots with new feature matrix and 3 principal components
%for i=1:3 
%    subplot(3,1,i);
%    hold on;
%    graph5 = plot(ea_feature_matrix(:,i) * pca_ea_coeff(i));
%    graph5 = plot(nea_feature_matrix(:,i) * pca_nea_coeff(i));
%    legend('Eating', 'Non-Eating');
%end

%path = fullfile(pcaendpath, "PrinCompGraphs.jpg");
%saveas(graph5, path, 'jpg');
