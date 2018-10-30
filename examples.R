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

barplot <- ggplot(noiseDesc, aes(x = reorder(Descriptor, -incidentCount), y=incidentCount, fill=Descriptor))
barplot + geom_bar(width = 1, stat="identity")


