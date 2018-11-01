library(ggplot2)
library(dplyr)
library(lubridate)

noisedata <-
  read.csv(file = "data/311_Noise_Complaints_last_month.csv",
           header = TRUE,
           sep = ",")

Sys.setlocale("LC_TIME", "en_US.UTF-8")

head(noisedata)
nrow(noisedata)
noisedata$date <- as.Date(noisedata$Created.Date, format = "%m/%d/%Y %I:%M:%S %p")


noiseSimpledata <- noisedata %>%
  select(date, Descriptor, Borough, Latitude, Longitude) %>%
  filter(Descriptor == "Loud Music/Party") %>%
  #filter(date > (now() - days(7))) %>%
  arrange(desc(date)) %>%
  drop_na() %>%
  slice(1:3) 
  
noiseSimpledata

