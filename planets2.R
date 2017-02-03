rm(list=ls())

##### Loading libraries##############
library(ggplot2)
library(leaps)
library(RColorBrewer)
library(sp)
library(gstat)
library(caret)
library(mlbench)
library(reshape2)

### Loading data

planets<-read.table("planets.csv",sep=",",header = TRUE)
evils<-read.table("evil-stations.csv", sep=";", header=TRUE)
affinity<-read.table("planet-afinity.csv", sep=",", header=TRUE)

planets <- merge(x = planets, y = affinity, by = "id", all.x = TRUE)
planets_sub <- planets[complete.cases(planets), ]
planets_reg <- planets_sub[,5:ncol(planets_sub)]

p <- ggplot()  +
  geom_point(data=planets_sub, aes(x=x,y=y,colour = affinity)) 
p

p2 <- p + geom_point(data=evils,aes(x,y), colour="red")
p2

### Avoid multicolinear variables

correlationMatrix <- cor(planets_reg)
highlycor <- findCorrelation(correlationMatrix,cutoff =0.75)
planets_reg_decor<-planets_reg[-highlycor]

## Plot variables against affinity (visual check)
df.m <- melt(planets_reg_decor, "affinity")

ggplot(df.m, aes(value, affinity)) + 
  geom_line() + 
  facet_wrap(~variable, scales = "free")

for(i in 1:(ncol(df)-1)) {plot(df$y,df[[paste0('x',i)]],ylab=paste0('x',i),xlab='y')}

### Selecting features
 
lmFit <- train(affinity ~ ., data = planets_reg_decor, method = "lm")
importance <-varImp(lmFit, scale=FALSE)
print(importance)
plot(importance,30)

imp<-as.data.frame(importance$importance)
rownames(imp)[order(imp$Overall, decreasing=TRUE)[1:20]]

### Multivariate model

m1 <-lm(affinity ~ U23 +  U15 + V41 + V64 + U14 + V28 + U30 +U56 + U57 + V57 + V71 + V83 + V70 + U18 + U35 + U37 + V37 + U61, data = planets_reg_decor)

CVlm(data = planets_reg_decor, form.lm= formula(affinity ~ U23 +  U15 + V41 + V64 + U14 + V28 + U30 +U56 + U57 + V57 + V71 + V83 + V70 + U18 + U35 + U37 + V37 + U61), m = 3, seed = 29 )

summary(m1)
plot(density(resid(m1))) 
planets_sub["residuals"] <- as.vector(resid(m1))

## plot residuals
ggplot(data=planets_sub, aes(x=x,y=y,colour = residuals)) + 
  geom_point() + scale_color_gradient2(low="blue", mid="white",high="red")

###Here I try a different approach using stepwise regression to select informative variables and build the model but results are equally dissapointing 

## setting up stepwise regression
# null=lm(affinity~1, data=planets_reg)
# full=lm(affinity~., data=planets_reg)
# 
# step(null, scope = list(upper=full), data=planets_reg, direction="both")
# 
# ## Create a multiv model from stepwise method
# 
# m1<-lm(formula = affinity ~ U30 + U14 + U23 + U15 + U18 + U57 + V86 + 
#          V83 + V71 + U9 + V57 + U56 + U46 + V44 + V78 + V70, data = planets_reg)

### Spatial correlation

coordinates(planets_sub) = ~x+y
v <- variogram(residuals ~ 1, planets_sub, alpha=c(0,45,90,135))

m<-fit.variogram(v, vgm(c("Exp", "Mat", "Sph")))

plot(v, model = m)

### Model prediction: this is what i'd do if the former steps succesful.

# z <- krige(covariates (m1), variogram model including nugget...)
 

### Evils

e<-evils[2:3]
de<-as.matrix(dist(e) )    
neighbors=which(de < 15000, arr.ind=T)
neighbors= neighbors[neighbors[,1]!=neighbors[,2]]

plot(e)
points(e[neighbors,], col="red" )
summary(evils)
sum(evils$col_1)
sum(evils$col_2)

               