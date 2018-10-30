library(ggplot2) 
library(treemapify)



data(G20)
head(G20)


noisedata <-
  read.csv(file = "data//311_Noise_Complaints_1month_manhattan.csv",
           header = TRUE,
           sep = ",")


head(noisedata)

noiseDesc <- noisedata %>%
  group_by(Complaint.Type, Descriptor) %>%
  summarise(incidentCount = n())


head(noiseDesc)

ggplot(noiseDesc, aes(area = incidentCount, fill = incidentCount, label = Descriptor,
                subgroup = Complaint.Type)) +
  geom_treemap() +
  geom_treemap_subgroup_border() +
  geom_treemap_subgroup_text(place = "centre", grow = T, alpha = 0.5, colour =
                               "black", fontface = "italic", min.size = 0) +
  geom_treemap_text(colour = "white", place = "topleft", reflow = T)


ggplot(G20, aes(area = gdp_mil_usd, fill = hdi, label = country,
                subgroup = region)) +
  geom_treemap() +
  geom_treemap_subgroup_border() +
  geom_treemap_subgroup_text(place = "centre", grow = T, alpha = 0.5, colour =
                               "black", fontface = "italic", min.size = 0) +
  geom_treemap_text(colour = "white", place = "topleft", reflow = T)

