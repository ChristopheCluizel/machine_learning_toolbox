


function res = rfTest(D,forest)
	
	res.proba = rfPredict(D.data,forest);
	[tmp,res.pred] = max(res.proba,[],2);
	res.confm = zeros(forest.nbClasses,forest.nbClasses);
	for i=1:length(res.pred)
		res.confm(D.nlab(i),res.pred(i)) = res.confm(D.nlab(i),res.pred(i)) + 1;
	end
	res.nbErrors = sum(res.pred~=D.nlab);
	res.nbTestInstances = size(D.data,1);
	res.errRate = res.nbErrors / size(D.data,1);

end


