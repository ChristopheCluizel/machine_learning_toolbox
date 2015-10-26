clear all; close all;

% ============ AdaBoost ==============
% loading a given datasets.
% The mat files have been generated so that it contains a structure with 2 members:
%  - X: a n by d matrix that contains the input values
%  - Y: a column vector of n labels 0 or 1

% fileName = 'ionosphere.mat';
fileName = 'diabetes.mat';
rawData = load(strcat('../../resources/datasets/', fileName));
fprintf('Dataset used: %s\n', fileName);

% Transformation des 0 en -1.
rawData.Y(rawData.Y == 0) = -1;

% Création du PRDataSet de la bibliothèque PRTools.
data = prdataset(rawData.X, rawData.Y);

% Séparation des données en données d'apprentissage et en données de test.
[dataApp, dataTest] = gendat(data, 0.6);

T = 100; % Nombre de classifieurs que l'on veut apprendre.

% Apprentissage des classifieurs sur les données d'apprentissage.
% Utilisation avec 'tree' ou avec 'stump'
learningType = 'tree';
[classifiers, weights] = adaboostLearn(dataApp, T, learningType);

testError = adaboostTest(dataTest, classifiers, weights);

fprintf('Error on dataTest for AdaBoost method with %s classifiers: %f\n', learningType, testError);
