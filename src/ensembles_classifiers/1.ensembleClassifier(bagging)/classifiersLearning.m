%% classifiersLearning: train "K" classifiers on X_app
%%
%% X_app: the data to learn with.
%% K: the number of classifiers to train.
%% return
%%      classifiers: the set of classifiers for the "tree" implementation.
%%      oob: the out-of-bag for each classifier.

function [classifiers, oob] = classifiersLearning(X_app, K)
    [m, n] = size(X_app);

    for i = 1:K
        % generate a bag and an out-of-bag
        [bag, vec_oob] = drawBootstrap(m, m);
        oob{:, i} = vec_oob;
        Dk = X_app(bag, :);
        % training a decision tree classifier on a bag
        classifiers{i} = treec(Dk);
    end
end
