%% adaboostPred: prédiction des étiquettes
function Y = adaboostPred(classifiers, weights, data)

	% Récupération des diverses tailles et informations utiles.
	[n, p] = size(data);
	T = length(classifiers);
	C = length(unique(data.nlab));

	% On intialise une matrice à 0 pour les prédictions de chaque classifieur (T) pour chaque donnée (n).
	labelPredictions = zeros(T, n);

	% Pour chaque classifieur...
	for i = 1:T
		% ... on prédit les étiquettes pour toutes les données.
		labelPredictions(i, :) = data * classifiers{i} * labeld;
	end

	% On initialise une matrice à 0 pour la somme des prédictions des classifieurs pour
	% chaque classe (C) pour chaque donnée (n)
	predictionWeightForEachClass = zeros(C, n);

	% Matrice des poids de la même taille que la matrice des prédictions (T x n) afin de
	% pouvoir faire une multiplication de matrices terme à terme.
	% Pour chaque classifieur, on répète son poid pour chaque donnée (n fois donc)  
	weightsMatrix = repmat(cell2mat(weights), [n, 1])';

	% Pour chaque classe...
	for k = 1:C
		% ... on calcule la matrice de boolean indiquant si cette classe est choisie ou non
		% pour chaque données et chaque classifieur.
		booleanPredictions{k} = labelPredictions == k;

		% ... on transforme les 1 de cette matrice (prédiction de la classe en cours de traitement)
		% par le poid du classifieur qui l'a prédit. Puis l'on fait la somme de tous les poids.
		predictionWeightForEachClass(k, :) = sum(booleanPredictions{k} .* weightsMatrix);
	end

	% La valeur prédite est égale à la classe ayant la somme des poids la plus forte.
	[val, Y] = max(predictionWeightForEachClass);

	% On retourne simplement le vecteur.
	Y = Y';
end


