library("redux")
r$FLUSHALL()
# Create a connection to the local instance of REDIS
r <- redux::hiredis(redux::redis_config(host = "127.0.0.1", port = "6379"))

setwd("~/Library/Mobile Documents/com~apple~CloudDocs/MASTER/MSc Business Analytics/Semester 2/Big Data Systems and Architectures/Redis-Mongo Assignment-v1.3/RECORDED_ACTIONS")
mdf <- read.csv('modified_listings.csv') #Create data frame for modified_listings.csv
em <- read.csv('emails_sent.csv')


##########
#Task 1.1#
##########
mdf1 <- subset(mdf,mdf$MonthID==1) #Create new data frame with only January as month

for (i in 1:length(mdf1$UserID)){
  if(mdf1$ModifiedListing[i]==1){
    r$SETBIT("ModificationsJanuary",mdf1$UserID[i],"1")
  }
}#Created a bitmap Modification January

r$BITCOUNT("ModificationsJanuary") #Count the number of users modified their listing in January (9969)

##########
#Task 1.2#
##########
r$BITOP('NOT','Not in January','ModificationsJanuary')
r$BITCOUNT('Not in January')# The number of users did not modified their listing in January (10031)

r$BITCOUNT('Not in January') + r$BITCOUNT("ModificationsJanuary") #(20000)
length(unique(mdf$UserID)) #(19999)
#BITOP operations are implemented at byte level integers. We know that each byte has 8 bits. Hence, the result of every BITOP operation is an integer multiple of 8. 

##########
#Task 1.3#
##########

for (i in 1:length(em$UserID)){
  if(em$MonthID[i]==1){
    r$SETBIT("EmailsJanuary",em$UserID[i],"1")
  }
  if(em$MonthID[i]==2){
    r$SETBIT("EmailsFebruary",em$UserID[i],"1")
  }
  if(em$MonthID[i]==3){
    r$SETBIT("EmailsMarch",em$UserID[i],"1")
  }
}

r$BITOP('AND','At least one email per month',c("EmailsJanuary","EmailsFebruary","EmailsMarch"))
r$BITCOUNT('At least one email per month') #The number of users received an email on January, February and March  is 2668


##########
#Task 1.4#
##########

r$BITOP('AND','Jan and Mar email',c("EmailsJanuary","EmailsMarch"))
r$BITOP('NOT','No email Feb',"EmailsFebruary")
r$BITOP('AND','Jan, Mar <- YES and Feb <- No',c('Jan and Mar email','No email Feb'))
r$BITCOUNT('Jan, Mar <- YES and Feb <- No') #The number of users received an email in January and March but not in February is 2417

##########
#Task 1.5#
##########
opened_emails_jan <- em[which(em$MonthID==1 & em$EmailOpened==1),] #Took the rows which have emails send in January and those emails were opened in a new data-frame opened_emails_jan
opened_emails_jan_users <- unique(opened_emails_jan$UserID) #Took only the unique users which had received an email in January and had opened it.

for( i in opened_emails_jan_users){
  r$SETBIT("EmailsOpenedJanuary",i,"1")
}

r$BITCOUNT("EmailsOpenedJanuary")
r$BITOP('NOT',"EmailsExceptOpenedJan","EmailsOpenedJanuary")
r$BITCOUNT("EmailsExceptOpenedJan")

r$BITOP('AND',"EmailsNotOpenedJanuary",c("EmailsExceptOpenedJan",'EmailsJanuary'))
r$BITCOUNT("EmailsNotOpenedJanuary")

r$BITOP('AND','EmailsNotOpenedbutModifiedJanuary',c("EmailsNotOpenedJanuary",'ModificationsJanuary'))
r$BITCOUNT('EmailsNotOpenedbutModifiedJanuary') #The number of users received an email in January not opened it but modified it is 1961.




##########
#Task 1.6#
##########

mdf2 <- subset(mdf,mdf$MonthID==2) #Create new data frame with only February as month

for (i in 1:length(mdf1$UserID)){
  if(mdf2$ModifiedListing[i]==1){
    r$SETBIT("ModificationsFebruary",as.character(mdf2$UserID[i]),"1")
  }
}#Created a bitmap Modification February

opened_emails_feb <- em[which(em$MonthID==2 & em$EmailOpened==1),] #Took the rows which have emails send in February and those emails were opened a new df opened_emails_feb
opened_emails_feb_users <- unique(opened_emails_feb$UserID) #Took only the unique users which had received an email in February and had opened it

for( i in opened_emails_feb_users){
  r$SETBIT("EmailsOpenedFebruary",i,"1")
}

r$BITCOUNT("EmailsOpenedFebruary")
r$BITOP('NOT',"EmailsExceptOpenedFeb","EmailsOpenedFebruary")
r$BITCOUNT("EmailsExceptOpenedFeb")

r$BITOP('AND',"EmailsNotOpenedFebruary",c("EmailsExceptOpenedFeb",'EmailsFebruary'))
r$BITCOUNT("EmailsNotOpenedFebruary")

r$BITOP('AND','EmailsNotOpenedbutModifiedFebruary',c("EmailsNotOpenedFebruary",'ModificationsFebruary'))
r$BITCOUNT('EmailsNotOpenedbutModifiedFebruary')

mdf3 <- subset(mdf,mdf$MonthID==3) #Create new data frame with only March as month

for (i in 1:length(mdf1$UserID)){
  if(mdf3$ModifiedListing[i]==1){
    r$SETBIT("ModificationsMarch",as.character(mdf3$UserID[i]),"1")
  }
}#Created a bitmap Modification March

opened_emails_mar <- em[which(em$MonthID==3 & em$EmailOpened==1),] #Took the rows which have emails send in March and those emails were opened a new df opened_emails_mar
opened_emails_mar_users <- unique(opened_emails_mar$UserID) #Took only the unique users which had received an email in March and had opened it

for( i in opened_emails_mar_users){
  r$SETBIT("EmailsOpenedMarch",i,"1")
}

r$BITCOUNT("EmailsOpenedMarch")
r$BITOP('NOT',"EmailsExceptOpenedMar","EmailsOpenedMarch")
r$BITCOUNT("EmailsExceptOpenedMar")

r$BITOP('AND',"EmailsNotOpenedMarch",c("EmailsExceptOpenedMar",'EmailsMarch'))
r$BITCOUNT("EmailsNotOpenedMarch")

r$BITOP('AND','EmailsNotOpenedbutModifiedMarch',c("EmailsNotOpenedMarch",'ModificationsMarch'))
r$BITCOUNT('EmailsNotOpenedbutModifiedMarch')

r$BITOP('OR','results 1.6',c('EmailsNotOpenedbutModifiedJanuary','EmailsNotOpenedbutModifiedFebruary','EmailsNotOpenedbutModifiedMarch'))
r$BITCOUNT('results 1.6')#The number of users received an email in January or in February or in March and not opened it but modified it is 5249.

##########
#Task 1.7#
##########

#January

r$BITOP('AND','Users opened and Modified in January', c('EmailsOpenedJanuary','ModificationsJanuary'))
r$BITCOUNT('Users opened and Modified in January') #2797
r$BITCOUNT('Users opened and Modified in January')/r$BITCOUNT('ModificationsJanuary') #28% of the total modifications in January have performed from sellers that opened the recommendation email 
r$BITCOUNT('Users opened and Modified in January')/r$BITCOUNT('EmailsOpenedJanuary') #49% of the emails opened have led to a modification



#February
r$BITOP('AND','Users opened and Modified in February',c("EmailsOpenedFebruary",'ModificationsFebruary'))
r$BITCOUNT('Users opened and Modified in February') #2874
r$BITCOUNT('Users opened and Modified in February')/r$BITCOUNT('ModificationsFebruary') #29% of the total modifications in February have performed from sellers that opened the recommendation email 
r$BITCOUNT('Users opened and Modified in February')/r$BITCOUNT('EmailsOpenedFebruary') #50% of the emails opened have led to a modification

#March
r$BITOP('AND','Users opened and Modified in March',c("EmailsOpenedMarch",'ModificationsMarch'))
r$BITCOUNT('Users opened and Modified in March') #2874
r$BITCOUNT('Users opened and Modified in March')/r$BITCOUNT('ModificationsMarch') #28% of the total modifications in March have performed from sellers that opened the recommendation email 
r$BITCOUNT('Users opened and Modified in March')/r$BITCOUNT('EmailsOpenedMarch') #50% of the emails opened have led to a modification


#From the above we can understand that sending emails with recommendations to sellers has not a clear effect, as on average only 28% of total modifications have performed by sellers who had opened the recommendation email.



