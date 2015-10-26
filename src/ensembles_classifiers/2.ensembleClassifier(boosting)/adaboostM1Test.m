%% adaboostTest: test Adaboost.M1
function [errors] = adaboostM1Test(dataTest, classifiers, weights)

	% Prédiction via l'ensemble de classifieur sur les données de test.
	predictions = adaboostM1Pred(classifiers, weights, dataTest);

	% Récupération des vraies étiquettes
	trueLabels = getlabels(dataTest);

	% Calcul du nombre d'erreurs par rapport aux vraies étiquettes.
	errors = sum(predictions ~= trueLabels) / length(predictions) * 100;
end