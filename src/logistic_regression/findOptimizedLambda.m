function lambdaOptimized = findOptimizedLambda(X, y, Xval, yval, num_labels)

  lambda = [-1:0.3:1];
  nLambda = length(lambda);
  fprintf('\nNumber of iterations to optimize lambda: %d\n', nLambda);

  accuracy = zeros(1, nLambda);

  for i = 1:nLambda
    all_theta = oneVsAll(X, y, num_labels, lambda(i));
    pred_Xval = predictOneVsAll(all_theta, Xval);
    accuracy(i) = mean(double(pred_Xval == yval));
  end
  [val, ind] = max(accuracy);
  % plot(lambda, accuracy)
  lambdaOptimized = lambda(ind);
end
