install.packages("plm")
library("plm")
new_file2 <-read.csv("C:\\Users\\Lakshi\\Desktop\\gkt.csv")
head(new_file2)
model1 <- plm(invest ~ Q +blockchain*Q +blockchain ,data = new_file2, 
                          index =c("conm","fyear"),
                          model = "within",effect = "twoways")
summary(model1)

#First Difference model
model2 <- plm(invest ~ Q +blockchain*Q +blockchain ,data = new_file2, 
              index =c("conm","fyear"),
              model = "fd",effect = "individual")
summary(model2)
#In absence of bias due to endogeneity, our point estimates would be same for both models.
