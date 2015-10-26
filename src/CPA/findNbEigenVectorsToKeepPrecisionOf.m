function [nbOfClassesK, varianceRetained] = findNbEigenVectorsToKeepPrecisionOf(S, precision)
  varianceRetained = 0;
  K = 0;

  while(varianceRetained < precision)
    K = K + 1;
    varianceRetained = varianceKeptForANumberOfEigenVector(S, K);
  end

  nbOfClassesK = K;
end
