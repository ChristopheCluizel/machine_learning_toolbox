%% adaboostPred: prédiction des étiquettes.
function Y = adaboostPred(classifiers, weights, data)

	% Récupération des diverses tailles et informations utiles.
	[n, p] = size(data);
	T = length(classifiers);

	% On intialise une matrice à 0 pour les prédictions de chaque classifieur (T) pour chaque donnée (n).
	predictions = zeros(T, n);

	% Pour chaque classifieur...
	for i = 1:T
		% ... on prédit les étiquettes pour toutes les données.
		predictions(i, :) = data * classifiers{i} * labeld;
	end

	% Les prédictions sont -1 ou 1. On peut donc récupérer la prédiction en récupèrant le signe
	% de la somme pondérée par les poids pour chaque classifieur.
	Y = sign(cell2mat(weights) * predictions);

	% On retourne simplement le vecteur.
	Y = Y';
end