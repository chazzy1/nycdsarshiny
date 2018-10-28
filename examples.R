library('ggplot2')
library('tidyr')
library('dplyr')
noisedata <-
  read.csv(file = "data//311_Noise_Complaints_1month_manhattan.csv",
           header = TRUE,
           sep = ",")


head(noisedata)


noiseDesc <- noisedata %>%
  group_by(Descriptor) %>%
  summarise(incidentCount = n())



noiseDesc

pieplot <- ggplot(noiseDesc, aes(x=Descriptor, y=incidentCount))
pieplot + geom_bar(width = 1, stat="identity") 
pieplot + coord_polar()
