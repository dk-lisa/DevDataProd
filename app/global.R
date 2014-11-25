# usefull datamarket package to download data from the datamarket website
# install.packages("rdatamarket")
library(rdatamarket)

# Harmonised unemployment rates (%) - monthly data[Edit]
dm.19rf <- dmlist("19rf")

# General government deficit (-) and surplus (+)[Edit]
# dm.18ff <- dmlist("18ff")

entities <- as.factor(dm.19rf[,"Geopolitical.entity..declaring."])
dm.19rf$Entities <- entities

indicators <- as.factor(gsub("Unemployment according to ILO definition - ", "", dm.19rf$Indicator))
dm.19rf$Indicator <- indicators
