%% adaboostM1Learn: train "T" classifiers on data with AdaBoost.M1 method
%%
%% data: the data to learn with (X and Y).
%% T: the number of classifiers to train.
%% classifier: type of classifier (stump or tree)
%% return
%%      classifiers: the set of classifiers for the "tree" implementation.
%%      theta: weights for each classifier.

function [classifiers, theta] = adaboostM1Learn(data, T, classifier)

	% Récupération des diverses tailles et informations utiles.
	[n, p] = size(data);
	trueLabels = getlabels(data);
	allLabels = unique(trueLabels);
	C = length(allLabels);

	% Initialisation des poids, on associe chaque donnée à 1/n
	% (afin d'avoir une distribution avec une somme de 1)
	weightsForEachData = ones(n, 1) ./ n;

	% Pour le nombre de classifieurs que l'on veut obtenir...
	for t = 1:T
		fprintf('Compute classifier %d\n', t);

		% On rééchantillonne les données en fonctions des poids.
		weightedData = gendatw(data, weightsForEachData);

		if strcmp(classifier, 'stump')
			% On calcule une souche binaire sur les données rééchantillonées.
			classifiers{t} = stumpc(weightedData);
		else
			% On calcule un arbre binaire sur les données rééchantillonées.
			classifiers{t} = treec(weightedData);
		end

		% On prédit les labels via notre souche binaire sur les données brutes.
		predictions = data * classifiers{t} * labeld;

		% On calcule la somme des poids des données avec une erreur.
		epsilon{t} = sum(weightsForEachData(predictions ~= trueLabels));

		% Formule magique afin de trouver le poids du classifieur.
		theta{t} = log((C - 1) * (1 - epsilon{t}) / epsilon{t});

		% Calcul des nouveaux poids.
		for i = 1:n

			% Si la donnée a bien été classifiée...
			if trueLabels(i) == predictions(i)
				% ... on diminue son poid pour le prochain classifieur.
				weightsForEachData(i) = weightsForEachData(i) * exp(0);
			% Sinon...
			else
				% ... on augmente son poid pour le prochain classifieur.
				weightsForEachData(i) = weightsForEachData(i) * exp(theta{t});
			end
		end

		% Les poids ne sont plus une distribution de somme 1 donc on divise par la somme.
		sumWeight = sum(weightsForEachData);
		weightsForEachData = weightsForEachData ./ sumWeight;
	end
end