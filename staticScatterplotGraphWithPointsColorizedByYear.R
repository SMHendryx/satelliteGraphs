# Authored by Sean Hendryx
# R Script to visualize LAI (or other time series observation) by DOY and colorize points by year
require(ggplot2)

#To set working directory in R:
setwd("/your/path/here")
#^path to data

#Or place data in same directory as script and simply run Rscript:
df <- read.csv(file="SRM AZ statistics_Lai_1km.asc")

#Formatting date variables:
dates <- as.Date(df$date)
Year <- format(dates, format = "%Y")
months <- format(dates, format = "%m")
DOY <- format(dates, format = "%j")
#If you want to add a "column" to your data frame do:
df$DOY <- DOY

#VISUALIZE
p <- ggplot(aes(as.numeric(DOY),df$LAImean), data=df) +
  theme_bw() 

#Add fit line (smooth conditional mean) with 95% confidence interval
p <- p + geom_smooth(fill = "grey50", alpha = 1, aes(group = 1), method = "lm", formula= y ~ poly(x,4), level = .95)  

#Colorize points by year
p <- p + geom_point(alpha=1, shape=21, aes(colour = Year, fill = Year), size=5)

#Add axis labels
p <- p + labs(title = "Average LAI of the Santa Rita Mesquite Savannah from MODIS by DOY over 15 years") 
  #Manually adjust text size:
  #+ theme(axis.title = element_text(size = 18)) + theme(title = element_text(size = 20))
p <- p + labs(
    x = "Day Of Year",
    y = "Leaf Area Index"
  )

#Manually set tick locations
number_ticks <- function(n) {function(limits) pretty(limits, n)}
p <- p + scale_x_continuous(breaks=number_ticks(24))


p

