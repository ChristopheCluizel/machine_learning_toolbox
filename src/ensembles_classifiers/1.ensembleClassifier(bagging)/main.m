clear; close all

X = load('skew.mat');
X = X.values';

[n, m] = size(X);
K = 20; % the number of classifiers

% ========= Statistics moment ==========
fprintf('============ Statistics moment =========== \n');
gamma = [];
for i = 1:K
	[bag, oob] = drawBootstrap(n, n);
	gamma(i) = skewness(X(bag));
end
gamma = gamma';

gammaMeanBootstrap = mean(gamma);
gammaStdBootstrap = std(gamma);
gammaX = skewness(X);

fprintf('Gamma mean with Bootstrap: %0.2f\n', gammaMeanBootstrap);
fprintf('Gamma std with Bootstrap: %0.2f\n', gammaStdBootstrap);
fprintf('Gamma X: %02f\n', gammaX);


% ============ Bagging ==============
fprintf('\n\n============ Bagging =========== \n');
% loading a given datasets.
% The mat files have been generated so that it contains two matrices:
%  - X: a n by d matrix that contains the input values
%  - Y: a column vector of n output values (class indexes)
fileName = 'synth4.mat';
synth4 = load(strcat('../../resources/datasets/', fileName));
fprintf('Dataset used: %s\n', fileName);

% data are converted into Dataset object from the PRTools library
data = prdataset(synth4.X, synth4.Y);

% stratified random splitting of the dataset
[X, X_test] = gendat(data, 0.6);
[mDs, nDs] = size(X_test);

K = 10; % the number of classifiers
fprintf('We will use %d classifiers.\n', K);

% learn the classifiers
[treeClassifiers, treeOob] = classifiersLearning(X, K);

% estimating the test error rates for each trained classifier
errTree = testc(X_test, treeClassifiers);

% calculate errors from the classifiers
% remark: the prediction for the out-of-bag sets is very long (~40s) for K = 10
[testError, oobError] = classifiersTest(X, X_test, treeClassifiers, treeOob);

fprintf('Mean error for the sets of tree classifiers: %f%%\n', mean(cell2mat(errTree)) * 100)
fprintf('Error on X_test for Bagging method with tree classifiers: %f%%\n', testError);
fprintf('Error on "Out of bag" for Bagging method with tree classifiers: %f%%\n', oobError);
