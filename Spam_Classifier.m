%Spam Classification with SVMs

clear ; close all; clc

% ==================== Part 1: Email Preprocessing ====================
%  To use an SVM to classify emails into Spam v.s. Non-Spam, firstly I 
%  converted each email into a vector of features. In this part, I
%  implemented the preprocessing steps for each email.

% Extract Features
file_contents = readFile('emailSample1.txt');
word_indices  = processEmail(file_contents);

% Print Stats
fprintf('Word Indices: \n');
fprintf(' %d', word_indices);
fprintf('\n\n');


% ==================== Part 2: Feature Extraction ====================
%  Then, I converted each email into a vector of features in R^n. 

% Extract Features
file_contents = readFile('emailSample1.txt');
word_indices  = processEmail(file_contents);
features      = emailFeatures(word_indices);

% Print Stats
fprintf('Length of feature vector: %d\n', length(features));
fprintf('Number of non-zero entries: %d\n', sum(features > 0));

% =========== Part 3: Train Linear SVM for Spam Classification ========
%  In this section, I trained a linear classifier to determine if an
%  email is Spam or Not-Spam.

% Load the Spam Email dataset
load('spamTrain.mat');

C = 0.1;
model = svmTrain(X, y, C, @linearKernel);

p = svmPredict(model, X);

fprintf('Training Accuracy: %f\n', mean(double(p == y)) * 100);


% =================== Part 4: Test Spam Classification ================
%  After training the classifier, I evaluated it on a test set. There is 
%  a test set included in spamTest.mat

% Load the test dataset
load('spamTest.mat');

p = svmPredict(model, Xtest);

fprintf('Test Accuracy: %f\n', mean(double(p == ytest)) * 100);


% ================= Part 5: Top Predictors of Spam ====================
%  Since the model we have trained is a linear SVM, we can inspect the
%  weights learned by the model to understand better how it is determining
%  whether an email is spam or not. The following code finds the words with
%  the highest weights in the classifier. Informally, the classifier
%  'thinks' that these words are the most likely indicators of spam.


% Sort the weights and obtain the vocabulary list
[weight, idx] = sort(model.w, 'descend');
vocabList = getVocabList();

fprintf('\nTop predictors of spam: \n');
for i = 1:15
    fprintf(' %-15s (%f) \n', vocabList{idx(i)}, weight(i));
end



% =================== Part 6: Try Your Own Emails =====================
%  Now that we've trained the spam classifier, we can use it on your own
%  emails! I have included spamSample1.txt,spamSample2.txt, 
%  emailSample1.txt and emailSample2.txt as examples. 
%  The following code reads in one of these emails and then uses the 
%  learned SVM classifier to determine whether the email is Spam or 
%  Not Spam

% Set the file to be read in (change this to spamSample2.txt,
% emailSample1.txt or emailSample2.txt to see different predictions on
% different emails types). 
filename = 'spamSample1.txt';

% Read and predict
file_contents = readFile(filename);
word_indices  = processEmail(file_contents);
x             = emailFeatures(word_indices);
p = svmPredict(model, x);

fprintf('\nProcessed %s\n\nSpam Classification: %d\n', filename, p);
fprintf('(1 indicates spam, 0 indicates not spam)\n\n');

