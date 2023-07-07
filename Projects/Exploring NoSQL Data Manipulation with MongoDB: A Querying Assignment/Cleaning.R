setwd("~/Library/Mobile Documents/com~apple~CloudDocs/MASTER/MSc Business Analytics/Semester 2/Big Data Systems and Architectures/Redis-Mongo Assignment-v1.3/BIKES")
library(jsonlite)
library(stringi)
library(mongolite)

jsonfiles <- read.table("files_list.txt", header = TRUE, sep="\n", stringsAsFactors = FALSE)


DataCleaning <- function(x) {
  #PRICE
  if (x$ad_data$Price == 'Askforprice'){
    x$ad_data$Price <- NULL #We identified that in some cases the field of price had 'Askforprice' as value. We replaced that with NULL
  }
  else if (as.numeric(gsub('[€.]', '', x$ad_data$Price)) < 200){
    x$ad_data$Price <- NULL #Extremely low prices were replaced with NULL
  }
  else{
    x$ad_data$Price <- as.numeric(gsub('[€.]', '', x$ad_data$Price)) #Convert price from string to numeric
  }
  
  #NEGOTIABLE
  if (grepl( "Negotiable", x$metadata$model) == TRUE ){
    x$ad_data$Negotiable <- TRUE #Create a new category which indicates if the price is negotiable or not. True means that the price is negotiable, while false corresponds to the opposite
  }else{
    x$ad_data$Negotiable <- FALSE
  }
  
  #MILEAGE
  if ('Mileage' %in% names(x$ad_data)){ #Checking whether the listing has information about Mileage (some of them do not have info about Mileage)
    if (as.numeric(gsub('[km,]', '', x$ad_data$Mileage)) > 750000){
      x$ad_data$Mileage <- NULL #replace with null the values of mileage which were extremely high and possibly fake
    }else{
      x$ad_data$Mileage <- as.numeric(gsub('[km,]', '', x$ad_data$Mileage))
    }
  }
  
  #REGISTRATION
  Production_Year <- as.numeric(stri_sub(x$ad_data$Registration,-4)) #Used the library(stringi) to take only the production year of each motorcycle
  if (Production_Year >2022){
    x$ad_data$Registration <- NULL
    x$ad_data$Age <- NULL
  }
  else if (Production_Year < 1920){
    x$ad_data$Registration <- NULL
    x$ad_data$Age <- NULL
  }
  else{
    x$ad_data$Age <- 2022-Production_Year #Calculated the Age of each motorcycle
  }
  return(x)
}

d <- c()
for (i in 1:nrow(jsonfiles)) {
  x <- fromJSON(readLines(jsonfiles[i,], warn=FALSE, encoding="UTF-8"))
  x <- DataCleaning(x)
  j <- toJSON(x, auto_unbox = TRUE)
  d <- c(d, j)
}


# Connection with mongodb
m <- mongo(collection = "ads",  db = "bikes_db", url = "mongodb://localhost")

# Insert json objects in mongodb
m$insert(d)

# Check if it has been inserted
m$find('{}')

