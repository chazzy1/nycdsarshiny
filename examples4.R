library(ggplot2)
library(dplyr)
library(scales)
library(zoo)

noisedata <-
  read.csv(file = "data/noiseCalendarHeatmapYearlyIntermediate.csv",
           header = TRUE,
           sep = ",")

noisedataSum <- noisedata %>%
  group_by(year, yearmonthf, monthf, week, monthweek, weekdayf) %>%
  summarise(incidentCount = n())


head(noisedataSum)



ggplot(noisedataSum, aes(monthweek, weekdayf, fill = incidentCount)) + 
  geom_tile(colour = "white") + 
  facet_grid(year~monthf) + 
  scale_fill_gradient(low="red", high="green") +
  labs(x="Week of Month",
       y="",
       title = "Time-Series Calendar Heatmap", 
       subtitle="Yahoo Closing Price", 
       fill="Close")

