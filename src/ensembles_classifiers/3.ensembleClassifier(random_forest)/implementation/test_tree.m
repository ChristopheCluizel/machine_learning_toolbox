clear all;
close all;
clc;

fileName = 'synth4.mat';
synth4 = load(strcat('../../../resources/datasets/', fileName));
fprintf('Dataset used: %s\n', fileName);

D = prdataset(synth4.X,synth4.Y);
[Dr,Ds] = gendat(D,0.3);

% grow a PRTools tree classifier for comparison
fprintf('Time for PRTools tree: ');
tic; w1 = treec(Dr); toc;

% grow a decision tree with the treeLearning function
fprintf('Time for tree and random feature selection: ');
tic; tree = treeLearning(Dr); toc;

% compare
errorTreePRTools = testc(Ds,w1) * 100;
res = treeTest(Ds,tree);
errorTreeWithRandFeatSelection = res.errRate * 100;

fprintf('Error with PRTools tree: %f%%\n', errorTreePRTools);
fprintf('Error with tree and random feature selection: %f%%\n', errorTreeWithRandFeatSelection);
