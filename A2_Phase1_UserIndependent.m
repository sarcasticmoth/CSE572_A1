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
ea_train_data = readmatrix(fullfile(datapath, "Eat_Train_Data.csv"));
nea_train_data = readmatrix(fullfile(datapath, "NotEat_Train_Data.csv"));
ea_test_data = readmatrix(fullfile(datapath, "Eat_Test_Data.csv"));
nea_test_data = readmatrix(fullfile(datapath, "NotEat_Test_Data.csv"));

train_data = [ea_train_data; nea_train_data];
test_data = [ea_test_data; nea_test_data];
train_target_data = [ones(size(ea_train_data, 1), 1); zeros(size(nea_train_data, 1), 1)];
test_target_data = [ones(size(ea_test_data, 1), 1); zeros(size(nea_test_data, 1), 1)];

%
% decision trees
%

dt_precision = 0;
dt_recall = 0;
dt_fscore = 0;

dtree = fitctree(train_data, train_target_data);
dt = predict(dtree, test_data);

[confusion_matrix, ~] = confusionmat(dt, test_target_data);

% calculate precision
for i=1:size(confusion_matrix,1)
    precision(i) = confusion_matrix(i,i) / sum(confusion_matrix(:, i));
end
precision(isnan(precision)) = [];
dt_precision = sum(precision) / size(confusion_matrix, 1);

% calculate recall
for i=size(confusion_matrix, 1)
    recall(i) = confusion_matrix(i,i) / sum(confusion_matrix(i, :));
end

dt_recall = sum(recall)/size(confusion_matrix, 1);
dt_fscore = 2 * dt_recall * dt_precision / (dt_precision + dt_recall)

% graph %
view(dtree);
view(dtree, 'mode', 'graph');

% NN
net = patternnet(10);
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

disp("end training");

% save scores
columns = ["Neural Network FScore", "Neural Network Recall" , "Neural Network Precision", "Decision Tree FScore", "Decision Tree Recall", "Decision Tree Precision", "SVM FScore", "SVM Recall", "SVM Precision"];
data = [nn_fscore, nn_recall, nn_precision, dt_fscore, dt_recall, dt_precision, svm_fscore, svm_recall, svm_precision];

ind_data = [columns; data];
writematrix(ind_data, fullfile(endpath, "users_ind_data.csv"));

disp("end");