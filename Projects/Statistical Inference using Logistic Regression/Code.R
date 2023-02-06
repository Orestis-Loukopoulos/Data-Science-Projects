#Load packages
library("readxl")
library('car')
library(aod)
library(glmnet)
ds <- read_excel('project I  2021-2022.xls')
View(ds)
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

str(ds)


par(mfrow=c(1,1))
#Take only the numeric variables
index <- sapply(ds, class) == "numeric"
ds_num <- ds[index]
require(corrplot)
corrplot(cor(ds_num),method = 'number')

#Take only the categorical variables (in order to be ready if I have to center to interpret the intercept)
indexf <- sapply(ds, class) == "factor"
ds_factor <- ds[indexf]


##MODELS
nullmodel <- glm(SUBSCRIBED~1, data=ds, family = binomial(link = "logit")) #Only intercept model
summary(nullmodel)

fullmodel <- glm(SUBSCRIBED~., data=ds, family = binomial(link = "logit"))
summary(fullmodel)

#LASSO
lambdas <- 10 ^ seq(8,-4,length=250)
x_matrix <- model.matrix(fullmodel)[,-1]
fit_lasso <- glmnet(x_matrix, ds$SUBSCRIBED, alpha=1, lambda=lambdas, family="binomial")

plot(fit_lasso, label = TRUE)
plot(fit_lasso, xvar = "lambda", label = TRUE)

lasso.cv <- cv.glmnet(x_matrix, ds$SUBSCRIBED, alpha=1, lambda=lambdas, family="binomial", type.measure='class')
plot(lasso.cv)
coef(fit_lasso, s = lasso.cv$lambda.min)
coef(fit_lasso, s = lasso.cv$lambda.1se)

model1 <- glm(formula = SUBSCRIBED ~ job + marital + education + default + 
                housing + loan + contact + month + day_of_week + duration +
                campaign + poutcome + emp.var.rate + cons.price.idx + nr.employed , family = binomial(link = "logit"), data = ds)

summary(model1)

#STEPWISE
#BIC
step(model1, trace=TRUE, direction = 'both', k = log(nrow(ds)))

model2 <- glm(formula = SUBSCRIBED ~ default + contact + month + duration + 
                campaign + poutcome + emp.var.rate + cons.price.idx + nr.employed, 
              family = binomial(link = "logit"), data = ds)

vif(model2) #I will drop emp.var.rate because of multicolinearity issue

model3 <- glm(formula = SUBSCRIBED ~ default + contact + month + duration + 
                campaign + poutcome + cons.price.idx + nr.employed, 
              family = binomial(link = "logit"), data = ds)

vif(model3)
summary(model3)


#Wald Test
wald.test(b = coef(model3), Sigma = vcov(model3), Terms = 1:18)
wald.test(b = coef(model3), Sigma = vcov(model3), Terms = 18) # covariate cons.price.idx is statistically insignificant

#Create model4 which is a reduced model3 (without cons.price.idx)
model4 <- glm(formula = SUBSCRIBED ~ default + contact + month + duration + 
                campaign + poutcome + nr.employed, 
              family = binomial(link = "logit"), data = ds)

summary(model4)


#Compare model3 with model4(reduced - without cons.price.idx) [LRT Test]
anova(model3, model4, test='LRT') #There is a statistically significant difference between the means of the model3 and model4 (reduced model3 - without cons.price.idx -)

#Goodness of Fit model4
with(model4, pchisq(deviance, df.residual,lower.tail = FALSE)) #Good fit

#Compare final model against the null model 
with(model4, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))# There is significant difference between our model and the null model



#Deviance Residuals
par(mfrow = c(2,4), mar = c(5,5,1,1))
plot(as.numeric(ds$default), resid(model4, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'default', xaxt = 'n',cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 0.6)
axis(1, at = 1:3, labels = levels(ds$default))
plot(as.numeric(ds$contact), resid(model4, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'contact', xaxt='n',cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 1.5)
axis(1, at = 1:2, labels = levels(ds$contact))
plot(as.numeric(ds$month), resid(model4, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'month', xaxt = 'n', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 0.6)
axis(1, at = 1:10, labels = levels(ds$month))
plot(ds$duration, resid(model4, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'duration', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 0.6)
plot(as.numeric(ds$poutcome), resid(model4, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'poutcome', xaxt = 'n', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 0.6)
axis(1, at = 1:3, labels = levels(ds$poutcome))
plot(ds$campaign, resid(model4, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'campaign', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 0.6)
plot(ds$cons.price.idx, resid(model4, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'cons.price.idx', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 0.6)
plot(ds$nr.employed , resid(model4, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'nr.employed', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 0.6)
dev.off()


summary(model4) #To interpret the rest covariates

