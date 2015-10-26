

clear all;
close all;
clc;

synth4 = load('./data/synth4.mat');
D = prdataset(synth4.X,synth4.Y);
[Dr,Ds] = gendat(D,0.3);

% grow a PRTools tree classifier for comparison
tic; w1 = treec(Dr); toc; 
pause;
% grow a decision tree with the treeLearning function 
tic; tree = treeLearning(Dr); toc;
pause;
% compare
res = treeTest(Ds,tree);
res.errRate
err = testc(Ds,w1)
