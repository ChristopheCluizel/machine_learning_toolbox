
clear all; close all;
% ============ AdaBoost.M1 ==============
% loading a given datasets.
% The mat files have been generated so that it contains two matrices:
%  - X: a n by d matrix that contains the input values
%  - Y: a column vector of n output values (class indexes)

% fileName = 'synth8.mat'
% fileName = 'segment.mat'
fileName = 'synth4.mat';
rawData = load(strcat('../../resources/datasets/', fileName));
fprintf('Dataset used: %s\n', fileName);

% Création du PRDataSet de la bibliothèque PRTools.
data = prdataset(rawData.X, rawData.Y);

% Séparation des données en données d'apprentissage et en données de test.
[dataApp, dataTest] = gendat(data, 0.6);

T = 100; % Nombre de classifieurs que l'on veut apprendre.

% Apprentissage des classifieurs sur les données d'apprentissage.
learningType = 'tree';
[classifiers, weights] = adaboostM1Learn(dataApp, T, learningType);

testError = adaboostM1Test(dataTest, classifiers, weights);

fprintf('Error on dataTest for AdaBoost.M1 method with %s classifiers: %f\n', learningType, testError);
