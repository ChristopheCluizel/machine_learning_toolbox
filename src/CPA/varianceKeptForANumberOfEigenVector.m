function varianceRetained = varianceKeptForANumberOfEigenVector(S, K)

  varianceRetained = sum(sum(S(1:K, 1:K))) / sum(sum(S));

end
