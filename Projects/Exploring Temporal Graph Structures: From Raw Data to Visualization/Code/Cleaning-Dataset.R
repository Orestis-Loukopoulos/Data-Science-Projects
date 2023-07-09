setwd("~/Library/Mobile Documents/com~apple~CloudDocs/MASTER/MSc Business Analytics/Semester 3/Social Network Analysis/Assignment 2")

#import libraries
library(igraph)
library(readr)
mydata <- read_csv('file2.csv', col_names = F)
problems()
#We have problem in lines 1190 and 8519. 
#As the number of problematic rows is so small, we will try to fix it manually.

#Changing column names.
colnames(mydata) <- c('Year', 'Title', 'Conference', 'Authors')


#Fixing the problem in line 1190.

#The column year is OK.
mydata$Year[1190] 

#The column Title, Conference and Authors need some cleaning.
mydata$Title[1190]
mydata$Conference[1190]
mydata$Authors[1190]

#Clean line 1190.
mydata$Title[1190] = "Keep it Simple Lazy - MetaLazy: A New MetaStrategy for Lazy Text Classification."
mydata$Conference[1190] = 'CIKM'
mydata$Authors[1190] = "Luiz Felipe Mendes,Marcos André Gonçalves,Washington Cunha,Leonardo C. da Rocha,Thierson Couto Rosa,Wellington Martins"


#Fixing the problem in line 8519.

#The column year is OK.
mydata$Year[8519] 

#The columns Title, Conference and Authors need some cleaning.
mydata$Title[8519]
mydata$Conference[8519]
mydata$Authors[8519]

#Clean line 8519.
mydata$Title[8519] = "I Have a Ph.D.: A Propensity Score Analysis on the Halo Effect of Disclosing One's Offline Social Status in Online Communities."
mydata$Conference[8519] = 'ICWSM'
mydata$Authors[8519] = "Kunwoo Park,Haewoon Kwak,Hyunho Song,Meeyoung Cha"

#Export data
write_csv(mydata, "/Users/orestisloukopoulos/mydata.csv")
#save the csv file internally. 
#The transformation of the csv will be implemented on python using pandas library.



