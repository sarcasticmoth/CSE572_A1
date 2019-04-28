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

groups = 28;

% Training and Testing
EA_Train_Data = readmatrix(fullfile(datapath, "Eat_Train_Data.csv"));
EA_Test_Data = readmatrix(fullfile(datapath, "Eat_Test_Data.csv"));
NEA_Train_Data = readmatrix(fullfile(datapath, "NotEat_Train_Data.csv"));
NEA_Test_Data = readmatrix(fullfile(datapath, "NotEat_Test_Data.csv"));

% create mapping %
train_map = [];
ng = groups / 4;
interval = (size(EA_Train_Data, 1) / ng) - 1;
initial = size(train_map, 1) + 1;
train_map = [train_map; [initial initial + interval]];
for a=1:ng - 1
   x = train_map(a, 2) + 1;
   y = x + interval;
   train_map = [train_map; [x y]];
end

test_map = [];
interval = (size(EA_Test_Data, 1) / ng) - 1;
initial = size(test_map, 1) + 1;
test_map = [test_map; [initial initial + interval]];
for b=1:ng - 1
    x = test_map(b, 2) + 1;
    y = x + interval;
    test_map = [test_map; [x y]];
end

columns = ["Group", "Decision Tree FScore", "Decision Tree Recall", "Decision Tree Precision", "SVM FScore", "SVM Recall", "SVM Precision", "NN F1Score", "NN Recall", "NN Precision"];
group_data = [];
group_data = [group_data; columns;];

for u=1:ng   
    % Training and Testing
    ea_temp_train = EA_Train_Data(train_map(u, 1) : train_map(u, 2), :);
    nea_temp_train = NEA_Train_Data(train_map(u, 1) : train_map(u, 2), :);
    train_data = [ea_temp_train; nea_temp_train];
    
    ea_temp_test = EA_Test_Data(test_map(u, 1) : test_map(u, 2), :);
    nea_temp_test = NEA_Test_Data(test_map(u, 1) : test_map(u, 2), :);
    test_data = [ea_temp_test; nea_temp_test];
    
    train_target_data = [ones(size(ea_temp_train, 1), 1); zeros(size(nea_temp_train, 1), 1)];
    test_target_data = [ones(size(ea_temp_test, 1), 1); zeros(size(nea_temp_test, 1), 1)];
       
    %
    % decision trees
    %
    dt_precision = 0;
    dt_recall = 0;
    dt_fscore = 0;
    
    dtree = fitctree(train_data, train_target_data);
    dt = predict(dtree, test_data);
    
    [dt_confusion_matrix, order] = confusionmat(dt, test_target_data);
    
    % calculate precision, recall and fscore    
    for i=1:size(dt_confusion_matrix,1)
        precision(i) = dt_confusion_matrix(i,i) / sum(dt_confusion_matrix(i,:));
    end
    precision(isnan(precision)) = [];
    dt_precision = sum(precision) / size(dt_confusion_matrix, 1);

    % calculate recall
    for i=size(dt_confusion_matrix, 1)
        recall(i) = dt_confusion_matrix(i,i) / sum(dt_confusion_matrix(:, i));
    end

    dt_recall = sum(recall)/size(dt_confusion_matrix, 1);
    dt_fscore = 2 * dt_recall * dt_precision / (dt_precision + dt_recall)
    
    %view(dtree);
    %view(dtree, 'mode', 'graph');
    
    %
    % SVM
    %
    svm_precision = 0;
    svm_recall = 0;
    svm_fscore = 0;
    
    svmdata = fitcsvm(train_data, train_target_data, 'Standardize', true, 'KernelFunction', 'RBF', 'KernelScale', 'auto');
    svm = predict(svmdata, test_data);

    [svm_confusion_matrix, order] = confusionmat(svm, test_target_data);

    % calculate precision, recall and fscore
    for i=1:size(svm_confusion_matrix,1)
        precision(i) = svm_confusion_matrix(i,i) / sum(svm_confusion_matrix(i,:));
    end
    precision(isnan(precision)) = [];
    svm_precision = sum(precision) / size(svm_confusion_matrix, 1);

    % calculate recall
    for i=size(svm_confusion_matrix, 1)
        recall(i) = svm_confusion_matrix(i,i) / sum(svm_confusion_matrix(:, i));
    end

    svm_recall = sum(recall)/size(svm_confusion_matrix, 1);
    svm_fscore = 2 * svm_recall * svm_precision / (svm_precision + svm_recall);

    disp("end training");
    
    %
    % save
    %
    
    % NN
    net = patternnet(40);
    net = train(net, train_data', train_target_data');
    nn = sim(net, test_data');
    nn(nn >= 0.5) = 1;
    nn(nn < 0.5) = 0;
    [nconfusion_matrix, ~] = confusionmat(nn, test_target_data');
    x = confusionmatStats(nn, test_target_data');
    % calculate precision
    for i=1:size(nconfusion_matrix,1)
        nprecision(i) = nconfusion_matrix(i,i) / sum(nconfusion_matrix(i,:));
    end
    nprecision(isnan(nprecision)) = [];
    nn_precision = sum(nprecision) / size(nconfusion_matrix, 1);

    % calculate recall
    for i=size(nconfusion_matrix, 1)
        nrecall(i) = nconfusion_matrix(i,i) / sum(nconfusion_matrix(:, i));
    end

    nn_recall = sum(nrecall)/size(nconfusion_matrix, 1);
    nn_fscore = 2 * nn_recall * nn_precision / (nn_precision + nn_recall)

    data = ["Group" + u, dt_recall, dt_precision, dt_fscore, svm_recall, svm_precision, svm_fscore, nn_fscore, nn_recall, nn_precision];

    group_data = [group_data; data];

    disp("end group" + u);

end

disp("write dependent data");
writematrix(group_data, fullfile(endpath, "users_dep_data.csv"));

disp("end");