### o pacote matrixStats é carregado para usar a função rowSds

require("ggplot2")
require("matrixStats")

### Carrega cada um dos arquivos

folder <- "/home/eduardo/Doutorado/experimentos/interscity-k8s-experiment/outputs/"
number <- 7

<<<<<<< HEAD
for (numData in 11:21) {
=======
for (numData in 13:(13 + number)) {
>>>>>>> 915f27ffc9c2a27c50f2a60daa31741347b335a1
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
<<<<<<< HEAD
  time <- time[time$minute < 17, ]
=======
  time <- time[time$minute < 15, ]
>>>>>>> 915f27ffc9c2a27c50f2a60daa31741347b335a1
  if (exists("final_load")) {
    columnName <- paste("request_sum_", numData, sep="")
    final_load[columnName] <- time$request_sum
  } else {
    final_load <- time
  }

  rate_data <- split(data, data$result)
  success <- rate_data[['success']]
  
  success$response_time <- success$response_time_mili - success$request_time_mili
  
  time_response <- aggregate(success$response_time, list(cut(success$request_time_mili, breaks=hours)), mean)
  time_response$minute <- seq.int(nrow(time_response))
<<<<<<< HEAD
  time_response <- time_response[time_response$minute < 17, ]
=======
  time_response <- time_response[time_response$minute < 15, ]
>>>>>>> 915f27ffc9c2a27c50f2a60daa31741347b335a1
  if (exists("final_response")) {
    columnName <- paste("response_time_", numData, sep="")
    final_response[columnName] <- time_response$x
  } else {
    final_response <- time_response
  }
  
  
  
<<<<<<< HEAD
  time_throughput <- aggregate(success$request_sum, list(cut(success$response_time_mili, breaks=hours)), sum)
  time_throughput$minute <- seq.int(nrow(time_throughput))
  time_throughput <- time_throughput[time_throughput$minute < 17, ]
  
  if (exists("final_throughput")) {
    columnName <- paste("throughput_", numData, sep="")
    final_throughput[columnName] <- time_throughput$request_sum
  } else {
    final_throughput <- time_throughput
  }
  
=======
>>>>>>> 915f27ffc9c2a27c50f2a60daa31741347b335a1
}

###### GENERATE LOAD GRAPH ######

drops <- c("Group.1","minute")
x <- data.matrix(final_load[ , !(names(final_load) %in% drops)], rownames.force = NA)

# calcula a media e o desvio padrão para as colunas definidas no comando acima
final_load$mean_request_sum <- rowMeans(x)
final_load$sd_request_sum <- rowSds(x)

final_load$minute <- final_load$minute * 10 # coloca os labels como intervalos de 10 min

theme_set(theme_gray(base_size = 18))
png('load_mean.png')
ggplot(data=final_load, aes(x=minute, y=mean_request_sum, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  geom_errorbar(width=.1, aes(ymin=mean_request_sum-sd_request_sum, ymax=mean_request_sum+sd_request_sum)) +
  xlab("Experiment Time (min)") + ylab("Perfomed Requests")
<<<<<<< HEAD
=======
dev.off()


###### GENERATE RESPONSE TIME GRAPH ######

x <- data.matrix(final_response[ , !(names(final_response) %in% drops)], rownames.force = NA)

# calcula a media e o desvio padrão para as colunas definidas no comando acima
final_response$mean_response_time <- rowMeans(x)
final_response$sd_response_time <- rowSds(x)

final_response$minute <- final_response$minute * 10 # coloca os labels como intervalos de 10 min

png('response_mean.png')
ggplot(data=final_response, aes(x=minute, y=mean_response_time, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  geom_errorbar(width=.1, aes(ymin=mean_response_time-sd_response_time, ymax=mean_response_time+sd_response_time)) +
  xlab("Experiment Time (min)") + ylab("Response Time (miliseconds)")
>>>>>>> 915f27ffc9c2a27c50f2a60daa31741347b335a1
dev.off()


###### GENERATE RESPONSE TIME GRAPH ######

x <- data.matrix(final_response[ , !(names(final_response) %in% drops)], rownames.force = NA)

# calcula a media e o desvio padrão para as colunas definidas no comando acima
final_response$mean_response_time <- rowMeans(x)
final_response$sd_response_time <- rowSds(x)

final_response$minute <- final_response$minute * 10 # coloca os labels como intervalos de 10 min


theme_set(theme_gray(base_size = 18))
png('response_mean.png')
ggplot(data=final_response, aes(x=minute, y=mean_response_time, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  geom_errorbar(width=.1, aes(ymin=mean_response_time-sd_response_time, ymax=mean_response_time+sd_response_time)) +
  xlab("Experiment Time (min)") + ylab("Response Time (miliseconds)")
dev.off()

###### GENERATE THROUGHPUT GRAPH ####

x <- data.matrix(final_throughput[ , !(names(final_throughput) %in% drops)], rownames.force = NA)

# calcula a media e o desvio padrão para as colunas definidas no comando acima
final_throughput$mean_throughput <- rowMeans(x)
final_throughput$sd_throughput <- rowSds(x)

final_throughput$minute <- final_throughput$minute * 10 # coloca os labels como intervalos de 10 min


theme_set(theme_gray(base_size = 18))
png('throughput_mean.png')
ggplot(data=final_throughput, aes(x=minute, y=mean_throughput, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  geom_errorbar(width=.1, aes(ymin=mean_throughput-sd_throughput, ymax=mean_throughput+sd_throughput)) +
  xlab("Experiment Time (min)") + ylab("Successful Responses")
dev.off()
