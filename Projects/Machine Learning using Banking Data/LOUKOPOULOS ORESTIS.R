setwd("~/Library/Mobile Documents/com~apple~CloudDocs/MASTER/MSc Business Analytics/Semester 2/Statistics for BA 2/Project 2")
library("readxl")
library('car')
library(aod)
library(glmnet)
library('pgmm')
library('nnet')
library('class')
library('e1071')	#first install class and then this one
library('penalizedLDA')
library('MASS')
library('heplots')
library('tree')
library('mclust')
library(randomForest)

ds <- read_excel('project I  2021-2022.xls')
sum(is.na(ds)) #Checked for NAs
str(ds)

#Cleaning

##Bank Client Data
ds$job <- as.factor(ds$job)
ds$marital <- as.factor(ds$marital)
ds$education <- as.factor(ds$education)
ds$default <- as.factor(ds$default)
ds$housing <- as.factor(ds$housing)
ds$loan <- as.factor(ds$loan)

##Related with the last contact of the current campaign
ds$contact <- as.factor(ds$contact)
ds$month <- as.factor(ds$month) #We do not have January and February in months
ds$day_of_week <-  as.factor(ds$day_of_week)

##Other attributes
ds$poutcome <- as.factor(ds$poutcome)
sum(ds$pdays==999)/nrow(ds) #97% from total rows have 999 as value (not been contacted)
ds$pdays <- NULL


##Response
ds$SUBSCRIBED <- as.factor(ds$SUBSCRIBED)
levels(ds$SUBSCRIBED) <- c(0,1)

# ds$job <- factor(ds$job, labels=c(1:12))
# ds$marital <- factor(ds$marital, labels=c(1:4))
# ds$education <- factor(ds$education, labels=c(1:8))
# ds$default <- factor(ds$default, labels=c(1:3))
# ds$housing <- factor(ds$housing, labels=c(1:3))
# ds$loan <- factor(ds$loan, labels=c(1:3))
# ds$contact <- factor(ds$contact, labels=c(1:2))
# ds$month <- factor(ds$month, labels=c(4, 8, 12, 7, 6, 3, 5, 11, 10, 9))
# ds$day_of_week <- factor(ds$day_of_week, labels=c(5, 1, 4, 2, 3))
# ds$poutcome <- factor(ds$poutcome, labels=c(1:3))
# ds$SUBSCRIBED <- factor(ds$SUBSCRIBED, labels=c(0,1))
# 
# sum(ds$pdays==999)/nrow(ds) #97% from total rows have 999 as value (not been contacted)
# ds$pdays <- NULL



##############
### PART I ### 
##############


#Discriminant analysis assumes a multivariate normal distribution 
#because what we usually consider to be predictors are really a multivariate dependent variable, 
#and the grouping variable is considered to be a predictor. 
#This means that categorical variables that are to be treated as predictors 
#in the sense you wish are not handled well. This is one reason that many, including myself, 
#consider discriminant analysis to have been made obsolete by logistic regression.

#First, we have to split in train and test datasets.
n <- dim(ds)[1]
# k=5-fold cross-validation
k <- 5
set.seed(1)
indexes<-sample(1:n)	#random permutation of the rows

methods <- c('knn_3', 'knn_4', 'knn_5', 'knn_6', 'knn_7', 'knn_8', 
             'knn_9', 'knn_10', 'knn_11', 'knn_12', 'knn_13', 'knn_14', 'knn_15', 
             'knn_16', 'knn_17', 'knn_18', 'naiveBayes', 'tree', 'forest')
accuracy <- matrix(data=NA, ncol= k, nrow = length(methods))
rownames(accuracy) <- methods

#Naive Bayes
for (i in 1:k){
  te <- indexes[ ((i-1)*(n/k)+1):(i*(n/k))]	
  train <- ds[-te, ]
  train[,'SUBSCRIBED'] <- as.factor(train$SUBSCRIBED)
  test <- ds[te, -20]
  #Naive Bayes
  z_nb <- naiveBayes(SUBSCRIBED ~ ., data = train)
  pr_nb <- predict(z_nb, test)
  accuracy['naiveBayes',i]<- sum(ds[te,]$SUBSCRIBED == pr_nb)/dim(test)[1]
}
mean_k <- apply(accuracy, 1, mean)




#Forest
df1 <- data.frame()
for (i in 1:17){
forest <- randomForest(as.factor(SUBSCRIBED) ~ ., data=train, ntree=250,
                       mtry=i, importance=TRUE)

pr_fo <- predict(forest,newdata=test,type='class')
acc_fo <- sum(ds[te,]$SUBSCRIBED == pr_fo)/dim(test)[1]
df1[i,1] <- i
df1[i,2] <- acc_fo
}
colnames(df1) <- c('mtry', 'accuracy')
df1 #So, the optimal number of variables for each tree is equal to 11.
lines(df1$mtry, df1$accuracy)

cm <- table(pr_fo, ds[te,]$SUBSCRIBED)
missclf_eror <- 1 - (sum(diag(cm))/sum(cm))

for (i in 1:k){
  te <- indexes[ ((i-1)*(n/k)+1):(i*(n/k))]	
  train <- ds[-te, ]
  train[,'SUBSCRIBED'] <- as.factor(train$SUBSCRIBED)
  test <- ds[te, -20]
  #Tree
  forest <- randomForest(as.factor(SUBSCRIBED) ~ ., data=train, ntree=250,
                         mtry=11, importance=TRUE)
  pr_fr <- predict(forest, newdata=test, type='class')
  accuracy['forest',i]<- sum(ds[te,]$SUBSCRIBED == pr_fr)/dim(test)[1]
}
