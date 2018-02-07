### o pacote matrixStats é carregado para usar a função rowSds

require("ggplot2")
require("matrixStats")

### Carrega cada um dos arquivos

folder <- "/home/eduardo/Doutorado/experimentos/interscity-k8s-experiment/outputs/"
number <- 3

for (numData in 12:14) {
  pathFinal <- paste(folder, numData, sep="")
  pathFinal <- paste(pathFinal, "/response_time.csv", sep="")
  data <- read.csv(pathFinal, header=TRUE, sep=',', colClasses= c("character","character","character","integer","character","numeric","numeric"),)

  data['request_sum'] <- 1
  data['request_sum'] <- sapply(data['request_sum'], function(x) as.numeric(x))
  hours <- c()
  val <- min(data$request_time_mili)
  interval <- 600000
  n <- (max(data$request_time_mili) - min(data$request_time_mili))/interval
  for (x in 1:n) {
    hours <- c(hours, val)
    val <- val + interval
  }
  
  time <- aggregate(data$request_sum, list(cut(data$request_time_mili, breaks=hours)), sum)
  time$minute <- seq.int(nrow(time))
  time <- time[time$minute < 18, ]
  if (exists("final")) {
    columnName <- paste("request_sum_", numData, sep="")
    final[columnName] <- time$request_sum
  } else {
    final <- time
  }
}

drops <- c("Group.1","minute")
x <- data.matrix(final[ , !(names(final) %in% drops)], rownames.force = NA)

# calcula a media e o desvio padrão para as colunas definidas no comando acima
final$mean_request_sum <- rowMeans(x)
final$sd_request_sum <- rowSds(x)

final$minute <- final$minute * 10 # coloca os labels como intervalos de 10 min

png('load_mean.png')
ggplot(data=final, aes(x=minute, y=mean_request_sum, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  geom_errorbar(width=.1, aes(ymin=mean_request_sum-sd_request_sum, ymax=mean_request_sum+sd_request_sum)) +
  xlab("Hora do Dia") + ylab("Response Time (miliseconds)")
dev.off()
