if (!file.exists("PowerConsumption.csv")) {
  # Read the Data to a data frame
  data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", na = "?", colClasses = c(rep("character", 2), rep("numeric", 7)))
  attach(data)
  data <- data[(Date == "1/2/2007" | Date == "2/2/2007"), ]
  attach(data)
  data$DateTime <- strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S")
  rownames(data) <- 1 : nrow(data)
  attach(data)
  data <- cbind(data[, 10], data[, 3:9])
  colname <- colnames(data)
  colname[1] <- "Date_time"
  colnames(data) <- colname
  attach(data)
  write.csv(data, file = "PowerConsumption.csv", row.names = FALSE)
} else {
  # Read the Data to a data frame
  data <- read.csv(file = "PowerConsumption.csv", header = TRUE)
  attach(data)
}

png(filename = "Plot2.png", width = 480, height = 480, units = "px")
Date_time <- as.POSIXct(Date_time, format = "%Y-%m-%d %H:%M:%S")
plot(Date_time, Global_active_power, type = "l", xlab = "Date Time", ylab = "Global Active Power (kilowatts)", xaxt = "n")
axis(1, at = c(1, 1441, 2880), labels = c("Thu", "Fri", "Sat"))
lines(Date_time, Global_active_power, col = "black")
dev.off()