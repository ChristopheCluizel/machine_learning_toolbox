%% classifiersTest: compute the prediction errors.
%% X: the data set.
%% X_test: the test set.
%% classifiers: the set of classifiers.
%% oob: the out-of-bag for each classifier.
%% return the error between the predictions and true labels.

function [error, oobError] = classifiersTest(X, X_test, classifiers, oob)
    [m, n] = size(X);
    [mTest, nTest] = size(X_test);

    [predictions, oobPredictions] = classifiersPredict(X, X_test, classifiers, oob);

    error = (1 - (sum(predictions == X_test.nlab) / mTest)) * 100;
    oobError = (1 - (sum(oobPredictions(:, 1) == X.nlab) / m)) * 100;
end
