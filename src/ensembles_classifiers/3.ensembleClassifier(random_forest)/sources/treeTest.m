

function res = treeTest(D,tree)
	
	res.proba = treePredict(D.data,tree);
	[tmp,res.pred] = max(res.proba,[],2);
	res.nbErrors = sum(res.pred~=D.nlab);
	res.nbTestInstances = size(D.data,1);
	res.errRate = res.nbErrors / size(D.data,1);

end
