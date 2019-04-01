#Load libraries required for script
library(dplyr)


##Download the file if it doesn't exist
if(!file.exists("household_power_consumption.txt")){
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                      destfile = "electricpowerconsumption.zip")
        unzip("electricpowerconsumption.zip")
        
}

#The downloaded file requires 1,500,000*120*8 = 0.139GB of 
#RAM(ie 0.139*2 = 0.278GB to be sufficient)


#Read the text file into R
epcdt <- read.table("household_power_consumption.txt", sep = ";", 
                    header = TRUE, na.strings = "?")
epcdt$Date <- as.Date(epcdt$Date, "%d/%m/%Y")

#Cleanup the data a bit
names(epcdt) <- sapply(names(epcdt), function(x) gsub("\\_", "", x))
names(epcdt) <- tolower(names(epcdt))

##Filter Feb 02 and Feb 01 dates data, and store it in epcfeb
epcfeb <- epcdt %>% filter(date == c("2007-02-01", "2007-02-02"))

##Create column joining date and time
epcfebdt <- epcfeb %>% mutate(datetime = paste(date, time))
epcfebdt$datetime <- strptime(epcfebdt$datetime, "%Y-%m-%d %H:%M:%S")

##Start png device
png(filename = "plot4.png", width = 480, height = 480)

##Set device to carry 4 graphs
par(mfrow = c(2, 2))

#1. Create histogram for global active power on device
hist(epcfeb$globalactivepower,xlab = "Global Active Power (kilowatts)", 
     ylab = "Frequency", main = "", col = "red")

#2. plot the graph for voltage vs date
with(epcfebdt, plot(datetime, voltage, type = "l",
                    ylab = "Voltage"))

#3. Plot the graphs for sub metering
##plot empty graph
with(epcfebdt, plot(x = datetime, y= submetering1,
                    ylab = "Energy sub metering", type = "n"))
##Add graph for sub_meter_1
lines(epcfebdt$datetime, epcfebdt$submetering1, col = "black")
##Add graph for sub_meter_2
lines(epcfebdt$datetime, epcfebdt$submetering2, col = "red")
##Add graph for sub_meter_3
lines(epcfebdt$datetime, epcfebdt$submetering3, col = "blue")
##Add legend
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", 
        "Sub_metering_3"), col = c("black", "red", "blue"), 
       lty = 1, cex = 0.8)

#4. Plot the graph for global_reactive_power vs date
with(epcfebdt, plot(datetime, globalreactivepower, type = "l",
                    ylab = "Global_reactive_power"))

##Close the device
dev.off()