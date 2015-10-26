%% drawBootstrap: generate a bag and an out-of-bag
%% nTotal: the total size of the sample
%% nbDraw: the number of random draws for the bag
%% return:
%%        bag: the bag with the indices of the data we will pick
%%        oob: the out-of-bag with the indices of the data which will be in the out-of-bag

function [bag, oob] = drawBootstrap(nTotal, nbTirage)

	bag = randi(nTotal, nbTirage, 1);
	oob = setdiff([1:nTotal], bag)';
end
