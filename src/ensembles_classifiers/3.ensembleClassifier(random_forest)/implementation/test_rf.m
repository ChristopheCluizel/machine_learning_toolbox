clear all;
close all;
clc;

fprintf('============ Random forest =========== \n');

fileName = 'diabetes.mat';
% fileName = 'synth4.mat';
data = load(strcat('../../../resources/datasets/', fileName));
fprintf('Dataset used: %s\n', fileName);

D = prdataset(data.X, data.Y);
[Dr, Ds] = gendat(D, 0.66);
[m, n] = size(Dr.data);

merrK = []; stderrK = [];
K = 10; % number of trees to be trained
fprintf('We will use %d classifiers.\n', K);

% try several value of random features
for k = 1:2:n
	err = [];
  % for each number of random features, launch the algo several times to make an average on the error
	for i = 1:5
		tic; forest = rfLearning(Dr, K, k); toc;
		res = rfTest(Ds, forest);
		err = [err (res.errRate * 100)];
	end
	merrK = [merrK mean(err)];
	stderrK = [stderrK std(err)];
  fprintf('For %f random features, the mean error is: %f%%\n', k, mean(err));
end

X = [1:2:n];
figure;
errorbar(X,merrK, stderrK);
title('Error in % for each number of random features');
xlabel('Number of random features chosen')
ylabel('Percentage of error')

% RF from the PRTools
% very slow!!!
%tic; w1 = randomforestc(Dr,50,1); toc;
%err = testc(Ds,w1)
