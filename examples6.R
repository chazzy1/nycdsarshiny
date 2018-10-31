library(ggplot2)
library(dplyr)

noisedata <-  read.csv(file = "data/311_Noise_Complaints_last_year.csv",
           header = TRUE,
           sep = ",")

noiseSimpledata <- noisedata %>%
  select(City, Descriptor)


head(noisedata)
noiseSimpledataSum <- noiseSimpledata %>%
  group_by(Descriptor, City) %>%
  summarise(incidentCount = n())

barplot <- ggplot(noiseSimpledataSum, aes(x = reorder(City, -incidentCount), y=incidentCount, fill=City))
barplot + geom_bar(width = 1, stat="identity") +
  theme(      axis.text.x=element_blank(), legend.position="none")




write.csv(noiseSimpledataSum, file = "data/noisebyborough.csv")


write.csv(noiseSimpledataSum, file = "data/noisebycity.csv")



noisebyborough <-
  read.csv(file = "data/noisebyborough.csv",
           header = TRUE,
           sep = ",")


barplot <- ggplot(noisebyborough, aes(x = reorder(Borough, -incidentCount), y=incidentCount, fill=Descriptor))
barplot + geom_bar(width = 1, stat="identity") +
  theme(      axis.text.x=element_blank(), legend.position="none")


