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

#Create plot1 from epcfeb data
##Start png device
png(filename = "plot1.png", width = 480, height = 480)
##Create histogram for global active power on device
hist(epcfeb$globalactivepower, main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "red")
##Close device
dev.off()
