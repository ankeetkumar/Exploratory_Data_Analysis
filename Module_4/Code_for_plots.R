library(plyr)
library(ggplot2)
library(data.table)
library(grid)
library(scales)
library(httr)

setwd("D:/0_Coursera_courses/Exploratory_analysis/Module4")

if (!file.exists("NEI_data/")) {
  unzip("NEI_data/NEI_data.zip", exdir = "NEI_data/")
}
if (!"NEI" %in% ls()) {
  NEI <- readRDS("NEI_data/summarySCC_PM25.rds")
}
if (!"SCC" %in% ls()) {
  SCC <- readRDS("NEI_data/Source_Classification_Code.rds")
}

#Plot 1

png(filename = "./Plot1.png", width = 480, height = 480, units = "px")
if (!"totalEmissions" %in% ls()) {
  totalEmissions <- aggregate(NEI$Emissions, list(NEI$year), FUN = "sum")
}
plot(totalEmissions, type = "b", pch = 13, col = "red", xlab = "Year", main = expression('Total PM'[2.5]*" Emissions in the United States from 1999 to 2008"), ylab = expression('Total PM'[2.5]*" Emission (in tons)"))
dev.off()


#Plot 2

if (!"SCC" %in% ls()) {
  SCC <- readRDS("NEI_data/Source_Classification_Code.rds")
}
if (!"BaltimoreData" %in% ls()) {
  BaltimoreData <- NEI[NEI$fips == "24510", ]
}

png(filename = "Plot2.png", width = 480, height = 480, units = "px")
if (!"totalEmissionsBaltimore" %in% ls()) {
  totalEmissionsBaltimore <- aggregate(BaltimoreData$Emissions, list(BaltimoreData$year), FUN = "sum")
}
plot(totalEmissionsBaltimore, type = "b", pch = 20, col = "blue", xlab = "Year", main = expression('Total PM'[2.5]*" Emissions in Baltimore City, Maryland from 1999 to 2008"), ylab = expression('Total PM'[2.5]*" Emission (in tons)"))
dev.off()
#Plot 3

if (!"NEI" %in% ls()) {
  NEI <- readRDS("NEI_data/summarySCC_PM25.rds")
}
if (!"SCC" %in% ls()) {
  SCC <- readRDS("NEI_data/Source_Classification_Code.rds")
}
if (!"BaltimoreData" %in% ls()) {
  BaltimoreData <- NEI[NEI$fips == "24510", ]
}
if (!"BData" %in% ls()) {
  BData <- ddply(BaltimoreData, .(type, year), summarize, TotalEmissions = sum(Emissions))
}
png(filename = "Plot3.png", width = 500, height = 480, units = "px")
ggplot(BData, aes(year, TotalEmissions, colour = type)) + geom_line() + geom_point() + labs(title = expression('Total PM'[2.5]*" Emissions in Baltimore City, Maryland from 1999 to 2008"), x = "Year", y = expression('Total PM'[2.5]*" Emission (in tons)"))
dev.off()
#Plot 4

if (!file.exists("NEI_data")) {
  unzip("NEI_data.zip", exdir = "./data/NEI_data")
}
if (!"NEI" %in% ls()) {
  NEI <- readRDS("NEI_data/summarySCC_PM25.rds")
}
if (!"SCC" %in% ls()) {
  SCC <- readRDS("NEI_data/Source_Classification_Code.rds")
}
if (!"CoalNEI" %in% ls()) {
  Coal <- SCC[grep("Comb.*Coal", SCC$Short.Name), "SCC"]
  CoalNEI <- NEI[NEI$SCC %in% Coal, ]
}
if (!"TData" %in% ls()) {
  TData <- ddply(CoalNEI, .(year), summarise, TotalEmissions = sum(Emissions))
}
png(filename = "Plot4.png", width = 480, height = 480, units = "px")
ggplot(TData, aes(year, TotalEmissions)) + geom_line(color = "red") + geom_point() + labs(title = "Total Emissions from Coal Combustion-Related Sources", x = "Year", y = "Total Emissions")
dev.off()

#Plot 5

if (!"SCC" %in% ls()) {
  SCC <- readRDS("NEI_data/Source_Classification_Code.rds")
}
if (!"Motor" %in% ls()) {
  Motor <- ddply(NEI[NEI$fips == "24510" & NEI$type == "ON-ROAD",], .(type, year), summarize, TotalEmissions = sum(Emissions))
}
png(filename = "Plot5.png", width = 500, height = 480, units = "px")
ggplot(Motor, aes(year, TotalEmissions)) + geom_line(color = "green") + geom_point() + labs(title = "Total Emissions from Motor Vehicles in Baltimore City", x = "Year", y = "Total Emissions")
dev.off()

#Plot 6

#Plot 5
