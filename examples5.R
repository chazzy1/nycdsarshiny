library(ggplot2)
library(dplyr)

noisedata <-
  read.csv(file = "data/311_Noise_Complaints_1month_manhattan.csv",
           header = TRUE,
           sep = ",")

#Sys.setlocale("LC_TIME", "en_US.UTF-8")

noiseSimpledata <- noisedata %>%
  select(Created.Date, Descriptor)

noiseSimpledata$date <- substr(noiseSimpledata$Created.Date,0,10)

head(noiseSimpledata)

noiseSimpledata$date <- as.Date(substr(noiseSimpledata$Created.Date,0,10), format = "%m/%d/%Y")

noiseSimpledata$weekdayf <- factor(format(noiseSimpledata$date, format="%a"))

head(noiseSimpledata)



noisedataDescSum <- noiseSimpledata %>%
  group_by(Descriptor) %>%
  summarise(incidentCount = n())



barplot <- ggplot(noisedataDescSum, aes(x = reorder(Descriptor, -incidentCount), y=incidentCount, fill=Descriptor))
barplot + geom_bar(width = 1, stat="identity") +
theme(      axis.text.x=element_blank(), legend.position="none")


noisedataWeekdaySum <- noisedata %>%
  group_by(weekdayf) %>%
  summarise(incidentCount = n())



head(noisedataWeekdaySum)

head(noisedataWeekdayDescSum)



# Loud Music/Party
# Noise: Construction Before/After Hours (NM1)
# Banging/Pounding
# Loud Talking
# Car/Truck Music
# Noise: Construction Equipment (NC1)
# Car/Truck Horn



noisedataWeekdayDescSum <- noiseSimpledata %>%
  filter(noiseSimpledata$Descriptor == "Loud Music/Party" | 
           noiseSimpledata$Descriptor == "Noise: Construction Before/After Hours (NM1)" | 
           noiseSimpledata$Descriptor == "Banging/Pounding" | 
           noiseSimpledata$Descriptor == "Loud Talking" | 
           noiseSimpledata$Descriptor == "Car/Truck Music" | 
           noiseSimpledata$Descriptor == "Noise: Construction Equipment (NC1)" | 
           noiseSimpledata$Descriptor == "Car/Truck Horn" 
         ) %>%
  group_by(Descriptor, weekdayf) %>%
  summarise(incidentCount = n())

head(noisedataWeekdayDescSum)

ggplot(subset(noisedataWeekdayDescSum,Descriptor == "Loud Music/Party"), aes(x=weekdayf,y=incidentCount)) + 
  geom_line(colour="red", group="asd")



noisedataWeekdayDescSum$weekdayf <- factor(noisedataWeekdayDescSum$weekdayf, levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))


ggplot(noisedataWeekdayDescSum, aes(x=weekdayf)) + 
  geom_line(aes(y=incidentCount,  colour=Descriptor, group=Descriptor),stat="identity", size=2)

