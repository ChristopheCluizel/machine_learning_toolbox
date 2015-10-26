

clear all;
close all;
clc;

data = load('diabetes.mat');
D = prdataset(data.X,data.Y);
[Dr,Ds] = gendat(D,0.66);

merrK = []; stderrK = [];
% try several value of random features
for k = 1:2:7
	err = [];
	for k=1:5
		tic; forest = rfLearning(Dr,50,k); toc;
		res = rfTest(Ds,forest); toc;
		err = [err res.errRate];
	end
	merrK = [merrK mean(err)]
	stderrK = [stderrK std(err)]
end

X = [1:2:7];
errorbar(X,merrK,stderrK);

% RF from the PRTools
% very slow!!!
%tic; w1 = randomforestc(Dr,50,1); toc;
%err = testc(Ds,w1)
