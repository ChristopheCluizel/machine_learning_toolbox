%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  This program applies several supervised classification methods on data:
%%    - Logistic regression (linear model)
%%    - SVM
%%    - Bagging
%%    - Random forest
%%    - Neural network
%%  It is possible to choose which methods to apply by setting the boolean variables at the beginning.
%%
%%  This program uses different external toolbox:
%%    - "Prtools" for Bagging and Random forest
%%    - "DeepLearnToolbox-master" for Neural network
%%    - "libsvm-3.20" for SVM
%%
%%  To be able to use "libsvm-3.20", the packages have to be built. For that, go to the folder "tools -> libsvm-3.20 -> matlab" with Matlab commands and type "make" to run the file "make.m". If there is any problem, please refer to the README in this folder. Otherwise, deactivate the variable "executeSVM".
%%
%%  To launch this program, be sure that the parent folder and all its sub-folders are in the Matlab path to be able to find the different functions. Either add it by hand with the interface of Matlab or by Matlab command in the parent folder: "addpath(genpath('.'))".
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;

executeLogisticRegression = true;
executeSVM = true;
executeBagging = true;
executeRandomForest = true;
executeNeuralNetwork = true;

% load the data
% data = load('data/ionosphere.mat');
% data = load('../data/5.handwritten_digits.mat');
data = load('../data/data_aurelien.csv');
X_original = data(:, 1:10);
y_original = data(:, 11);

% to select only a few random data
% indices = randperm(length(data.X), 1000);
% X_original = data.X(indices, :);
% y_original = data.y(indices, :);

% if the data already split
% X_original = data.X;
% y_original = data.labels;
% Xtemp = data.X_test;
% ytemp = data.y_test;

% to load csv files
% data = csvread('data/data.csv');
% X_original = data(:, 1:10);
% y_original = data(:, 11);

% if only 2 classes with 0 and 1 label (because label 0 raises problem with indices)
% y_original(find(y_original == 1)) = 2;
% y_original(find(y_original == 0)) = 1;

% normalize the data.
X_original(1, :) = bsxfun(@plus, X_original(1,:), 1E-6); % to avoid the problem of columns full of 0 (create NAN in this case)
[X_original, mu, sigma] = featureNormalize(X_original);

%  Run PCA
[U, S] = pca(X_original);

% find K (the number of eigenVectors to keep a certain precision)
precision = 0.99; % 0.90 for handwritten_digits data
[K, varianceRetained] = findNbEigenVectorsToKeepPrecisionOf(S, precision);
fprintf('To keep a precision of %f, we need to keep %d eigenVectors.\n', precision, K);

% do the projections on data sets
X_proj = projectData(X_original, U, K);

% pre-process the data if the original data are already split into training set and test set
% X = X_proj;
% y = y_original;
% Xtemp = featureNormalizeWithParameters(Xtemp, mu, sigma);
% Xtemp = projectData(Xtemp, U, K);

% split the data to have a training set, a cross-validation set and a test set
[X, y, Xtemp, ytemp] = splitdata(X_proj, y_original, 0.7);
[Xval, yval, Xtest, ytest] = splitdata(Xtemp, ytemp, 0.5);

% get the different sizes and number of classes
[mX, nX] = size(X);
[mXtemp, nXtemp] = size(Xtemp);
[mXval, nXval] = size(Xval);
[mXtest, nXtest] = size(Xtest);

nbClasses = length(unique(y));

fprintf('Size X: %dx%d, with %d classes.\n', mX, nX, nbClasses);
fprintf('Size Xtemp: %dx%d.\n', mXtemp, nXtemp);
fprintf('Size Xval: %dx%d.\n', mXval, nXval);
fprintf('Size Xtest: %dx%d.\n', mXtest, nXtest);

% waitforbuttonpress

% ============= Logistic regression ============
if(executeLogisticRegression)
  fprintf('\n============= Logistic regression ============\n')
  % find optimized lambda
  %lambdaOptimized = findOptimizedLambda(X, y, Xval, yval, nbClasses);
  lambdaOptimized = 0.1; % set manually to accelerate
  fprintf('Lambda optimized: %f\n', lambdaOptimized);

  % learning one VS all logistic regression
  [all_theta] = oneVsAll(X, y, nbClasses, lambdaOptimized);

  % prediction logistic regression
  pred_X = predictOneVsAll(all_theta, X);
  pred_Xval = predictOneVsAll(all_theta, Xval);
  pred_Xtest = predictOneVsAll(all_theta, Xtest);

  fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred_X == y)) * 100);
  fprintf('Cross-validation Set Accuracy: %f\n', mean(double(pred_Xval == yval)) * 100);
  accuracyTestSetLogistic = mean(double(pred_Xtest == ytest)) * 100;
  fprintf('Test set accuracy for logistic regression: %f%%\n', accuracyTestSetLogistic);

  % fprintf('Press a key when ready.\n');
  % waitforbuttonpress
end


% ============= SVM ============
if(executeSVM)
  fprintf('\n============= SVM ============\n')
  % learning multi classes with SVM
  model = svmtrain(y, X, '-s 0 -t 2');

  % prediction SVM
  pred_X_proj = svmpredict(y, X, model);
  pred_Xtest = svmpredict(ytemp, Xtemp, model);
  % fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred_X_proj == y)) * 100);
  accuracyTestSetSVM = mean(double(pred_Xtest == ytemp)) * 100;
  fprintf('Test set accuracy for SVM: %f%%\n', accuracyTestSetSVM);
end


% ============== Bagging =============
if(executeBagging)
  fprintf('\n============= Bagging ============\n')
  % data are converted into Dataset object from the PRTools library
  dataset = prdataset(X_proj, y_original);

  % stratified random splitting of the dataset
  [X_bagging, X_test_bagging] = gendat(dataset, 0.7);
  [mDs, nDs] = size(X_test_bagging);

  nbClassifiers = 10; % the number of classifiers
  fprintf('We will use %d classifiers.\n', nbClassifiers);

  % learn the classifiers
  [treeClassifiers, treeOob] = classifiersLearning(X_bagging, nbClassifiers);

  % calculate errors from the classifiers
  [errorTestSetBagging, oobError] = classifiersTest(X_bagging, X_test_bagging, treeClassifiers, treeOob);
  accuracyTestSetBagging = 100 - errorTestSetBagging;

  fprintf('Test set accuracy for Bagging method with tree classifiers: %f%%\n', accuracyTestSetBagging);
end


% ============= RandomForest ==============
if(executeRandomForest)
  fprintf('\n============= RandomForest ============\n')
  % create the dataset
  D = prdataset(X_proj, y_original);
  % split to have a training set and a test set
  [Dr, Ds] = gendat(D, 0.7);
  [m, n] = size(Dr.data);

  merrK = []; stderrK = [];
  nbOfClassifiers = 5; % number of trees to be trained
  fprintf('We will use %d classifiers.\n', nbOfClassifiers);

  nbOfRandomFeature = K; % number of random feature
  % train the random forest on training set
  forest = rfLearning(Dr, nbOfClassifiers, nbOfRandomFeature);
  % test the random forest on test set
  res = rfTest(Ds, forest);
  err = res.errRate * 100;
  accuracyTestSetRandomForest = 100 - err;
  fprintf('Test set accuracy for random forest: %f%%\n', accuracyTestSetRandomForest);
end


% ============= Neural network ==============
if(executeNeuralNetwork)
  train_x = X;
  test_x  = Xtemp;
  % format the label set. If 'y' is label 3 among 5 labels, 'y' is represented as follows [0 0 1 0 0]
  train_y = zeros(mX, nbClasses);
  for i = 1:mX
    train_y(i, y(i, 1)) = 1;
  end

  [mXtemp nXtemp] = size(Xtemp);
  test_y  = zeros(mXtemp, nbClasses);
  for i = 1:mXtemp
    test_y(i, ytemp(i, 1)) = 1;
  end

  % normalize
  [train_x, mu, sigma] = zscore(train_x);
  test_x = normalize(test_x, mu, sigma);

  % set the options
  rand('state',0)
  nn = nnsetup([nX 200 nbClasses]); % set the layers
  nn.weightPenaltyL2 = 1e-5;  %  L2 weight decay
  nn.activation_function = 'sigm';    %  Sigmoid activation function
  nn.learningRate = 0.8;                %  Sigm require a lower learning rate
  opts.numepochs =  20;   % 20  Number of full sweeps through data
  opts.batchsize = 109;  % 5(handwrittendata)  Take a mean gradient step over this many samples. Must be a divisor of the number of features?

  % train the NN on training set
  [nn, L] = nntrain(nn, train_x, train_y, opts);

  % test the NN on test set
  [err, bad] = nntest(nn, test_x, test_y);
  accuracyTestSetNeuralNetwork = (1 - err) * 100;
  fprintf('Test set accuracy for neural network: %f%%\n', accuracyTestSetNeuralNetwork);
end


% =========== Results ========
fprintf('\n\n============= Results =============\n')
fprintf('With a precision of %f of the original data and %d eigenVectors.\n', precision, K);

if(executeLogisticRegression)
  fprintf('Test set accuracy for logistic regression: %f%%\n', accuracyTestSetLogistic);
end
if(executeSVM)
  fprintf('Test set accuracy for SVM: %f%%\n', accuracyTestSetSVM);
end
if(executeBagging)
    fprintf('Test set accuracy for Bagging: %f%%\n', accuracyTestSetBagging);
end
if(executeRandomForest)
  fprintf('Test set accuracy for random forest: %f%%\n', accuracyTestSetRandomForest);
end
if(executeNeuralNetwork)
  fprintf('Test set accuracy for neural network: %f%%\n\n\n\n', accuracyTestSetNeuralNetwork);
end


% ======== Combine all classifiers together =========
% predict with all classifiers trained on Xtemp set
predictions = [];
if(executeLogisticRegression)
  pred_logistic = predictOneVsAll(all_theta, Xtemp);
  predictions = [predictions pred_logistic];
end
if(executeSVM)
  pred_SVM = svmpredict(ytemp, Xtemp, model);
  predictions = [predictions pred_SVM];
end
if(executeBagging)
  pred_bagging = classifiersPredict(prdataset(X, y), prdataset(Xtemp, ytemp), treeClassifiers, treeOob);
  predictions = [predictions pred_bagging];
end
if(executeRandomForest)
  pred_RF = rfTest(prdataset(Xtemp, ytemp), forest);
  pred_RF = pred_RF.pred;
  predictions = [predictions pred_RF];
end
if(executeNeuralNetwork)
  pred_NN = nnpredict(nn, Xtemp);
  predictions = [predictions pred_NN];
end
% predictions = [pred_logistic pred_SVM pred_bagging pred_RF pred_NN];

% select the best prediction with the majority vote
bestPredictions = argMax(predictions);
% calculate the accuracy
predictionsAccuracy = mean(double(bestPredictions == ytemp)) * 100;
fprintf('\n\n============= Combine all classifiers together =============\n')
fprintf('Test set accuracy with all classifiers together: %f%%\n', predictionsAccuracy);
