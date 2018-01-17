args = commandArgs(trailingOnly=TRUE)

if(length(args)!=2) {
  stop("At least two arguments must be supplied (working directory and input file)", call.=FALSE)
} else {
  setwd(args[1])
  data <- read.csv(args[2], header=TRUE, sep=',', colClasses= c("character","character","character","integer","character","numeric","numeric"),)
}

require("ggplot2")

##############################################################################

#result <- data$result
#rate <- as.data.frame(table(result))
#
#Estado <- c("Erro", "Sucesso")
#theme_set(theme_gray(base_size = 18))
#png('rate.png')
#ggplot(rate, aes(result, Freq, fill=Estado)) + geom_bar(stat="identity", width=.6) +
#xlab("Estado da resposta da requisição") + ylab("Requisições") +
#theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())
#dev.off()
##############################################################################

data['request_sum'] <- 1
data['request_sum'] <- sapply(data['request_sum'], function(x) as.numeric(x))
hours <- c()
val <- min(data$request_time_mili)
interval <- 60000
n <- (max(data$request_time_mili) - min(data$request_time_mili))/interval
for (x in 1:n) {
  hours <- c(hours, val)
  val <- val + interval
}

time <- aggregate(data$request_sum, list(cut(data$request_time_mili, breaks=hours)), sum)
time$minute <- seq.int(nrow(time))

png('load.png')
ggplot(data=time, aes(x=minute, y=request_sum, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  xlab("Experiment Time (min)") + ylab("Perfomed Requests")
dev.off()

##############################################################################

hours <- c()
val <- min(data$response_time_mili)
interval <- 60000
n <- (max(data$response_time_mili) - min(data$response_time_mili))/interval
for (x in 1:n) {
  hours <- c(hours, val)
  val <- val + interval
}

time <- aggregate(data$request_sum, list(cut(data$response_time_mili, breaks=hours)), sum)
time$minute <- seq.int(nrow(time))

png('throughput.png')
ggplot(data=time, aes(x=minute, y=request_sum, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  xlab("Hora do Dia") + ylab("Successful Responses")
dev.off()



##############################################################################

#rate_data <- split(data, data$result)
#success <- rate_data[['success']]
#error <- rate_data[['error']]
#
#success$response_time <- success$response_time_mili - success$request_time_mili
#success['request_sum'] <- sapply(success['request'], sum )
#success['request_time'] <- sapply(success['request'], function(x) format(x, "%H:%M"))
#
#success['simulation_response'] <- success['simulation_time'] + success['response_time']
#success['simulation_response'] <- sapply(success['simulation_response'], function(x) as.numeric(x))
#
#theme_set(theme_gray(base_size = 18))
#png('response_time_boxplot.png')
#boxplot(success$response_time, outline=FALSE)
#dev.off()

##############################################################################

rate_data <- split(data, data$result)
success <- rate_data[['success']]
error <- rate_data[['error']]

success$response_time <- success$response_time_mili - success$request_time_mili

success['simulation_response'] <- success['simulation_time'] + success['response_time']
success['simulation_response'] <- sapply(success['simulation_response'], function(x) as.numeric(x))

interval <- 60000
n <- (max(data$request_time_mili) - min(data$request_time_mili))/interval

hours <- c()
val <- min(data$request_time_mili)
for (x in 1:n) {
  hours <- c(hours, val)
  val <- val + 60000
}
time <- aggregate(success$response_time, list(cut(success$request_time_mili, breaks=hours)), mean)
time$minute <- seq.int(nrow(time))

png('response_time.png')
ggplot(data=time, aes(x=minute, y=x, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  xlab("Hora do Dia") + ylab("Response Time (miliseconds)")
dev.off()




################### COUNT ERRORS

result <- data$result
rate <- as.data.frame(table(result))

Estado <- c("Erro", "Sucesso")
theme_set(theme_gray(base_size = 18))
png('rate.png')
ggplot(rate, aes(result, Freq, fill=Estado)) + geom_bar(stat="identity", width=.6) +
xlab("Estado da resposta da requisição") + ylab("Requisições") +
theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())
dev.off()


################### COUNT ERRORS BY MINUTE

data_error <- data[data$result == 'error',]

time <- aggregate(data_error$request_sum, list(cut(data_error$request_time_mili, breaks=hours)), sum)
time$minute <- seq.int(nrow(time))

png('error_minute.png')
ggplot(data=time, aes(x=minute, y=request_sum, group=1)) +
  geom_bar(stat="identity", fill="#56B4E9") +
  xlab("Experiment Time (min)") + ylab("Error Count")
dev.off()

print("DONE")
