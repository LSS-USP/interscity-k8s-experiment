### Carrega cada um dos arquivos

folder = "/home/eduardo/Doutorado/experimentos/interscity-k8s-experiment/outputs"

data <- read.csv(paste(folder, "/12/response_time.csv", sep=""), header=TRUE, sep=',', colClasses= c("character","character","character","integer","character","numeric","numeric"),)
data2 <- read.csv(paste(folder, "/13/response_time.csv", sep=""), header=TRUE, sep=',', colClasses= c("character","character","character","integer","character","numeric","numeric"),)
data3 <- read.csv(paste(folder, "/14/response_time.csv", sep=""), header=TRUE, sep=',', colClasses= c("character","character","character","integer","character","numeric","numeric"),)

### o pacote matrixStats é carregado para usar a função rowSds

require("ggplot2")
require("matrixStats")

##### DATA 1 - Agrupa os dados do experimento 1 de 10 em 10 minutos

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


##### DATA 2 - Agrupa os dados do experimento 2 de 10 em 10 minutos

data2['request_sum'] <- 1
data2['request_sum'] <- sapply(data2['request_sum'], function(x) as.numeric(x))
hours <- c()
val <- min(data2$request_time_mili)
interval <- 600000
n <- (max(data2$request_time_mili) - min(data2$request_time_mili))/interval
for (x in 1:n) {
  hours <- c(hours, val)
  val <- val + interval
}

time2 <- aggregate(data2$request_sum, list(cut(data2$request_time_mili, breaks=hours)), sum)
time2$minute <- seq.int(nrow(time2))
time2 <- time2[time2$minute < 18, ] # limita a 180 minutos do experimento

####### DATA 3 - Agrupa os dados do experimento 3 de 10 em 10 minutos

data3['request_sum'] <- 1
data3['request_sum'] <- sapply(data3['request_sum'], function(x) as.numeric(x))
hours <- c()
val <- min(data3$request_time_mili)
interval <- 600000
n <- (max(data3$request_time_mili) - min(data3$request_time_mili))/interval
for (x in 1:n) {
  hours <- c(hours, val)
  val <- val + interval
}

time3 <- aggregate(data3$request_sum, list(cut(data3$request_time_mili, breaks=hours)), sum)
time3$minute <- seq.int(nrow(time3))
time3 <- time3[time3$minute < 18, ]# limita a 180 minutos do experimento

# Monta o data frame final com os resultados dos 3 experimentos

final <- time
final$request_sum2 <- time2$request_sum
final$request_sum3 <- time3$request_sum

x <- cbind(x1 = final$request_sum, x2 = final$request_sum2, x3 = final$request_sum3)

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