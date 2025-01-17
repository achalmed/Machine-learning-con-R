# The tree library is used to construct classification and regression trees.

library (tree)

library (ISLR)
attach (Carseats )
High=ifelse(Sales <=8,"No","Yes")

Carseats =data.frame(Carseats ,High)

tree.carseats =tree(High???.-Sales ,Carseats )

summary (tree.carseats )

plot(tree.carseats )
text(tree.carseats ,pretty =0)

tree.carseats

set.seed (2)
train=sample (1: nrow(Carseats ), 200)
Carseats.test=Carseats [-train ,]
High.test=High[-train ]

tree.carseats =tree(High???.-Sales ,Carseats ,subset =train )
tree.pred=predict (tree.carseats ,Carseats.test ,type ="class")
table(tree.pred ,High.test)

(104+50) /200

set.seed (3)
cv.carseats =cv.tree(tree.carseats ,FUN=prune.misclass )
names(cv.carseats )

par(mfrow =c(1,2))
plot(cv.carseats$size ,cv.carseats$dev ,type="b")
plot(cv.carseats$k ,cv.carseats$dev ,type="b")

prune.carseats =prune.misclass (tree.carseats ,best =9)
plot(prune.carseats )
text(prune.carseats ,pretty =0)

tree.pred=predict (prune.carseats , Carseats.test ,type=" class ")
table(tree.pred ,High.test)

(104+50) /200

prune.carseats =prune.misclass (tree.carseats ,best =15)
plot(prune.carseats )
text(prune.carseats ,pretty =0)
tree.pred=predict (prune.carseats , Carseats.test ,type=" class ")
table(tree.pred ,High.test)

(86+62) /200

## Regression Tree

library (MASS)
set.seed (1)
train = sample (1: nrow(Boston ), nrow(Boston )/2)
tree.boston =tree(medv???.,Boston ,subset =train)
summary (tree.boston )

plot(tree.boston )
text(tree.boston ,pretty =0)

cv.boston =cv.tree(tree.boston )
plot(cv.boston$size ,cv.boston$dev ,type='b')

prune.boston =prune.tree(tree.boston ,best =5)
plot(prune.boston )
text(prune.boston ,pretty =0)

yhat=predict (tree.boston ,newdata =Boston [-train ,])
boston.test=Boston [-train ,"medv"]
plot(yhat ,boston.test)
abline (0,1)
mean((yhat -boston.test)^2)

## Random FOREST

library (randomForest)
set.seed (1)


## Bagging 
bag.boston =randomForest(medv???.,data=Boston ,subset =train ,
                         mtry=13, ntree =25)
yhat.bag = predict (bag.boston ,newdata =Boston [-train ,])
mean(( yhat.bag -boston.test)^2)

## Random Forest

set.seed (1)
rf.boston =randomForest(medv???.,data=Boston ,subset =train ,
                          mtry=6, importance =TRUE)
yhat.rf = predict (rf.boston ,newdata =Boston [-train ,])
mean(( yhat.rf -boston.test)^2)

importance (rf.boston )

varImpPlot (rf.boston )

### Ridge Regression

attach(Hitters)

x=model.matrix(Salary???.,Hitters)[,-1]
y=Hitters$Salary

y=na.omit(y)


library (glmnet )
library(Matrix)
library(foreach)
grid =10^ seq (10,-2, length =100)
ridge.mod =glmnet(x,y,alpha =0, lambda=grid)

dim(coef(ridge.mod ))

ridge.mod$lambda [50]

coef(ridge.mod)[,50]

sqrt(sum(coef(ridge.mod)[ -1 ,50]^2) )

ridge.mod$lambda [60]
coef(ridge.mod)[,60]

sqrt(sum(coef(ridge.mod)[ -1 ,60]^2) )

predict (ridge.mod ,s=50, type =" coefficients")[1:20 ,]

set.seed (1)
train=sample (1: nrow(x), nrow(x)/2)
test=(- train )
y.test=y[test]

ridge.mod =glmnet (x[train ,],y[train],alpha =0, lambda =grid ,
                   thresh =1e -12)
ridge.pred=predict (ridge.mod ,s=4, newx=x[test ,])
mean(( ridge.pred -y.test)^2)

mean(( mean(y[train ])-y.test)^2)

ridge.pred=predict (ridge.mod ,s=1e10 ,newx=x[test ,])
mean(( ridge.pred -y.test)^2)

ridge.pred=predict (ridge.mod ,s=0, newx=x[test ,], exact=T)
mean(( ridge.pred -y.test)^2)

lm(y???x, subset =train)
predict (ridge.mod ,s=0, exact =T,type=" coefficients") [1:20 ,]

set.seed (1)
cv.out =cv.glmnet(x[train ,],y[train],alpha =0)
plot(cv.out)
bestlam =cv.out$lambda.min
bestlam

ridge.pred=predict(ridge.mod ,s=bestlam ,newx=x[test ,])
mean(( ridge.pred -y.test)^2)

out=glmnet (x,y,alpha =0)
predict (out ,type="coefficients",s=bestlam )[1:20 ,]

# Lasso

lasso.mod =glmnet (x[train ,],y[train],alpha =1, lambda =grid)
plot(lasso.mod)

set.seed (1)
cv.out =cv.glmnet (x[train ,],y[train],alpha =1)
plot(cv.out)
bestlam =cv.out$lambda.min
lasso.pred=predict(lasso.mod ,s=bestlam ,newx=x[test ,])

out=glmnet (x,y,alpha =1, lambda =grid)
lasso.coef=predict (out ,type ="coefficients",s=bestlam )[1:20 ,]
lasso.coef

lasso.coef[lasso.coef !=0]


mean(( lasso.pred -y.test)^2)
