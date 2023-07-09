setwd("~/Library/Mobile Documents/com~apple~CloudDocs/MASTER/MSc Business Analytics/Semester 3/Practicum 2/Assignment 1")
library(ggplot2)
library(ggalt)
library(scales)
library(hrbrthemes)
library(packcircles)
library(viridis)
library(ggpubr)
library(treemap)


#2004
flights_2004 <- read.csv("2004.csv.bz2", na.strings=c("","NA"),stringsAsFactors=T)
str(flights_2004)

#Cleaning 2004
flights_2004$Month <- as.factor(flights_2004$Month)
levels(flights_2004$Month) <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')

flights_2004$DayofMonth <- as.factor(flights_2004$DayofMonth)

flights_2004$DayOfWeek <- as.factor(flights_2004$DayOfWeek)
levels(flights_2004$DayOfWeek) <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')

flights_2004$FlightNum <- as.factor(flights_2004$FlightNum)

flights_2004$Cancelled <- as.factor(flights_2004$Cancelled)
levels(flights_2004$Cancelled) <- c('Not Canceled', 'Canceled')

flights_2004$Diverted <- as.factor(flights_2004$Diverted)
levels(flights_2004$Diverted) <- c('Not Diverted', 'Diverted')


levels(flights_2004$CancellationCode) <- c('Carrier', 'Weather', 'NAS', 'Security')

#We will change the format in variables DepTime, CRSDepTime, ArrTime and CRSArrTime
library(magrittr)
library(dplyr)

flights_2004 <- flights_2004 %>% 
  mutate(DepTime = sprintf("%04d", DepTime))
flights_2004$DepTime <- as.POSIXct(flights_2004$DepTime, format="%H%M")
flights_2004$DepTime <- substr(flights_2004$DepTime, 12, 16)
flights_2004$DepTime <- as.factor(flights_2004$DepTime)

flights_2004 <- flights_2004 %>% 
  mutate(CRSDepTime = sprintf("%04d", CRSDepTime))
flights_2004$CRSDepTime <- as.POSIXct(flights_2004$CRSDepTime, format="%H%M")
flights_2004$CRSDepTime <- substr(flights_2004$CRSDepTime, 12, 16)
flights_2004$CRSDepTime <- as.factor(flights_2004$CRSDepTime)

flights_2004 <- flights_2004 %>% 
  mutate(ArrTime = sprintf("%04d", ArrTime))
flights_2004$ArrTime <- as.POSIXct(flights_2004$ArrTime, format="%H%M")
flights_2004$ArrTime <- substr(flights_2004$ArrTime, 12, 16)
flights_2004$ArrTime <- as.factor(flights_2004$ArrTime)

flights_2004 <- flights_2004 %>% 
  mutate(CRSArrTime = sprintf("%04d", CRSArrTime))
flights_2004$CRSArrTime <- as.POSIXct(flights_2004$CRSArrTime, format="%H%M")
flights_2004$CRSArrTime <- substr(flights_2004$CRSArrTime, 12, 16)
flights_2004$CRSArrTime <- as.factor(flights_2004$CRSArrTime)

#Replace negative AirTime values with NAs
flights_2004$AirTime <- replace(flights_2004$AirTime, which(flights_2004$AirTime < 0), NA)

nrow(flights_2004)
str(flights_2004)
View(flights_2004)

#2005
flights_2005 <- read.csv("2005.csv.bz2", na.strings=c("","NA"), stringsAsFactors=T)
str(flights_2005)

#Cleaning 2005
flights_2005$Month <- as.factor(flights_2005$Month)
levels(flights_2005$Month) <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')

flights_2005$DayofMonth <- as.factor(flights_2005$DayofMonth)

flights_2005$DayOfWeek <- as.factor(flights_2005$DayOfWeek)
levels(flights_2005$DayOfWeek) <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')

flights_2005$FlightNum <- as.factor(flights_2005$FlightNum)

flights_2005$Cancelled <- as.factor(flights_2005$Cancelled)
levels(flights_2005$Cancelled) <- c('Not Canceled', 'Canceled')

flights_2005$Diverted <- as.factor(flights_2005$Diverted)
levels(flights_2005$Diverted) <- c('Not Diverted', 'Diverted')


levels(flights_2005$CancellationCode) <- c('Carrier', 'Weather', 'NAS', 'Security')


#We will change the format in variables DepTime, CRSDepTime, ArrTime and CRSArrTime

flights_2005 <- flights_2005 %>% 
  mutate(DepTime = sprintf("%04d", DepTime))
flights_2005$DepTime <- as.POSIXct(flights_2005$DepTime, format="%H%M")
flights_2005$DepTime <- substr(flights_2005$DepTime, 12, 16)
flights_2005$DepTime <- as.factor(flights_2005$DepTime)

flights_2005 <- flights_2005 %>% 
  mutate(CRSDepTime = sprintf("%04d", CRSDepTime))
flights_2005$CRSDepTime <- as.POSIXct(flights_2005$CRSDepTime, format="%H%M")
flights_2005$CRSDepTime <- substr(flights_2005$CRSDepTime, 12, 16)
flights_2005$CRSDepTime <- as.factor(flights_2005$CRSDepTime)

flights_2005 <- flights_2005 %>% 
  mutate(ArrTime = sprintf("%04d", ArrTime))
flights_2005$ArrTime <- as.POSIXct(flights_2005$ArrTime, format="%H%M")
flights_2005$ArrTime <- substr(flights_2005$ArrTime, 12, 16)
flights_2005$ArrTime <- as.factor(flights_2005$ArrTime)

flights_2005 <- flights_2005 %>% 
  mutate(CRSArrTime = sprintf("%04d", CRSArrTime))
flights_2005$CRSArrTime <- as.POSIXct(flights_2005$CRSArrTime, format="%H%M")
flights_2005$CRSArrTime <- substr(flights_2005$CRSArrTime, 12, 16)
flights_2005$CRSArrTime <- as.factor(flights_2005$CRSArrTime)

#Replace negative AirTime values with NAs
flights_2005$AirTime <- replace(flights_2005$AirTime, which(flights_2005$AirTime < 0), NA)

str(flights_2005)
View(flights_2005)


#Merge the two dataframes 2004 - 2005

flights <- rbind(flights_2004, flights_2005)
str(flights)

flights$Year <- as.factor(flights$Year)

#Create a column of Seasons based on Month column
flights$Season <- ifelse (flights$Month %in% c('Jun','Jul', 'Aug'), 
                          "Summer",
                          ifelse (flights$Month %in% c('Sep','Oct', 'Nov'), 
                                  "Fall",
                                  ifelse (flights$Month %in% c('Dec','Jan', 'Feb'), 
                                          "Winter",
                                          ifelse (flights$Month %in% c('Mar','Apr', 'May'), 
                                                  "Spring", NA))))
flights$Season <- as.factor(flights$Season)

str(flights)
View(flights)


#Visualizations

#############
#1st Figure##
#############

#Mean Departure Delay per Year

#In order to calculate the mean Departure Delay per Year 
#we will convert the minutes to seconds by multiplying each value of DepDelay column with 60
#then we calculate the total number of seconds for each year
#then we divide with the total number of observations for each year
num1 <- sum(flights$DepDelay[which(flights$Year=='2004')]*60, na.rm = T)/length(flights$DepDelay[which(flights$Year=='2004')])
num1 <- num1/60 #we divide the number we calculated by 60 (seconds)
decnum1 <- num1 - floor(num1) #we take the decimal part of the num1 in order to find the seconds as the decimal places represent a fraction of a minute
d1 <- floor(num1) + decnum1*60/100 #d1 is the average time of Departure Delays in 2004

#We do the same for 2005
num2 <- (sum(flights$DepDelay[which(flights$Year=='2005')]*60, na.rm = T)/length(flights$DepDelay[which(flights$Year=='2005')]))/60
decnum2 <- num2 - floor(num2)
d2 <- floor(num2) + decnum2*60/100

meanDepDelay <- c(d1, d2) 

barplot(meanDepDelay, xlab = 'Years', ylab = 'Minutes', ylim=c(0,10), names.arg=levels(flights$Year), col = c('#F7AC3B', '#4E909E'), main="Mean Departure Delay per Year")
#We can observe that in 2005 the departure delays last 45secs more on average compared to 2004.

#############
#2nd Figure##
#############

#Mean Arrival Delay per Year

#In order to calculate the mean Arrival Delay per Year we will follow the same method as in DepDelay 
anum1 <- sum(flights$ArrDelay[which(flights$Year=='2004')]*60, na.rm = T)/length(flights$ArrDelay[which(flights$Year=='2004')])
anum1 <- anum1/60 
adecnum1 <- anum1 - floor(anum1) 
ad1 <- floor(anum1) + adecnum1*60/100

#We do the same for 2005
anum2 <- (sum(flights$ArrDelay[which(flights$Year=='2005')]*60, na.rm = T)/length(flights$ArrDelay[which(flights$Year=='2005')]))/60
adecnum2 <- anum2 - floor(anum2)
ad2 <- floor(anum2) + adecnum2*60/100

meanArrDelay <- c(ad1, ad2) 

barplot(meanArrDelay, xlab = 'Years', ylab = 'Minutes', ylim=c(0,10),names.arg=levels(flights$Year), col = c('#F7AC3B', '#4E909E'), main="Mean Arrival Delay per Year")
#We can observe that in 2005 the arrival delays last approximately 40secs more on average compared to 2004.


#############
#3rd Figure##
#############

#Seasons

positions <- c( 'Fall', "Winter", "Spring", "Summer")

ggplot(data = flights, aes(x = Season, fill = Year)) +
  geom_bar(position = "dodge")+
  theme_minimal()+ 
  labs(y = "Nr. of Flights", x="Season")+ 
  theme(legend.title = element_text(face = "bold"))+ 
  scale_fill_manual(values = colour_palette)+
  ggtitle("Nr. of Flights per Season for 2004 & 2005")+
  theme(plot.title = element_text(hjust = 0.5))+ 
  theme(plot.title = element_text(face = "bold"))+
  theme(axis.line = element_line(colour = "black", size=0.2),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())+ 
  scale_x_discrete(limits = positions)+ 
  scale_y_continuous(labels = comma)

#We can see that there were more flights during Fall and Winter for 2004, while there were more in Spring and Summer for 2005.


#############
#4th Figure##
#############

#Number of canceled flights per Year

c1 <- nrow(flights[which(flights$Year=='2004' & flights$Cancelled=='Canceled'),])/nrow(flights_2004)
c2 <- nrow(flights[which(flights$Year=='2005' & flights$Cancelled=='Canceled'),])/nrow(flights_2005)
percCanc <- c(c1, c2)
percCanc <- round(percCanc, 3) 
percCanc <- as.data.frame(percCanc)
years <- c('2004', '2005')
percCanc <- cbind(percCanc, years)

par(mfrow=c(1,1))


ggplot(percCanc, aes(x=percCanc, y=years)) +
  geom_bar(stat="identity", fill= c('#F7AC3B', '#4E909E')) +
  theme_minimal() + 
  scale_x_continuous(labels = scales::percent, breaks = scales::pretty_breaks(n = 8)) + 
  ggtitle("% of Canceled Flights per Year")+ 
  labs(y = "Years", x="")+
  theme(plot.title = element_text(hjust = 0.5))+ 
  theme(plot.title = element_text(face = "bold"))+
  theme(axis.line = element_line(colour = "black", size=0.2),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())+
  geom_label(aes(label = paste(percCanc*100, "%") , hjust = 1.2), color = "black", label.padding = unit(0.65, "lines"),  label.r = unit(0.95, "lines"), fontface = "bold")


#We observe a slight increase (0.1%) in flight cancellations in 2005 compared to 2004


#############
#5th Figure##
#############

#cancellation reasons per year

#We will take only the canceled flights 
flights_canc <- flights[which(flights$Cancelled=='Canceled'),]

colour_palette <-  c('#F7AC3B', '#4E909E')
colour_palette <- c(colour_palette, rev(colour_palette))

ggplot(data = flights_canc, aes(x = CancellationCode, fill = Year)) +
  geom_bar(position = "dodge")+
  theme_minimal()+ 
  labs(y = "Nr. of Canceled Flights", x="Reason")+ 
  theme(legend.title = element_text(face = "bold"))+ 
  scale_fill_manual(values = colour_palette)+
  ggtitle("Reasons of Flight Cancellations 2004 & 2005")+
  theme(plot.title = element_text(hjust = 0.5))+ 
  theme(plot.title = element_text(face = "bold"))+
  theme(axis.line = element_line(colour = "black", size=0.2),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())+ 
  scale_y_continuous(labels = comma)


#We can observe that there is an increase in the number of canceled flights because of the weather in 2005
#Bad weather conditions may be the reason behind the increase in flight cancellations we observed in the previous figure


####################################

#############
#6th Figure##
#############

#TOP 15 popular Destinations

fame <- count(flights, Dest)
fame <- fame[order(fame$n, decreasing = T),]
fame <- fame[1:15,]


ggplot(fame, aes(x=reorder(Dest, n), y=n)) + 
  geom_lollipop(point.colour="#4e909e", point.size=3, horizontal=F) +
  scale_y_continuous(limits = c(0, 846789)) +
  geom_point( color="#4e909e", size=4, alpha=0.6) +
  theme_light() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.border = element_blank(),
    axis.ticks.y = element_blank()
  )+ 
  scale_y_continuous(labels = comma)+
  ggtitle("TOP 15 Destinations")+
  theme(plot.title = element_text(hjust = 0.5))+ 
  theme(plot.title = element_text(face = "bold"))+ 
  labs(x = "Destinations", y="Nr. of Flights")+
  coord_flip()




#############
#7th Figure##
#############

#TOP airlines based on number of planes
f9 <- flights[,c("UniqueCarrier", "TailNum")] 
f9

cnt <- aggregate(TailNum ~ UniqueCarrier, f9, function(x) length(unique(x)))
colnames(cnt) <- c('carrier', 'fleet_size')
cnt

# Generate the layout. This function returns a dataframe with one line per bubble. 
# It gives its center and its radius, proportional of the value
packing <- circleProgressiveLayout(cnt$fleet_size, sizetype='area')

# We add  packing information to the initial data frame (cnt)
cnt <- cbind(cnt, packing)


# We will go from one center + a radius to the coordinates of a circle that
# is drawn by a multitude of straight lines.
dat.gg <- circleLayoutVertices(packing, npoints=50)
dat.gg$fleet_size <- rep(cnt$fleet_size, each=51)


ggplot() + 
  geom_polygon(data = dat.gg, aes(x, y, group = id, fill=fleet_size), colour = "white", alpha = 0.6) +
  geom_text(data = cnt, aes(x, y, size=fleet_size, label = paste(carrier, fleet_size, sep = ' with '))) +
  scale_size_continuous(range = c(1,4)) +
  theme_void() + 
  theme(legend.position="none") +
  coord_equal()+
  ggtitle("Size of Airline based on the Number of Aircrafts owned")+
  theme(plot.title = element_text(hjust = 0.5))+ 
  theme(plot.title = element_text(face = "bold"))+
  scale_fill_distiller(palette = "PuBuGn", direction = 1)



#############
#8th Figure##
#############

#Treemap of airlines with the most cancelled flights

flights_canc <- flights[which(flights$Cancelled=='Canceled'),]

fame3 <- count(flights_canc, UniqueCarrier)
fame3 <- fame3[order(fame3$n, decreasing = T),]


treemap(fame3, 
        index="UniqueCarrier",
        vSize="n",
        vColor = "n",
        type="value",
        palette = "YlOrBr",
        border.col ="white",
        title="Nr. of Flights Cancelled by Airline",
        title.legend="Nr. of cancelled flights in 2004 & 2005",
)

#Passengers should probably avoid travelling with Envoy Air (MQ) or Delta (DL) as those airlines lead in flights cancellations

#############
#9th Figure##
#############

#Average Distance Traveled per Day for every Season

#Fall
flights_fall <- subset(flights, flights$Season=='Fall')
MonF <- mean(flights_fall$Distance[which(flights_fall$DayOfWeek=='Monday')],  na.rm = T)
TueF <- mean(flights_fall$Distance[which(flights_fall$DayOfWeek=='Tuesday')],  na.rm = T)
WedF <- mean(flights_fall$Distance[which(flights_fall$DayOfWeek=='Wednesday')],  na.rm = T)
ThuF <- mean(flights_fall$Distance[which(flights_fall$DayOfWeek=='Thursday')],  na.rm = T)
FriF <- mean(flights_fall$Distance[which(flights_fall$DayOfWeek=='Friday')],  na.rm = T)
SatF <- mean(flights_fall$Distance[which(flights_fall$DayOfWeek=='Saturday')],  na.rm = T)
SunF <- mean(flights_fall$Distance[which(flights_fall$DayOfWeek=='Sunday')], na.rm = T)


#Winter
flights_winter <- subset(flights, flights$Season=='Winter')
MonW <- mean(flights_winter$Distance[which(flights_winter$DayOfWeek=='Monday')],  na.rm = T)
TueW <- mean(flights_winter$Distance[which(flights_winter$DayOfWeek=='Tuesday')],  na.rm = T)
WedW <- mean(flights_winter$Distance[which(flights_winter$DayOfWeek=='Wednesday')],  na.rm = T)
ThuW <- mean(flights_winter$Distance[which(flights_winter$DayOfWeek=='Thursday')],  na.rm = T)
FriW <- mean(flights_winter$Distance[which(flights_winter$DayOfWeek=='Friday')],  na.rm = T)
SatW <- mean(flights_winter$Distance[which(flights_winter$DayOfWeek=='Saturday')],  na.rm = T)
SunW <- mean(flights_winter$Distance[which(flights_winter$DayOfWeek=='Sunday')], na.rm = T)

#Spring
flights_spring <- subset(flights, flights$Season=='Spring')
MonSp <- mean(flights_spring$Distance[which(flights_spring$DayOfWeek=='Monday')],  na.rm = T)
TueSp <- mean(flights_spring$Distance[which(flights_spring$DayOfWeek=='Tuesday')],  na.rm = T)
WedSp <- mean(flights_spring$Distance[which(flights_spring$DayOfWeek=='Wednesday')],  na.rm = T)
ThuSp <- mean(flights_spring$Distance[which(flights_spring$DayOfWeek=='Thursday')],  na.rm = T)
FriSp <- mean(flights_spring$Distance[which(flights_spring$DayOfWeek=='Friday')],  na.rm = T)
SatSp <- mean(flights_spring$Distance[which(flights_spring$DayOfWeek=='Saturday')],  na.rm = T)
SunSp <- mean(flights_spring$Distance[which(flights_spring$DayOfWeek=='Sunday')], na.rm = T)

#Summer
flights_summer <- subset(flights, flights$Season=='Summer')
MonSu <- mean(flights_summer$Distance[which(flights_summer$DayOfWeek=='Monday')],  na.rm = T)
TueSu <- mean(flights_summer$Distance[which(flights_summer$DayOfWeek=='Tuesday')],  na.rm = T)
WedSu <- mean(flights_summer$Distance[which(flights_summer$DayOfWeek=='Wednesday')],  na.rm = T)
ThuSu <- mean(flights_summer$Distance[which(flights_summer$DayOfWeek=='Thursday')],  na.rm = T)
FriSu <- mean(flights_summer$Distance[which(flights_summer$DayOfWeek=='Friday')],  na.rm = T)
SatSu <- mean(flights_summer$Distance[which(flights_summer$DayOfWeek=='Saturday')],  na.rm = T)
SunSu <- mean(flights_summer$Distance[which(flights_summer$DayOfWeek=='Sunday')], na.rm = T)

#Fall
days <- as.array(levels(flights$DayOfWeek))
avgDistF <- c(MonF, TueF, WedF, ThuF, FriF, SatF, SunF)
distF <- cbind(avgDistF, days)
distF <- as.data.frame(distF)
distF$avgDistF <- as.numeric(distF$avgDistF)


f <- ggplot(distF, aes(x=days, y=avgDistF, group = 1))+
      ylim(705, 755)+
      geom_line(color = "#F4B400")+
      xlab("") + 
      ylab("") +
      geom_point()+
      theme_ipsum()+ 
      scale_x_discrete(limits = days)+
      ggtitle("Fall")+
      theme(panel.grid.major.x = element_blank()) 


#Winter
avgDistW <- c(MonW, TueW, WedW, ThuW, FriW, SatW, SunW)
distW <- cbind(avgDistW, days)
distW <- as.data.frame(distW)
distW$avgDistW <- as.numeric(distW$avgDistW)

w <- ggplot(distW, aes(x=days, y=avgDistW, group = 1))+
    ylim(705, 755)+ 
    geom_line(color = "#4285F4") +
    geom_point()+
    theme_ipsum()+ 
    scale_x_discrete(limits = days)+
    xlab("") + 
    ylab("") +
    ggtitle("Winter")+
    theme(panel.grid.major.x = element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())


#Spring
avgDistSp <- c(MonSp, TueSp, WedSp, ThuSp, FriSp, SatSp, SunSp)
distSp <- cbind(avgDistSp, days)
distSp <- as.data.frame(distSp)
distSp$avgDistSp <- as.numeric(distSp$avgDistSp)


sp <- ggplot(distSp, aes(x=days, y=avgDistSp, group = 1))+
  ylim(705, 755)+ 
  geom_line(color = "#0F9D58") +
  geom_point()+
  theme_ipsum()+ 
  scale_x_discrete(limits = days)+
  xlab("") + 
  ylab("") +
  ggtitle("Spring")+
  theme(panel.grid.major.x = element_blank()) 

#Summer
avgDistSu <- c(MonSu, TueSu, WedSu, ThuSu, FriSu, SatSu, SunSu)
distSu <- cbind(avgDistSu, days)
distSu <- as.data.frame(distSu)
distSu$avgDistSu <- as.numeric(distSu$avgDistSu)


su <- ggplot(distSu, aes(x=days, y=avgDistSu, group = 1))+
  ylim(705, 755)+ 
  geom_line(color = "#DB4437") +
  geom_point()+
  theme_ipsum()+ 
  scale_x_discrete(limits = days)+
  xlab("") + 
  ylab("") +
  ggtitle("Summer")+
  theme(panel.grid.major.x = element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) 


figure8 <- ggarrange(f, w, sp, su, ncol = 2, nrow = 2)

annotate_figure(figure8, top = text_grob("Average Distance Travelled per Day for each Season", 
                                      color = "black", face = "bold", size = 14))

#We observe that for every season travelers tend to take longer trips on Saturday
#We also observe that there is a noticeable increase in the distance traveled on Summer days.


##############
#10th Figure##
##############

#Number of Flights Departures for each hour of the day

flights$hourDep <- substr(flights$DepTime,1,2)
flights$hourDep <- as.factor(flights$hourDep)

rush <- count(flights, hourDep)
rush$hourDep <- as.numeric(rush$hourDep)
rush <- na.omit(rush) #remove NA
colnames(rush) <- c('hour', 'count')
rush$hour <- rush$hour - 1 
rush

ggplot(rush, aes(x = hour, y=count)) +
  geom_bar(width = 0.85, fill=alpha("4e909e", 0.8), stat = "identity") +
  theme_minimal() +
  scale_fill_brewer() +
  coord_polar(start=0) +
  scale_x_continuous("", limits = c(0, 24), breaks = seq(0, 24), labels = seq(0,24))+
  ggtitle("Number of Flight Departures for each hour of the day")+
  theme(plot.title = element_text(hjust = 0.5))+ 
  theme(plot.title = element_text(face = "bold"))+
  theme(axis.text=element_text(size=14, face="bold"),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        axis.title.y =element_blank(),
        panel.grid.major.y = element_blank())

#It can be observed that most flight departures take place from 8:00 to 17:00 
#while the number of night flight departures is extremely low.

