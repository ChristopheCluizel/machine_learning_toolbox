%% Predict labels for data thanks to a tree
%% X: the data we would like to predict labels
%% tree: the tree with which we will predict the labels
%% return for each data a vector (of size the number of classes) with 1 in the label predicted

function proba = treePredict(X, tree)
	for i=1:size(X,1)
		proba(i,:) = recursPredict(X(i,:),tree);
	end
end

function prob = recursPredict(x, tree)
	if(tree.split.feat < 0)
		prob = tree.proba;
	else
		if(x(tree.split.feat) <= tree.split.value)
			prob = recursPredict(x,tree.left);
		else
			prob = recursPredict(x,tree.right);
		end
	end
end
