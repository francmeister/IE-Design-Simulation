load sampleData.mat
traindata

% Make a histogram of known modulation types
histogram(traindata.mod_type)

% boxplot -  a simple way to visualize multiple distributions. This creates a plot where the boxes represent 
% the distribution of the values of x for each of the classes in c. If the values of x are typically significantly 
% different for one class than another, then x is a feature that can distinguish between those classes. The more 
% features you have that can distinguish different classes, the more likely you are to be able to build an accurate 
% classification model from the full data set.
boxplot(traindata.gamma_max,traindata.mod_type)
boxplot(traindata.delta_aa,traindata.mod_type)
boxplot(traindata.kurtosis,traindata.mod_type)
boxplot(traindata.C_20,traindata.mod_type)
boxplot(traindata.C_40,traindata.mod_type)

%Use the command classificationLearner to open the Classification Learner app.
%Select traindata as the data to use.
%The app should correctly detect Character as the response variable to predict.
%Choose the default validation option.
%Select a model and click the Train button.

%Try a few of the standard models with default options. See if you can achieve at least 80% accuracy.

%Note that SVMs work on binary classification problems (i.e. where there are only two classes). To make SVMs work on this problem, the app is fitting many SVMs. These models will therefore be slow to train.

%Similarly, ensemble methods work by fitting multiple models. These will also be slow to train.