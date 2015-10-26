clear all; close all;

% loading a given datasets.
% The mat files have been generated so that it contains two matrices:
%  - X: a n by d matrix that contains the input values
%  - Y: a column vector of n output values (class indexes)
synth4 = load('datasets/synth4.mat');

% data are converted into Dataset object from the PRTools library
D = prdataset(synth4.X, synth4.Y);

% stratified random splitting of the dataset: half for training, half for test
[Dr, Ds] = gendat(D, 0.5);
fprintf('Size of Dr: (%d, %d)\n', size(Dr, 1), size(Dr, 2))
fprintf('Size of Ds: (%d, %d)\n', size(Ds, 1), size(Ds, 2))

% training a decision tree classifier on Dr
w1 = treec(Dr);
% training a knn classifier on Dr
w2 = knnc(Dr, 3);

% plotting the test subset and the models learnt above (on the same figure)
scatterd(Ds);
plotc({w1, w2});

% estimating the test error rates for each of the trained classifiers
err1 = testc(Ds, w1);
err2 = testc(Ds, w2);
fprintf('Error with tree: %f\n', err1)
fprintf('Error with knn: %f\n', err2)

% prediction can also be obtained by a simple product between the test set and the classifier
% in that case the * operator is not symmetric (the test set must be on the left)
P1 = Ds * w1
confmat(P1)

