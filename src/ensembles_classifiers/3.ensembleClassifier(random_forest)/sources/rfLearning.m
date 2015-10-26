


%% function forest = rfLearning(D,L,rndFeat)  
%
%   grows a random forest classifier with the Forest-RI algorithm.
%	The resulting ensemble of classifiers is made up with L trees, each
%	of which being grown via the treeLearning function. This function 
%	allows for the learning of a random tree if a rndFeat parameter is 
%	given that defines the number of features to be randomly selected at
%	each node.
%
%	D : a PRTools dataset structure. It can be obtained from a (X,Y) couple
%		of matrices thanks to a call to 'prdataset(X,Y)'. In this case, X 
%		is a matrix with each line corresponding to an input data point, 
%		and Y is a vector with the corresponding outputs (true classes)
%	L : the number of tree to be grown in the forest
%	rndFeat : the number of random features at each node
%
%	forest : a structure that contains 6 fields:
%		.learningMethod = "Forest-RI"
%		.nbTrees = L
%		.rndFeat = rndFeat
%		.trees : a row cellarray with L cells, each of which containing 
%				 a decision	tree classifier (see help treeLearning)
%		.boot : a row cellarray with L cells, each of which containing 
%				a bootstrap sample
%		.oob : a row cellarray with L cells, each of which containing 
%				the corresponding out-of-bag sets
function forest = rfLearning(D,L,rndFeat)

	islabtype(D,'crisp');
	isvaldset(D,1,2); % at least 1 object per class, 2 classes
	% if rndFeat has not been given, it is set to d, the total number of available features
	if(~exist('rndFeat', 'var'))
		rndFeat = size(D.data,2);
	end
	
	
	% TODO : Forest-RI learning procedure
	

end
