library(dplyr)

file <- "C:\\Users\\parkj\\Documents\\Python\\AirBnB - Kyoto\\kyotolistings.csv"
data <- read.csv(file, header = TRUE, stringsAsFactors = FALSE)

data$rating<- gsub(" ·", "", as.character(data$rating))
data$reviews<- gsub(" reviews", "", as.character(data$reviews))

#Creating a new, clean data frame 
#Add name of accommodation

newdata <- data["name"]
newdata["type"] <- data["header"]
newdata["superhost"] <- data["superhost"]
newdata["guests"] <- sapply(strsplit(data$guests_rooms, "\\s+"), '[', 1)
newdata["bedrooms"] <- sapply(strsplit(data$guests_rooms, "\\s+"), '[', 4)
newdata["beds"] <- sapply(strsplit(data$guests_rooms, "\\s+"), '[', 7)
newdata["baths"] <- sapply(strsplit(data$guests_rooms, "\\s+"), '[', 10)

# If the bath is N/A, it should copy the value in beds and make beds N/A instead (guests-bedrooms-bath)
newdata["baths2"] <- newdata["baths"]
newdata$baths[is.na(newdata$baths)] <- newdata$beds[is.na(newdata$baths)]
newdata$beds[is.na(newdata$baths2)] <- "N/A"
newdata <- newdata %>% mutate_all(na_if, "N/A")
# Delete baths2
newdata$baths2 <- NULL

newdata["rating"] <- data["rating"]
newdata <- newdata %>% mutate_all(na_if, "")
newdata["reviews"] <- sapply(strsplit(data$reviews, "\\s+"), '[', 1)
#Not adding location, as they are in multiple languages (and they are all in the same city anyways)

newdata["badge"] <- data["rarity"]
newdata["badge_desc"] <- data["rarity_desc"]

#Get check-in and check-out times
newdata["checkin"] <- sapply(strsplit(data$house_rules, split = "Check-in: |Checkout: |Self|No"), '[', 2)
newdata["checkout"] <- sapply(strsplit(data$house_rules, split = "Check-in: |Checkout: |Self|No|Photo|Show"), '[', 3)
#All values are correct except for row 126 and 221, should be N/A
newdata[126, "checkout"] <- NA
newdata[221, "checkout"] <- NA

#Check for Carbon Monoxide (CO) alarm
newdata$CO_alarm <- ifelse(grepl("No carbon", data$health_safety), "No", "Yes")

#Cancellation flexibility
newdata$free_cancellation <- ifelse(grepl("cancellation for 48", data$cancellation), "Within 48 Hrs", "Flexible")

newdata["per_night"] <- sapply(strsplit(data$per.night, split = "\\s+|\\$"), '[', 2)
newdata["total_price"] <- sapply(strsplit(data$total.price, split = "\\$"), '[', 2)
newdata["host"] <- data["host"]
newdata["url"] <- data["url"]

#There are a few listings that were removed (row 200 and 220) during the time I am cleaning so I am removing those (no host and broken URL)
library(tidyr)
newdata[200, "host"] <- NA
newdata[220, "host"] <- NA
newdata <- newdata %>% drop_na(host)
