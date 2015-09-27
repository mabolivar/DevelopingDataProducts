#=========================================================
#Set working directory
#=========================================================
setwd("C:/Users/ma.bolivar643/Dropbox/3. DSS/DevelopingDataProducts")

#=========================================================
# Libraries
#=========================================================
library(readr)
library(dplyr)
library(stringr)
library(caret)
library(caTools)
library(glmnet)
#=========================================================

d <- read_csv("./data/tidy.csv")

#Neighborhood as factor
d$neigh <- d$neigh %>% as.factor
#Use only complete cases  
d <- subset(d,complete.cases(d))

#Exploration analysis

#price
d[order(d$price,decreasing = T),]
d <- filter(d, price <= 5.00e+06) 
hist((d$price))
hist(log(d$price))
d$logprice <- log(d$price)

#Area
hist((d$area))
hist(log(d$area))
d$logarea <- log(d$area)
d$logarea2 <- log(d$area)^2

#Rooms
hist((d$rms))

#Bath/Rooms
d$br <- d$bathr/d$rms

#Area/Rooms
d$ar <- d$area/d$rms

pairs(d)


#Predictive models
set.seed(111)
tobs <- sample.split(d$price,.7)
train <- d[tobs,]
test <- d[-tobs,]

lm1 <- lm(price ~ .-logprice -area - published,data=train)
summary(lm1)

pred_lm <- predict(lm1, newdata=test)
MSE_lm <- mean((pred_lm-test$price)^2) #Test error
MSE_lm
sqrt(MSE_lm)
plot(pred_lm,test$price)


#Ridge & Lasso

x <- model.matrix(price ~ . -logprice -area - published,data=train)[,-1] #removes intercept
y <- train$price

x_t <- model.matrix(price ~ . -logprice -area - published,data=test)[,-1] #removes intercept
y_t <- test$price

##CV
set.seed(123)
cv.out <- cv.glmnet(x,y,alpha=1)
plot(cv.out)

bestlam.ri <- cv.out$lambda.min

ridge.pred <- predict(cv.out,s=bestlam.ri,newx=x_t)
coef(cv.out)
MSE_ri <- mean((y_t-ridge.pred)^2)
MSE_ri
sqrt(MSE_ri)

#RF
fitControl <- trainControl(## 10-fold CV
  method = "cv",
  number = 10,
  ## repeated ten times
  repeats = 1
  )


mf_rf <- train(train$price ~ . -logprice -area - published,
               method = "rf",data=train,
               trControl=fitControl) 
mf_rf
pred_rf <- predict(mf_rf,newdata=test)
MSE_rf <- mean((test$price-pred_rf)^2)

a <- data.frame(test, e=(test$price-pred_rf)^2)
tapply(a$e,INDEX = a$neigh, function(x) sqrt(mean(x)))

plot(pred_rf,test$price, col=test$neigh)
abline(0,1,col=2)

apto <- data.frame(neigh="MARLY", bathr=1, 
                   rms=1, area= 25,logarea = log(25), logarea2=log(25)^2,
                   published=as.Date("05/05/2015"), logprice=0)
apto <- data.frame(neigh="ROSALES", bathr=1, 
                   rms=1, area= 50,logarea = log(50), logarea2=log(50)^2,
                   published=as.Date("05/05/2015"), logprice=0)
apto <- data.frame(neigh="TEUSAQUILLO", bathr=1, 
                   rms=1, area= 25,logarea = log(25), logarea2=log(35)^2,
                   published=as.Date("05/05/2015"), logprice=0)

mf_rf <- train(price ~ . -logprice -area - published,
               method = "rf",mtry=2,data=d,
               trControl=fitControl) 
mf_rf$finalModel

predict(mf_rf,newdata=apto)
