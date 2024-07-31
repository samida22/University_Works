

#-----upload data file-------------------------------------------#

# set working directory
setwd(dirname(file.choose()))
getwd()

# read in data from csv file
Data.dis <- read.csv("abs.csv", stringsAsFactors = FALSE)
head(Data.dis)
str(Data.dis)
colnames(Data.dis)
summary(Data.dis)


#--------------- check for missing data---------------------#

apply(Data.dis, MARGIN = 2, FUN = function(x) sum(is.na(x)))
library(Amelia)
missmap(Data.dis, col = c("black", "grey"), legend = FALSE)






#------------Dependent variable-------------------------------#
#Create percentage of population of all variables
Data.dis <- within (Data.dis, pDeath_Total <- (Total/ All_Usual_Residents)*1000)

 
#--Dependent variable BoxPlot---#
pDeath_Total <- boxplot(Data.dis$pDeath_Total, xlab="Total_Death", ylab="Count")

#---Normality Check----#

#Normality check for Total Death column
boxplot(log(Data.dis[20]+1))
summary(log(Data.dis[20]+1))
hist(Data.dis$pDeath_Total)

# Plot histogram and normal approximation
library(rcompanion)
plotNormalHistogram(Data.dis$pDeath_Total, main = "Histogram", xlab = "Data.dis$pDeath_Total")



#-----Q-Q plot for dependent variable----#

qqnorm(Data.dis$pDeath_Total, xlab = "PTotal Death")
qqline(Data.dis$pDeath_Total, col=20)  # red color


#---- Significance testing for normality
#---- Kolmogorov-Smirnov Tests of normality

ks.test(Data.dis$pDeath_Total,"pnorm", mean(Data.dis$pDeath_Total), sd(Data.dis$pDeath_Total))



#--------------------------------Independent Variable------------------------------------#

# Create percentage of population of all variables

Data.dis <- within (Data.dis, pAge_Children <- (Children/ All_Usual_Residents)*1000)
Data.dis <- within (Data.dis, pAge_Young_Adult <- (Young/ All_Usual_Residents)*1000)
Data.dis <- within (Data.dis, pAge_Middle_Adult <- (Adults/ All_Usual_Residents)*1000)
Data.dis <- within (Data.dis, pAge_Pensioner <- (Pensioner/ All_Usual_Residents)*1000)
Data.dis <- within (Data.dis, pMales <- (Males/ All_Usual_Residents)*1000)
Data.dis <- within (Data.dis, pFemale <- (Female/ All_Usual_Residents)*1000)
Data.dis <- within (Data.dis, pHealth_Verygoodhealth <- (Health_Verygoodhealth/ All_Usual_Residents)*1000)
Data.dis <- within (Data.dis, pHealth_Goodhealth <- (Health_Goodhealth/ All_Usual_Residents)*1000)
Data.dis <- within (Data.dis, pHealth_Fairhealth <- (Health_Fairhealth/ All_Usual_Residents)*1000)
Data.dis <- within (Data.dis, pHealth_Badhealth <- (Health_Badhealth/ All_Usual_Residents)*1000)
Data.dis <- within (Data.dis, pHealth_Verybadhealth <- (Health_Verybadhealth/ All_Usual_Residents)*1000)



#----Boxplot---#


#- boxplot for variables Age-#

pAge_Children <- Data.dis$pAge_Children
pAge_Young_Adult <- Data.dis$pAge_Young_Adult
pAge_Middle_Adult <- Data.dis$pAge_Middle_Adult
pAge_Pensioner <- Data.dis$pAge_Pensioner

boxplot(pAge_Children,pAge_Young_Adult,pAge_Middle_Adult,pAge_Pensioner,
        names=c("Age_Children", "Age_Young_Adult", "Age_Middle_Adult", "Age_Pensioner"),
        xlab="Age", ylab="Count", col = "Bisque")

#---Q-Q plot for variable Age----#

qqnorm(pAge_Children, xlab = "pAge_Children")
qqline(pAge_Children, col=21)  # red color

qqnorm(pAge_Young_Adult, xlab = "pAge_Young_Adult")
qqline(pAge_Young_Adult, col=22)  # red color

qqnorm(pAge_Middle_Adult, xlab = "pAge_Middle_Adult")
qqline(pAge_Middle_Adult, col=23)  # red color

qqnorm(pAge_Pensioner, xlab = "pAge_Pensioner")
qqline(pAge_Pensioner, col=24)  # red color


#---- boxplot for variables Gender----#

pMales <- Data.dis$pMales
pFemale <- Data.dis$pFemale

boxplot(pMales,pFemale,
        names=c("Males", "Female"),
        xlab="Gender", ylab="Count", col = "Bisque")

#-----Q-Q plot for variable Gender----#

qqnorm(pMales, xlab = "pMales")
qqline(pMales, col=25)  # red color

qqnorm(pFemale, xlab = "pFemale")
qqline(pFemale, col=26)  # red color



#---- boxplot for variables Health-----#

pHealth_Verygoodhealth <- Data.dis$pHealth_Verygoodhealth
pHealth_Goodhealth <- Data.dis$pHealth_Goodhealth
pHealth_Fairhealth <- Data.dis$pHealth_Fairhealth
pHealth_Badhealth <- Data.dis$pHealth_Badhealth
pHealth_Verybadhealth <- Data.dis$pHealth_Verybadhealth


boxplot(pHealth_Verygoodhealth,pHealth_Goodhealth,pHealth_Fairhealth,pHealth_Badhealth,pHealth_Verybadhealth,
        names=c("pHealth_Verygoodhealth", "pHealth_Goodhealth", "pHealth_Fairhealth", "pHealth_Badhealth", "pHealth_Verybadhealth"),
        xlab="Health", ylab="Count", col = "Bisque")

#-----Q-Q plot for variable Health----#

qqnorm(pHealth_Verygoodhealth, xlab = "pHealth_Verygoodhealth")
qqline(pHealth_Verygoodhealth, col=25)  # red color

qqnorm(pHealth_Goodhealth, xlab = "pHealth_Goodhealth")
qqline(pHealth_Goodhealth, col=26)  # red color

qqnorm(pHealth_Fairhealth, xlab = "pHealth_Fairhealth")
qqline(pHealth_Fairhealth, col=26)  # red color

qqnorm(pHealth_Badhealth, xlab = "pHealth_Badhealth")
qqline(pHealth_Badhealth, col=26)  # red color


qqnorm(pHealth_Verybadhealth, xlab = "pHealth_Verybadhealth")
qqline(pHealth_Verybadhealth, col=26)  # red color




#-----------------------Pearson method--------------------------------------------#

#cor.test(x, y,
#	alternative = c("two.sided", "less", "greater"),
#	method = c("pearson", "kendall", "spearman"),
#	exact = NULL, conf.level = 0.95, continuity = FALSE, ...)

# test correlation of dependent variable with all independent variables

cor.test(Data.dis$pDeath_Total, Data.dis$pAge_Children, method = "pearson")


 ###########################################################Scatter plot
plot(Data.dis$pAge_Children, Data.dis$pDeath_Total, main = "Scatterplot",
     xlab = "Data.dis$pAge_Children", ylab = "pDeath_Tota")
abline(lm(Data.dis$pDeath_Total ~ Data.dis$pAge_Children, data = Data.dis), col = "blue")
###########################################################################################


cor.test(Data.dis$pDeath_Total, Data.dis$pAge_Young_Adult, method = "pearson")
cor.test(Data.dis$pDeath_Total, Data.dis$pAge_Middle_Adult, method = "pearson")
cor.test(Data.dis$pDeath_Total, Data.dis$pAge_Pensioner, method = "pearson")


cor.test(Data.dis2$pDeath_Total, Data.dis$pMales, method = "pearson")
cor.test(Data.dis$pDeath_Total,Data.dis$pFemale, method = "pearson")


cor.test(Data.dis$pDeath_Total, Data.dis$pHealth_Verybadhealth, method = "pearson")
cor.test(Data.dis$pDeath_Total, Data.dis$pHealth_Badhealth, method = "pearson")
cor.test(Data.dis$pDeath_Total, Data.dis$pHealth_Fairhealth, method = "pearson")
cor.test(Data.dis$pDeath_Total, Data.dis$pHealth_Goodhealth, method = "pearson")
cor.test(Data.dis$pDeath_Total, Data.dis$pHealth_Verygoodhealth, method = "pearson")



############################################### basic multivariate scatterplot matrix
pairs(~ Data.dis$pDeath_Total + Data.dis$pHealth_Verybadhealth + Data.dis$pHealth_Badhealth + Data.dis$pHealth_Fairhealth
      + Data.dis$pHealth_Goodhealth + Data.dis$pHealth_Verygoodhealth,  data = Data.dis,
      main = "multivariate scatterplot matrix")

# select subset of data
Data2 <- data.frame(Data.dis$pDeath_Total,Data.dis$pHealth_Verybadhealth,Data.dis$pHealth_Badhealth,Data.dis$pHealth_Fairhealth
                    ,Data.dis$pHealth_Goodhealth,Data.dis$pHealth_Verygoodhealth)
# add column names
colnames(Data2) <- c("Data.dis$pDeath_Total", "Data.dis$pHealth_Verybadhealth", "Data.dis$pHealth_Badhealth", "Data.dis$pHealth_Fairhealth", 
                       "Data.dis$pHealth_Goodhealth", "Data.dis$pHealth_Verygoodhealth")

# basic correlation pearson
cor(Data2, method = "pearson")
Data2_cor <- cor(Data2, method = "pearson")
round(Data2_cor, digits = 2)
###############################################################################

#------------------------------------- correlation matrix---------------------------------#

# select a dependent variable and independent variables
Data.dis2 <- data.frame(Data.dis$pDeath_Total, Data.dis$pAge_Children, Data.dis$pAge_Young_Adult, Data.dis$pAge_Middle_Adult, 
                        Data.dis$pAge_Pensioner, Data.dis$pMales, Data.dis$pFemale,Data.dis$pHealth_Badhealth, Data.dis$pHealth_Fairhealth,
                        Data.dis$pHealth_Goodhealth, Data.dis$pHealth_Verybadhealth, Data.dis$pHealth_Verygoodhealth)

colnames(Data.dis2) <- c("pDeath_Total","pAge_Children", "pAge_Young_Adult", "pAge_Middle_Adult", "pAge_Pensioner", "pMales", "pFemale", "pHealth_Badhealth",
                         "pHealth_Fairhealth","pHealth_Goodhealth","pHealth_Verybadhealth", "pHealth_Verygoodhealth")


#----Correlations among numeric variables in----#
cor.matrix <- cor(Data.dis2, use = "pairwise.complete.obs", method = "pearson")
round(cor.matrix, digits = 2)
cor.df <- as.data.frame(cor.matrix)
View(cor.df)

library(psych)

pairs.panels(Data.dis2, method = "pearson", hist.col = "grey", col = "blue", main = "pearson")

library(corrgram)
# corrgram works best with Pearson correlation
corrgram(Data.dis2, order=FALSE, cor.method = "pearson", lower.panel=panel.conf,
         upper.panel=panel.pie, text.panel=panel.txt, main="Pearson Correlation")


#########################################################
#----Correlations among numeric variables in----#
cor.matrix <- cor(Data.dis2, use = "pairwise.complete.obs", method = "spearman")
round(cor.matrix, digits = 2)
cor.df <- as.data.frame(cor.matrix)
View(cor.df)

library(psych)

pairs.panels(Data.dis2, method = "spearman", hist.col = "grey", col = "blue", main = "spearman")

library(corrgram)
# corrgram works best with spearman correlation
corrgram(Data.dis2, order=FALSE, cor.method = "pearson", lower.panel=panel.conf,
         upper.panel=panel.pie, text.panel=panel.txt, main="spearman Correlation")

############################################################################



#--------- select variables by excluding those not required; the %in% operator means 'matching'--------#
myvars <- names(Data.dis2) %in% c("pHealth_Goodhealth " , "pAge_Children", "pAge_Young_Adult", "pAge_Middle_Adult" , "pHealth_Verygoodhealth" 
                                 , "pMales" , "pFemale", "pAge_Pensioner" , "pHealth_Goodhealth" )

# the ! operator means NOT
Data.dis3 <- Data.dis2[!myvars]
str(Data.dis3)
rm(myvars)


#-----------------------------------------eigenvalues------------------------#

# Kaiser-Meyer-Olkin statistics: if overall MSA > 0.6, proceed to factor analysis
library(psych)
KMO(cor(Data.dis3))

# Determine Number of Factors to Extract
library(nFactors)

# get eigenvalues: eigen() uses a correlation matrix
ev <- eigen(cor(Data.dis2))
ev$values
# plot a scree plot of eigenvalues
plot(ev$values, type="b", col="blue", xlab="variables")

# calculate cumulative proportion of eigenvalue and plot
ev.sum<-0
for(i in 1:length(ev$value)){
  ev.sum<-ev.sum+ev$value[i]
}
ev.list1<-1:length(ev$value)
for(i in 1:length(ev$value)){
  ev.list1[i]=ev$value[i]/ev.sum
}
ev.list2<-1:length(ev$value)
ev.list2[1]<-ev.list1[1]
for(i in 2:length(ev$value)){
  ev.list2[i]=ev.list2[i-1]+ev.list1[i]
}
plot (ev.list2, type="b", col="red", xlab="number of components", ylab ="cumulative proportion")



#----------------------------Regression Model-----------------------------------~
# Multiple Regression

# model with all variables
model2 <- lm(Data.dis2$pDeath_Total ~ Data.dis2$pAge_Children +
               Data.dis2$pAge_Middle_Adult + Data.dis2$pAge_Pensioner + Data.dis2$pMales + Data.dis2$pFemale
             + Data.dis2$pHealth_Verybadhealth + Data.dis2$pHealth_Badhealth + Data.dis2$pHealth_Fairhealth 
             + Data.dis2$pHealth_Goodhealth  + Data.dis2$pHealth_Verygoodhealth)
summary(model2)

# Plot histogram and normal approximation
library(rcompanion)
hist(model2$residuals)
plotNormalHistogram(model2$residuals, main = "Histogram", xlab = "model2$residuals")
rug(model2$residuals)

# consider normality of residuals
plot(model2$residuals ~ model2$fitted.values, xlab = "fitted values", ylab = "residuals")
ks.test(model2$residuals, "pnorm", mean(model2$residuals), sd(model2$residuals))



