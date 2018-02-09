args = commandArgs(trailingOnly=TRUE)

if(length(args)!=2) {
  stop("At least two arguments must be supplied (working directory and input file)", call.=FALSE)
} else {
  setwd(args[1])
  data <- read.csv(args[2], header=TRUE, sep=',', colClasses= c("integer","integer","integer","integer"),)
}

data$minute <- seq.int(nrow(data))
data <- data[data$minute < 170,]

require("ggplot2")

theme_set(theme_gray(base_size = 16))
png('containers.png')
ggplot(data=data, aes(x=minute)) +
  geom_line(aes(y = data.collector, colour = "Data Collector")) + 
  geom_line(aes(y = resource.catalog, colour = "Resource Catalog")) + 
  geom_line(aes(y = resource.discovery, colour = "Resource Discovery")) + 
  geom_line(aes(y = kong, colour = "Kong")) + 
  scale_colour_manual("", 
                      breaks = c("Data Collector", "Resource Catalog", "Resource Discovery", "Kong"),
                      values = c("red", "green", "blue", "black")) +
  xlab("Experiment Time (m)") + ylab("Containers") + theme(legend.position="bottom")
dev.off()

