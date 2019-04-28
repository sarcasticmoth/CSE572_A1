clear all
clc
% User Dependent Analysis

% break up into 10 groups %

workingdir = pwd;
originaldatapath = fullfile(workingdir, "Data", "MyoData");
datapath = fullfile(workingdir, "A2_P1_UserData");
endpath = fullfile(workingdir, "A2_Training");

% make the end folder if does not exist
if ~exist(endpath, 'dir')
    mkdir(endpath);
end

% get list of users
tmp = dir(originaldatapath);
tmp = tmp(~ismember({tmp.name},{'.','..'}));
users = [];
for i=1:size(tmp,1)
    users = [users; cellstr(tmp(i).name)];
end

groups = size(users, 1);

% Training and Testing
train_data_orig = readmatrix(fullfile(datapath, "Train_Data.csv"));
test_data_orig = readmatrix(fullfile(datapath, "Test_Data.csv"));
train_target_data_orig = readmatrix(fullfile(datapath, "Train_Target_Data.csv"));
test_target_data_orig = readmatrix(fullfile(datapath, "Train_Test_Data.csv"));

% create mapping
%mapping = [];
%interval = (size(train_data_orig, 1) / groups) - 1;
%initial = size(mapping, 1) + 1;
%mapping = [mapping; [initial initial + interval]];
%for a=1:groups - 1
%    x = mapping(a, 2) + 1;
%    y = x + interval;
%    mapping = [mapping; [x y]];
%end

% mapping for test data
%t_mapping = [];
%t_interval = (size(test_data_orig, 1) / groups) - 1;
%t_initial = size(t_mapping, 1) + 1;
%t_mapping = [t_mapping; [t_initial t_initial + t_interval]];
%for a=1:groups - 1
%    x = t_mapping(a, 2) + 1;
%    y = x + t_interval;
%    t_mapping = [t_mapping; [x y]];
%end

columns = ["Group", "Neural Network FScore", "Neural Network Recall" , "Neural Network Precision", "Decision Tree FScore", "Decision Tree Recall", "Decision Tree Precision", "SVM FScore", "SVM Recall", "SVM Precision"];
group_data = [];
group_data = [group_data; columns;];

for i=1:size(users,1)
    user = users{i};
    disp("procesing " + user + "....");
    
    % Training and Testing
    %train_data = train_data_orig(mapping(i, 1) : mapping(i, 2), :);
    %test_data = test_data_orig(t_mapping(i, 1) : t_mapping(i, 2), :);
    %train_target_data = train_target_data_orig(mapping(i, 1) : mapping(i, 2), :);
    %test_target_data = test_target_data_orig(t_mapping(i, 1) : t_mapping(i, 2), :);
    train_data = readmatrix(fullfile(datapath, user, "Train_Data.csv"));
    test_data = readmatrix(fullfile(datapath, user, "Test_Data.csv"));
    train_target_data = readmatrix(fullfile(datapath, user, "Train_Target_Data.csv"));
    test_target_data = readmatrix(fullfile(datapath, user, "Train_Test_Data.csv"));

    %
    % decision trees
    %
    dt_precision = 0;
    dt_recall = 0;
    dt_fscore = 0;
    
    dtree = fitctree(train_data, train_target_data);
    dt = predict(dtree, test_data);
    
    [confusion_matrix, ~] = confusionmat(dt, test_target_data);
    
    % calculate precision, recall and fscore    
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
    
    %
    % neural networks
    %
    nn_precision = 0;
    nn_recall = 0;
    nn_fscore = 0;
    
    n = feedforwardnet(10);
    net = train(n, train_data', train_target_data');
    neural_net = sim(net, test_data');
    
    [confusion_matrix, ~] = confusionmat(neural_net, test_target_data');
    
    % calculate precision, recall and fscore
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
    
    %
    % SVM
    %
    svm_precision = 0;
    svm_recall = 0;
    svm_fscore = 0;
    
    svmdata = fitcsvm(train_data, train_target_data, 'Standardize', true, 'KernelFunction', 'RBF', 'KernelScale', 'auto');
    svm = predict(svmdata, test_data);

    [confusion_matrix, ~] = confusionmat(svm, test_target_data);

    % calculate precision, recall and fscore
    for i=1:size(confusion_matrix,1)
        precision(i) = confusion_matrix(i,i) / sum(confusion_matrix(i,:));
    end

    svm_precision = sum(precision) / size(confusion_matrix, 1);

    % calculate recall
    for i=size(confusion_matrix, 1)
        recall(i) = confusion_matrix(i,i) / sum(confusion_matrix(:, i));
    end

    svm_recall = sum(recall)/size(confusion_matrix, 1);
    svm_fscore = 2 * svm_recall * svm_precision / (svm_precision + svm_recall);

    disp("end training");
    
    %
    % save
    %
    
    data = ["Group" + user, nn_fscore, nn_recall, nn_precision, dt_fscore, dt_recall, dt_precision, svm_fscore, svm_recall, svm_precision];
    
    group_data = [group_data; data];
        
    disp("end group" + user);
    
end

disp("write dependent data");
writematrix(group_data, fullfile(endpath, "users_dep_data.csv"));

disp("end");