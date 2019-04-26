clear all
clc

% User Independent %

workingdir = pwd;
datapath = fullfile(workingdir, "A2_P1_UserData");
endpath = fullfile(workingdir, "A2_Training");

% make the end folder if does not exist
if ~exist(endpath, 'dir')
    mkdir(endpath);
end

% get list of users
tmp = dir(datapath);
tmp = tmp(~ismember({tmp.name},{'.','..','Target_Data.csv', 'Test_Data.csv', 'Train_Data.csv'}));
users = [];
for i=1:size(tmp,1)
    users = [users; cellstr(tmp(i).name)];
end
%disp(users);

%for i=1:size(users,1)
%    user = users{i};
%    disp(user);    
%end

% Training and Testing
train_data = readmatrix(fullfile(datapath, "Train_Data.csv"));
test_data = readmatrix(fullfile(datapath, "Test_Data.csv"));
train_target_data = readmatrix(fullfile(datapath, "Train_Target_Data.csv"));
test_target_data = readmatrix(fullfile(datapath, "Train_Test_Data.csv"));

% NN
net = feedforwardnet(10);
net = train(net, train_data', train_target_data');
nn = sim(net, test_data');
nn(nn >= 0.5) = 1;
nn(nn < 0.5) = 0;
[confusion_matrix, ~] = confusionmat(nn, test_target_data');

% calculate precision
for i=1:size(confusion_matrix,1)
    precision(i) = confusion_matrix(i,i) / sum(confusion_matrix(i,:));
end

nn_precision = sum(precision) / size(confusion_matrix, 1);

% calculate recall
for i=size(confusion_matrix, 1)
    recall(i) = confusion_matrix(i,i) / sum(confusion_matrix(:, i));
end

nn_recall = sum(recall)/size(confusion_matrix, 1);
nn_fscore = 2 * nn_recall * nn_precision / (nn_precision + nn_recall)

% graph %
view(net)

%
% decision trees
%
dtree = fitctree(train_data, train_target_data);
dt = predict(dtree, test_data);

[confusion_matrix, ~] = confusionmat(dt, test_target_data);

% calculate precision
for i=1:size(confusion_matrix,1)
    precision(i) = confusion_matrix(i,i) / sum(confusion_matrix(i,:));
end

dt_precision = sum(precision) / size(confusion_matrix, 1);

% calculate recall
for i=size(confusion_matrix, 1)
    recall(i) = confusion_matrix(i,i) / sum(confusion_matrix(:, i));
end

dt_recall = sum(recall)/size(confusion_matrix, 1);
dt_fscore = 2 * dt_recall * dt_precision / (dt_precision + dt_recall)

% graph %
view(dtree);
view(dtree, 'mode', 'graph');

%
% SVM
%   

svmdata = fitcsvm(train_data, train_target_data, 'Standardize', true, 'KernelFunction', 'RBF', 'KernelScale', 'auto');
svm = predict(svmdata, test_data);

[confusion_matrix, ~] = confusionmat(svm, test_target_data);

% calculate precision
for i=1:size(confusion_matrix,1)
    precision(i) = confusion_matrix(i,i) / sum(confusion_matrix(i,:));
end

svm_precision = sum(precision) / size(confusion_matrix, 1);

% calculate recall
for i=size(confusion_matrix, 1)
    recall(i) = confusion_matrix(i,i) / sum(confusion_matrix(:, i));
end

svm_recall = sum(recall)/size(confusion_matrix, 1);
svm_fscore = 2 * svm_recall * svm_precision / (svm_precision + svm_recall)

disp("end");
