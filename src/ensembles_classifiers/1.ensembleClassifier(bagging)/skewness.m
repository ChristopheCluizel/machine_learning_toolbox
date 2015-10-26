%% skewness: function description
function gamma = skewness(X)

	gamma = sum(bsxfun(@rdivide, bsxfun(@minus, X, mean(X)), std(X)).^3);
end
