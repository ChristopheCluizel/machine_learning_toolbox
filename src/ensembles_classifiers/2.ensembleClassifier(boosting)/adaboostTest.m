%% adaboostTest: test Adaboost
function [errors] = adaboostTest(dataTest, classifiers, weights)

	% Prédiction via l'ensemble de classifieur sur les données de test.
	predictions = adaboostPred(classifiers, weights, dataTest);

	% Récupération des vraies étiquettes
	trueLabels = getlabels(dataTest);

	% Calcul du nombre d'erreurs par rapport aux vraies étiquettes.
	errors = sum(predictions ~= trueLabels) / length(predictions) * 100;
end