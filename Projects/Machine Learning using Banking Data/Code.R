################
#Classification#
################

library("readxl")
library('car')
library(aod)
library(glmnet)
library('pgmm')
library('nnet')
library('class')
library('e1071')	#first install class and then this one
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

##############
### PART I ### 
##############


#First, we have to split in train, test and validation datasets.
# 70-20-10 split respectively
n <- dim(ds)[1]
set.seed(1)
te<- sample(1:n, round(n*0.3), replace=FALSE)
#Train 70%
train <- data.frame(ds[-te,])

ds30 <- data.frame(ds[te,])
n_ds30 <- dim(ds30)[1]
set.seed(1)
val <- sample(1:n_ds30, round(n_ds30*0.33), replace = FALSE)
#Test 20%
X_test <-data.frame(ds30[-val,-20])
y_test <-data.frame(ds30[-val,20])
#Validation 10%
X_val <- data.frame(ds30[val,-20])
y_val <- data.frame(ds30[val,20])

#We can see that we have implemented the split that we wanted
dim(train)[1]/dim(ds)[1] #~70%
dim(X_test)[1]/dim(ds)[1]#~20%
dim(X_val)[1]/dim(ds)[1] #~10% 


#Naive Bayes
nb_test <- naiveBayes(SUBSCRIBED ~ ., data = train)
pr_test <- predict(nb_test, X_test)

conf_NB <- table(y_test[,1], pr_test) #Confusion Matrix for Naive Bayes
conf_NB
acuraccy_nb <- sum(y_test[,1] == pr_test)/dim(y_test)[1] #ACCURACY
acuraccy_nb
precision_nb <- conf_NB[2,2]/(conf_NB[1,2]+conf_NB[2,2]) #PRECISION
precision_nb
recall_nb <- conf_NB[2,2]/(conf_NB[2,1]+conf_NB[2,2]) #RECALL
recall_nb
f1_nb <- 2*((precision_nb*recall_nb)/(precision_nb+recall_nb))
f1_nb


#Forest

df1 <- matrix(data=NA, ncol= 1, nrow = 15)
for (i in 3:17){
  forest_test <- randomForest(as.factor(SUBSCRIBED) ~ ., data=train, ntree=150,
                              mtry=i, importance=TRUE)
  pr_fr_test <- predict(forest_test, newdata=X_test, type='class')
  conf_RF <- table(y_test[,1], pr_fr_test) #Confusion Matrix for Random Forest
  precision_RF <- conf_RF[2,2]/(conf_RF[1,2]+conf_RF[2,2]) #PRECISION
  recall_RF <- conf_RF[2,2]/(conf_RF[2,1]+conf_RF[2,2]) #RECALL
  df1[i-2,] <- 2*((precision_RF*recall_RF)/(precision_RF + recall_RF))#F1 score
}
max(df1) #mtry 15

df2 <- matrix(data=NA, ncol= 1, nrow = 15)
for (i in 3:17){
  forest_test <- randomForest(as.factor(SUBSCRIBED) ~ ., data=train, ntree=200,
                              mtry=i, importance=TRUE)
  pr_fr_test <- predict(forest_test, newdata=X_test, type='class')
  conf_RF <- table(y_test[,1], pr_fr_test) #Confusion Matrix for Random Forest
  precision_RF <- conf_RF[2,2]/(conf_RF[1,2]+conf_RF[2,2]) #PRECISION
  recall_RF <- conf_RF[2,2]/(conf_RF[2,1]+conf_RF[2,2]) #RECALL
  df2[i-2,] <- 2*((precision_RF*recall_RF)/(precision_RF + recall_RF))#F1 score
}
max(df2) #mtry 16

df3 <- matrix(data=NA, ncol= 1, nrow = 15)
for (i in 3:17){
  forest_test <- randomForest(as.factor(SUBSCRIBED) ~ ., data=train, ntree=250,
                              mtry=i, importance=TRUE)
  pr_fr_test <- predict(forest_test, newdata=X_test, type='class')
  conf_RF <- table(y_test[,1], pr_fr_test) #Confusion Matrix for Random Forest
  precision_RF <- conf_RF[2,2]/(conf_RF[1,2]+conf_RF[2,2]) #PRECISION
  recall_RF <- conf_RF[2,2]/(conf_RF[2,1]+conf_RF[2,2]) #RECALL
  df3[i-2,] <- 2*((precision_RF*recall_RF)/(precision_RF + recall_RF))#F1 score
}
max(df3) #mtry 17

df4 <- matrix(data=NA, ncol= 1, nrow = 15)
for (i in 3:17){
  forest_test <- randomForest(as.factor(SUBSCRIBED) ~ ., data=train, ntree=300,
                              mtry=i, importance=TRUE)
  pr_fr_test <- predict(forest_test, newdata=X_test, type='class')
  conf_RF <- table(y_test[,1], pr_fr_test) #Confusion Matrix for Random Forest
  precision_RF <- conf_RF[2,2]/(conf_RF[1,2]+conf_RF[2,2]) #PRECISION
  recall_RF <- conf_RF[2,2]/(conf_RF[2,1]+conf_RF[2,2]) #RECALL
  df4[i-2,] <- 2*((precision_RF*recall_RF)/(precision_RF + recall_RF))#F1 score
}
max(df4) #mtry 15

max(df1,df2,df3,df4)

#So, the best Random Forest is for 200 trees and 16 variables.
forest_test <- randomForest(as.factor(SUBSCRIBED) ~ ., data=train, ntree=200,
                            mtry=16, importance=TRUE)
pr_fr_test <- predict(forest_test, newdata=X_test, type='class')

conf_RF <- table(y_test[,1], pr_fr_test) #Confusion Matrix for Random Forest
conf_RF

sum(y_test[,1] == pr_fr_test)/dim(y_test)[1]#ACCURACY
precision_RF <- conf_RF[2,2]/(conf_RF[1,2]+conf_RF[2,2]) #PRECISION
recall_RF <- conf_RF[2,2]/(conf_RF[2,1]+conf_RF[2,2]) #RECALL
f1_RF <- 2*((precision_RF*recall_RF)/(precision_RF + recall_RF)) #F1-score
f1_RF

#Logistic Regression

par(mfrow=c(1,1))
#Take only the numeric variables
index <- sapply(train, class) == "numeric"
train_num <- train[index]
require(corrplot)
corrplot(cor(train_num),method = 'number')

fullmodel <- glm(SUBSCRIBED ~. , data=train, family='binomial')
summary(fullmodel)

#lasso
lambdas <- 10 ^ seq(8,-4,length=250)
x_matrix <- model.matrix(fullmodel)[,-1]
fit_lasso <- glmnet(x_matrix, train$SUBSCRIBED, alpha=1, lambda=lambdas, family="binomial")

plot(fit_lasso, label = TRUE)

lasso.cv <- cv.glmnet(x_matrix, train$SUBSCRIBED, alpha=1, lambda=lambdas, family="binomial", type.measure='class')
plot(lasso.cv)
coef(fit_lasso, s = lasso.cv$lambda.1se)

model1 <- glm(SUBSCRIBED ~. -age -euribor3m, data=train, family='binomial')
summary(model1)

#STEPWISE
#AIC
step(model1, trace=TRUE, direction = 'both', k = 2)

model2 <- glm(formula = SUBSCRIBED ~ job + marital + default + loan + contact + 
                month + day_of_week + duration + campaign + poutcome + emp.var.rate + 
                cons.price.idx + cons.conf.idx + nr.employed, family = "binomial", 
              data = train)

vif(model2)#High GVIF value in emp.var.rate. We have to remove it (multicolinearity issues)

model3 <- glm(formula = SUBSCRIBED ~ job + marital + default + loan + contact + 
                month + day_of_week + duration + campaign + poutcome + 
                cons.price.idx + cons.conf.idx + nr.employed, family = "binomial", 
              data = train)

vif(model3)#No multicolinearity issue
summary(model3)

predict_reg <- predict(model3, X_test, type = "response")
predict_reg  #It gives probabilities. How we will define the optimal threshold???

#If we take p > 0.5 as threshold, we take the following results
prediction <- as.integer(predict_reg > 0.5)
confusion_mat <- addmargins(table(y_test[,1], prediction))

# Labeling
names(dimnames(confusion_mat)) <- c("True status", "Prediction")
colnames(confusion_mat) <- c("No", "Yes", "Total")
rownames(confusion_mat) <- c("No", "Yes", "Total")
confusion_mat

acuraccy_lr1 <- (confusion_mat[1,1] + confusion_mat[2,2])/ confusion_mat[3,3]#ACCURACY
acuraccy_lr1

precision_lr1 <- confusion_mat[2,2]/(confusion_mat[1,2]+confusion_mat[2,2]) #PRECISION
precision_lr1

recall_lr1 <- confusion_mat[2,2]/(confusion_mat[2,1]+confusion_mat[2,2]) #RECALL
recall_lr1

f1_lr1 <- 2*((precision_lr1*recall_lr1)/(precision_lr1+recall_lr1))
f1_lr1


library(magrittr)
library(dplyr)
library(ROCR)
prediction(predict_reg, y_test[,1]) %>%
  performance(measure = "tpr", x.measure = "fpr") -> result

plotdata <- data.frame(x = result@x.values[[1]],
                       y = result@y.values[[1]], 
                       p = result@alpha.values[[1]])

library(ggplot2) 
p <- ggplot(data = plotdata) +
  geom_path(aes(x = x, y = y)) + 
  xlab(result@x.name) +
  ylab(result@y.name) +
  theme_bw() + 
  geom_abline()

dist_vec <- plotdata$x^2 + (1 - plotdata$y)^2
opt_pos <- which.min(dist_vec) #Find the min distance from True Positive Rate = 1

p + 
  geom_point(data = plotdata[opt_pos, ], 
             aes(x = x, y = y), col = "red") +
  annotate("text", 
           x = plotdata[opt_pos, ]$x + 0.1,
           y = plotdata[opt_pos, ]$y,
           label = paste("p =", round(plotdata[opt_pos, ]$p, 3)))

#So, the optimal threshold is p = 0.096
prediction2 <- as.integer(predict_reg > 0.096)
confusion_mat2 <- addmargins(table(y_test[,1], prediction2))

# Labeling
names(dimnames(confusion_mat2)) <- c("True status", "Prediction")
colnames(confusion_mat2) <- c("No", "Yes", "Total")
rownames(confusion_mat2) <- c("No", "Yes", "Total")
confusion_mat2

acuraccy_lr2 <- (confusion_mat2[1,1] + confusion_mat2[2,2])/ confusion_mat2[3,3]#ACCURACY
acuraccy_lr2

precision_lr2 <- confusion_mat2[2,2]/(confusion_mat2[1,2]+confusion_mat2[2,2]) #PRECISION
precision_lr2

recall_lr2 <- confusion_mat2[2,2]/(confusion_mat2[2,1]+confusion_mat2[2,2]) #RECALL
recall_lr2

f1_lr2 <- 2*((precision_lr2*recall_lr2)/(precision_lr2+recall_lr2))#F1-score
f1_lr2



#VALIDATION of the best model (e.g., Random Forest) based on F1-score.

forest_val <- randomForest(as.factor(SUBSCRIBED) ~ ., data=train, ntree=200,
                            mtry=16, importance=TRUE)
pr_fr_val <- predict(forest_val, newdata=X_val, type='class')

conf_RF_val <- table(y_val[,1], pr_fr_val) #Confusion Matrix for Random Forest
conf_RF_val

sum(y_val[,1] == pr_fr_val)/dim(y_val)[1]#ACCURACY
precision_RF_val <- conf_RF_val[2,2]/(conf_RF_val[1,2]+conf_RF_val[2,2]) #PRECISION
recall_RF_val <- conf_RF_val[2,2]/(conf_RF_val[2,1]+conf_RF_val[2,2]) #RECALL
f1_RF_val <- 2*((precision_RF_val*recall_RF_val)/(precision_RF_val + recall_RF_val)) #F1-score
f1_RF_val



############
#Clustering#
############

library("readxl")
library(cluster)
library(factoextra)
library(gower)
library(mclust)

clients <- read_excel('project I  2021-2022.xls')
sum(is.na(clients)) #Checked for NAs
str(clients)


##Bank Client Data
clients$job <- as.factor(clients$job)
clients$marital <- as.factor(clients$marital)
clients$education <- as.factor(clients$education)
clients$default <- as.factor(clients$default)
clients$housing <- as.factor(clients$housing)
clients$loan <- as.factor(clients$loan)

##Other attributes
clients$poutcome <- as.factor(clients$poutcome)
sum(clients$pdays==999)/nrow(clients) #97% from total rows have 999 as value (not been contacted)
clients$pdays <- NULL

#We will remove the columns that we will not use.
clients$contact <- NULL
clients$month <- NULL
clients$day_of_week<- NULL
clients$duration <- NULL
clients$emp.var.rate <- NULL
clients$cons.price.idx <- NULL
clients$cons.conf.idx <- NULL
clients$euribor3m <- NULL
clients$nr.employed <- NULL
clients$SUBSCRIBED <- as.factor(clients$SUBSCRIBED)
ground_truth <- as.data.frame(clients$SUBSCRIBED)
clients$SUBSCRIBED <- NULL

str(clients)

#Take a random sample of 10.000 observations
set.seed(2)
index <- sample(1:nrow(clients), size = 10000, replace = FALSE)
clients2 <- clients[index,]
head(clients2)
ground_truth2 <- ground_truth[index,] #It contains only the column SUBSCRIBED

#Create distance matrix using Gower Distance
dist1 <- daisy(clients2, metric = "gower")
cls <- hclust(dist1, method = "ward.D")

par(mfrow=c(1,1))
plot(cls)
rect.hclust(cls, k=2, border="red")
cutree(cls, k = 2)


#Height plot
plot(cls$height)

par(mfrow=c(1,1))
plot(silhouette(cutree(cls, k = 2), dist = dist1), border=NA, col='darkgreen')
plot(silhouette(cutree(cls, k = 3), dist = dist1), border=NA)
plot(silhouette(cutree(cls, k = 4), dist = dist1), border=NA)
plot(silhouette(cutree(cls, k = 5), dist = dist1), border=NA)

table((cutree(cls, k=2)), ground_truth2)
adjustedRandIndex((cutree(cls, k=2)),ground_truth2) #Check with subscribers/non subscribers
#We get negative adjusted rand index which means that 
#the agreement is less than what is expected from a random result.


df1 <- clients2[which(cutree(cls, k = 2)==1),]
df2 <- clients2[which(cutree(cls, k = 2)==2),]

summary(df1)
summary(df2)

par(mfrow=c(1,2))
#age
hist(df1$age)
hist(df2$age)

#job
x11 <- barplot(table(df1$job), xaxt="n", col = "royal blue", main='Cluster 1')
labs <- paste(names(table(df1$job)))
text(cex=0.8, x=x11+.25, y=-.25, labs, xpd=TRUE, srt=45, adj=1.1)

x22 <- barplot(table(df2$job), xaxt="n", col = "dark orange", main='Cluster 2')
labs <- paste(names(table(df2$job)))
text(cex=0.8, x=x22+.25, y=-.25, labs, xpd=TRUE, srt=45, adj=1.1)

#marital
plot(df1$marital)
plot(df2$marital)

#education
x1 <- barplot(table(df1$education), xaxt="n", col = "royal blue", main='Cluster 1')
labs <- paste(names(table(df1$education)))
text(cex=0.8, x=x1+0.25, y=-.25, labs, xpd=TRUE, srt=45, adj=1.1)

x2 <- barplot(table(df2$education), xaxt="n", col = "dark orange", main='Cluster 2')
labs <- paste(names(table(df2$education)))
text(cex=0.8, x=x2+0.25, y=-.25, labs, xpd=TRUE, srt=45, adj=1.1)

#loan
plot(df1$default)
plot(df2$default)

#loan
plot(df1$housing)
plot(df2$housing)

#loan
plot(df1$loan)
plot(df2$loan)

#campaign
hist(df1$campaign)
hist(df2$campaign)

#previous
hist(df1$previous)
hist(df2$previous)

#poutcome
plot(df1$poutcome)
plot(df2$poutcome)
