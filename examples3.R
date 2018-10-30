library(ggplot2)
library(dplyr)
#library(plyr)
library(scales)
library(zoo)





#> Sys.getlocale("LC_TIME")
#[1] "ko_KR.UTF-8"
#Sys.setlocale("LC_TIME", "en_US.UTF-8")
#[1] "en_US.UTF-8"


Sys.setlocale("LC_TIME", "en_US.UTF-8")

noisedata <-
  read.csv(file = "data/311_Noise_Complaints_last_year.csv",
           header = TRUE,
           sep = ",")


noisedata <- noisedata %>%
  select(Created.Date, Descriptor)



#noisedata <- noisedata[noisedata$year >= 2012, ]  # filter reqd years

noisedata$date <- as.Date(noisedata$Created.Date, format = "%m/%d/%Y %I:%M:%S %p")

noisedata$yearmonth <- as.yearmon(noisedata$date)
noisedata$yearmonthf <- factor(noisedata$yearmonth)

noisedata$week <- strtoi(format(noisedata$date, format="%W"))
noisedata$year <- format(noisedata$date, format="%Y")
noisedata$weekdayf <- factor(format(noisedata$date, format="%a"))
noisedata$monthf <- format(noisedata$date, format="%b")

#noisedata <- noisedata %>% 
#  mutate(monthweek=1+week-min(week))

head(noisedata)



noisedataSum <- noisedata %>%
  group_by(year, yearmonthf, monthf, week, weekdayf) %>%
  summarise(incidentCount = n())


noisedataSum

noisedataSum <- noisedataSum %>% dplyr::group_by(year,monthf) %>% 
  dplyr::mutate(monthweek=1+week-min(week)) %>% 
  dplyr::ungroup() 

#noisedata <- ddply(noisedata,.(yearmonthf), transform, monthweek=1+week-min(week))

write.csv(noisedata, file = "noiseCalendarHeatmapYearlyIntermediate.csv")

#mydates <- as.Date(c("2007-06-22", "2004-02-13"))
#format(mydates, format="%m/%d/%Y %I:%M:%S %p %U")
show(noisedata)
noisedata

noisedataSum <- noisedata %>%
  group_by(year, yearmonthf, monthf, week, monthweek, weekdayf) %>%
  summarise(incidentCount = n())

noisedataSum

write.csv(noisedataSum, file = "noiseCalendarHeatmap.csv")



ggplot(noisedataSum, aes(monthweek, weekdayf, fill = incidentCount)) + 
  geom_tile(colour = "white") + 
  facet_grid(year~monthf) + 
  scale_fill_gradient(low="red", high="green") +
  labs(x="Week of Month",
       y="",
       title = "Time-Series Calendar Heatmap", 
       subtitle="Yahoo Closing Price", 
       fill="Close")
