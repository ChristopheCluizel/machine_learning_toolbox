%% classifiersPredict: predict on test set and out-of-bag with a set of classifiers.
%% X: data set.
%% X_test: the test set.
%% classifiers: the set of classifiers.
%% oob: the out-of-bag for each classifier.
%% return the predictions with the test set and out-of-bag.

function [predictions, oobPredictions] = classifiersPredict(X, X_test, classifiers, oob)

    [m, n] = size(X);
    [mTest, nTest] = size(X_test);
    K = size(classifiers, 2);

    % prediction for X_test
    fprintf('Time for prediction for the X_test set: ');
    tic
        label = zeros(mTest, K);
        for i = 1:K
            % label for each classifier
            label(:, i) = labeld(X_test, classifiers{i});
        end

        % find the best prediction for each data among the labels
        predictions = argMax(label);
    toc

    oobPredictions = zeros(m, 1);
    % prediction for out-of-bag
    % fprintf('remark: the prediction for the out-of-bag takes some time (~40s) for K = 10\n');
    % fprintf('Time for prediction for the out-of-bag sets: ');
    % tic
    %     oobPredictions = zeros(m, 1);
    %     nClasses = max(X.nlab); % the number of different labels
    %     % for each data, we take the out-of-bags which contain this data. Then for each out-of-bag, we calculate its prediction thanks the classifier corresponding with the out-of-bag.
    %     for i = 1:m
    %         votes = zeros(1, nClasses);
    %         for j = 1:K
    %             if (isempty(find(X.data(oob{:, j}) == X.data(i, 1))) == 0) % if data "i" in out-of-bag "j"
    %                 prediction = labeld(X.data(i, :), classifiers{j});
    %                 votes(1, prediction) = votes(1, prediction) + 1;
    %             end
    %         end
    %         % majority vote
    %         [val, ind] = max(votes);
    %         oobPredictions(i, 1) = ind;
    %     end
    % toc
    fprintf('\n');
end
