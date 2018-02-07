# Spam-Classifier

The project consist of a Spam-Classification Application developed using MATLAB Machine Learning Toolbox. It helps in classifying Spam-Emails among the various E-Mails in the inbox.

Nowdays, most email services provide Spam Filters which help us keeping our inbox clean from spam mails.

First we start by converting each email into a feature vector which can be treated using MATLAB.Then we preprocess the email and then 

## Dataset
Dataset is based on a subset of SpamAssassin Public Corpus. The dataset consist of a vocabulary list, two sample emails to train on and two spam emails.
spamTrain.mat contains 4000 training examples of spam and non-spam email, while spamTest.mat contains 1000 test examples.

## Preprocessing
First we start by converting each email into a feature vector which can be treated using MATLAB.Then we preprocess the email and then 

In processEmail.m, I have implemented the following email preprocessing and normalization steps:
• Lower-casing: The entire email is converted into lower case, so that captialization is ignored (e.g., IndIcaTE is treated the same as Indicate). 
• Stripping HTML: All HTML tags are removed from the emails. Many emails often come with HTML formatting; we remove all the HTML tags, so that only the content remains. 
• Normalizing URLs: All URLs are replaced with the text “httpaddr”. 
• Normalizing Email Addresses: All email addresses are replaced with the text “emailaddr”. 
• Normalizing Numbers: All numbers are replaced with the text “number”. 
• Normalizing Dollars: All dollar signs ($) are replaced with the text “dollar”. 
• Word Stemming: Words are reduced to their stemmed form. For example, “discount”, “discounts”, “discounted” and “discounting” are all replaced with “discount”. Sometimes, the Stemmer actually strips o↵ additional characters from the end, so “include”, “includes”, “included”, and “including” are all replaced with “includ”. 
• Removal of non-words: Non-words and punctuation have been removed. All white spaces (tabs, newlines, spaces) have all been trimmed to a single space character.

While preprocessing has left word fragments and non-words, this form turns out to be much easier to work with for performing feature extraction.


## Vocabulary List
After preprocessing the emails, we have a list of words for each email. The next step is to choose which words we would like to use in our classiﬁer and which we would want to leave out. For this, we have chosen only the most frequently occuring words as our set of words considered (the vocabulary list). Since words that occur rarely in the training set are only in a few emails, they might cause the model to overﬁt our training set. The complete vocabulary list is in the ﬁle vocab.txt. The vocabulary list was selected by choosing all words which occur at least a 100 times in the spam corpus, resulting in a list of 1899 words.  Given the vocabulary list, we now map each word in the preprocessed emails into a list of word indices that contains the index of the word in the vocabulary list.  Speciﬁcally, in the sample email, the word “anyone” was ﬁrst normalized to “anyon” and then mapped onto the index 86 in the vocabulary list. In the code, a string str is given which is a single word from the processed email. Then we look up the word in the vocabulary list vocabList and ﬁnd if the word exists in the vocabulary list. If the word exists, we add the index of the word into the word indices variable. If the word does not exist, and is therefore not in the vocabulary, we skip the word. 


## Extracting Features from Emails 

We then implemented the feature extraction that converts each email into a vector in Rn. Speciﬁcally, the feature for an email corresponds to whether the i-th word in the dictionary occurs in the email. 


## Training SVM for Spam Classiﬁcation 
After we have completed the feature extraction functions, the next step will load a preprocessed training dataset that will be used to train a SVM classiﬁer. Each original email was processed using the processEmail and emailFeatures functions and converted into a vector x(i). After loading the dataset, we will proceed to train a SVM to classify between spam (y = 1) and non-spam ( y = 0) emails. Once the training completes,we should see that the classiﬁer gets a training accuracy of about 99.8% and a test accuracy of about 98.5%.

SVMTRAIN Trains an SVM classifier using a simplified version of the SMO 
algorithm. 
   [model] = SVMTRAIN(X, Y, C, kernelFunction, tol, max_passes) trains an SVM classifier and returns trained model. X is the matrix of training examples.  Each row is a training example, and the jth column holds the jth feature.  Y is a column matrix containing 1 for positive examples and 0 for negative examples.  C is the standard SVM regularization parameter.  tol is a tolerance value used for determining equality of floating point numbers. max_passes controls the number of iterations over the dataset (without changes to alpha) before the algorithm quits.

 Note: This is a simplified version of the SMO algorithm for training SVMs. In practice, if we want to train an SVM classifier, we
       preferably use an optimized package such as:  

           LIBSVM   (http://www.csie.ntu.edu.tw/~cjlin/libsvm/)
           SVMLight (http://svmlight.joachims.org/)

We pre-compute the Kernel Matrix since our dataset is small (in practice, optimized SVM packages that handle large datasets
 gracefully will _not_ do this) I have implemented optimized vectorized version of the Kernels here so
that the svm training will run faster.

#### RBFKERNEL returns a radial basis function kernel between x1 and x2
