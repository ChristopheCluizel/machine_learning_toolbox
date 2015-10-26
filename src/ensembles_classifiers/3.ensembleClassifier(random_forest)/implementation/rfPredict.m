%% Predict the labels on data with a random forest
%% X: the data set
%% forest: the random forest learned
%% return the labels for each data

function probas = rfPredict(X, forest)

  [m, n] = size(X);
  L = forest.nbTrees;
  probas = zeros(m, forest.nbClasses);

	for i = 1:L
		probas = probas + treePredict(X,forest.trees{i});
	end
end
