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

png(filename = "Plot3.png", width = 480, height = 480, units = "px")
plot(Date_time, Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering", xaxt = "n")
lines(Date_time, Sub_metering_1, col = "black")
lines(Date_time, Sub_metering_2, col = "red")
lines(Date_time, Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = 1)
axis(side = 1, at = c(1, 1441, 2880), labels = c("Thu", "Fri", "Sat"))
dev.off()