%% argMax: find the element in a vector with the highest occurrence.
%% vector: the vector to search into.
%% return the element with the highest occurrence.

function argmax = argMax(A)

    [m, n] = size(A);

    argMax = zeros(m, 1);
    for i = 1:m
        [nbOccurence, labelOcc] = hist(A(i, :), unique(A(i, :)));
        [val, ind] = max(nbOccurence);
        argmax(i, 1) = labelOcc(ind);
    end
end
