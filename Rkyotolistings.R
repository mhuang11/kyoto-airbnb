library(dplyr)

file <- "C:\\Users\\parkj\\OneDrive\\Documents\\Projects\\Test\\kyoto-airbnb\\kyotolistings.csv"
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

#Make accomodation "type" consistent (remove "hosted by ...")
newdata["type"] <- sapply(strsplit(as.character(newdata$type), split="hosted"), '[', 1)

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

#Dividing the Check-in times to From and Until to clean it up further:
newdata["checkin_from"] <- sapply(strsplit(as.character(newdata$checkin), split = "-"), '[', 1)
newdata["checkin_until"] <- sapply(strsplit(as.character(newdata$checkin), split = "-"), '[', 2)
#And remove checkin
newdata["checkin"] <- NULL
#Relocate the new columns before checkout
newdata <- newdata %>% relocate("checkin_from", .before = "checkout")
newdata <- newdata %>% relocate("checkin_until", .before = "checkout")

#All values are correct except for row 126 and 221, should be N/A
newdata[127, "checkout"] <- NA
newdata[221, "checkout"] <- NA

#Check for Carbon Monoxide (CO) alarm
newdata$CO_alarm <- ifelse(grepl("No carbon", data$health_safety), "No", "Yes")

#Cancellation flexibility
newdata$free_cancellation <- ifelse(grepl("cancellation for 48", data$cancellation), "Within 48 Hrs", "Flexible")

newdata["per_night"] <- sapply(strsplit(data$per.night, split = "\\s+|\\$"), '[', 2)
newdata["total_price"] <- sapply(strsplit(data$total.price, split = "\\$"), '[', 2)
newdata["host"] <- data["host"]

#Host Response Rate and Language
newdata["host_response"] <- sapply(strsplit(data$host_response, split = "Response rate: |Response"), '[', 2)
newdata["url"] <- data["url"]

#Get Location (City Only)
newdata$city <- NA
newdata$city[grep('Shimo|下京', data$location)] <- 'Shimogyo'
newdata$city[grep('Nakagy|中京', data$location)] <- 'Nakagyo'
newdata$city[grep('Minami|南', data$location)] <- 'Minami'
newdata$city[grep('Higashiyama|東山', data$location)] <- 'Higashiyama'
newdata$city[grep('Saky|左京', data$location)] <- 'Sakyo'
newdata$city[grep('Kamig|上京', data$location)] <- 'Kamigyo'
newdata$city[grep('Kita|北', data$location)] <- 'Kita'
newdata$city[grep('Fushimi|伏見', data$location)] <- 'Fushimi'
newdata$city[grep('Ukyo|右京', data$location)] <- 'Ukyo'
#Reorder "city"
newdata <- newdata %>% relocate("city", .before = "superhost")

#Describe property type as Entire Home, Condos/Apt, or Private Room.
newdata$property <- NA
newdata$property[grep('Entire home|Entire Home|Entire townhouse|Entire vacation home|Entire villa|Hut|Tiny home', newdata$type)] <- 'Entire home'
newdata$property[grep('Entire condo|Entire rental unit|Entire serviced apartment|aparthotel', newdata$type)] <- 'Condo/Apt'
newdata$property[grep('guest suite|Private room|boutique|Room in hotel', newdata$type)] <- 'Private room'
#Reorder "property"
newdata <- newdata %>% relocate("property", .before = "city")

#Change value type in "beds" from character to integer
newdata$beds <- strtoi(newdata$beds, base=16)

#There are a few listings that were removed during the time I am cleaning so I am removing those (no host and broken URL)
library(tidyr)
newdata[220, "host"] <- NA
newdata[218, "host"] <- NA
newdata[200, "host"] <- NA
newdata[155, "host"] <- NA
newdata <- newdata %>% drop_na(host)

#Only first line is "Entire Home", make it "Entire home"
newdata[1, "type"] <- "Entire home"

#190 and 192 need minor tweaking, the room is a rare case (ex. instead of "Studio" for bedroom, changing it to 1)
newdata[190, "bedrooms"] <- 1
newdata[190, "baths"] <- 1
newdata[192, "baths"] <- 1

#Export newdata as csv
write.csv(newdata,"C:\\Users\\parkj\\OneDrive\\Documents\\Projects\\Test\\kyoto-airbnb\\cleankyotolistings.csv", row.names = TRUE)

