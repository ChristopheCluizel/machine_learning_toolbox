clear;
close all;

data_linearRegression1Feature = load('data/1.linear_regression_1_feature.txt');
data_linearRegression2Features = load('data/2.linear_regression_2_features.txt');
data_logisticRegression2ClassesLinear = load('data/3.logistic_regression_2_classes_linear.txt');
data_logisticRegression2ClassesCircle = load('data/4.logistic_regression_2_classes_circle.txt');
data_handwrittenDigits = load('data/5.handwritten_digits.mat');
data_SVM_classification2ClassesLinear = load('data/6.SVM_classification_2_classes_linear.mat');
data_SVM_classification2ClassesNotLinear = load('data/7.SVM_classification_2_classes_not_linear.mat');
data_SVM_classification2ClassesNotLinearMixedClasses = load('data/8.SVM_classification_2_classes_not_linear_mixedClasses.mat');
data_diabetes = load('data/diabetes.mat');
data_ionosphere = load('data/ionosphere.mat');
data_segment = load('data/segment.mat');
data_synth4 = load('data/synth4.mat');
data_synth8 = load('data/synth8.mat');
data_mnist_uint8 = load('tools/DeepLearnToolbox-master/data/mnist_uint8.mat');
% data_trainingSetHandWritten = loadMNISTImages('data/train-images.idx3-ubyte');

fprintf('data_handwrittenDigits\n');
struct(data_handwrittenDigits)
fprintf('data_SVM_classification2ClassesLinear\n');
struct(data_SVM_classification2ClassesLinear)
fprintf('data_SVM_classification2ClassesNotLinear\n')
struct(data_SVM_classification2ClassesNotLinear)
fprintf('data_SVM_classification2ClassesNotLinearMixedClasses\n')
struct(data_SVM_classification2ClassesNotLinearMixedClasses)
fprintf('data_diabetes\n')
struct(data_diabetes)
fprintf('data_ionosphere\n')
struct(data_ionosphere)
fprintf('data_segment\n')
struct(data_segment)
fprintf('data_synth4\n')
struct(data_synth4)
fprintf('data_synth8\n')
struct(data_synth8)
fprintf('data_mnist_uint8\n')
struct(data_mnist_uint8)
