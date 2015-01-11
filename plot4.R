## The R-script for generating the first graph of Course project 1 of the Exploratory
## Data Analysis class on coursera.org.
## The script reads data from the provided dataset (the zipfile was unzipped into the
## working directory), filters them according to specified dates and plots desired graph 
## into the file 'plot1.png' in the working directory.

# Data parsing using library dplyr. For memory and time saving, only a subset of data is
# read - parameters nrows and skip of the read.table() function.
library(dplyr)
a<-tbl_df(read.table("household_power_consumption.txt",
                     sep = ";", 
                     col.names = c("Date", "Time", "Global_active_power",
                                   "Global_reactive_power",
                                   "Voltage",
                                   "Global_intensity",
                                   "Sub_metering_1",
                                   "Sub_metering_2",
                                   "Sub_metering_3"),
                     na.strings = "?",
                     nrows = 3*24*60, # selects just 3 days interval (72 hours resp.)
                     skip = 24*60*46)) # cca 46 days after the begining of measurement 

# Joining date and time information into a single new row - 'datetime' stored in POSIXct format.
# Filtering data according to specified dates (2007/2/1 - 2007/2/2).
a <- a %>%
    mutate(datetime = paste(Date, Time) %>% 
               strptime(format = "%d/%m/%Y %H:%M:%S") %>% 
               as.POSIXct()) %>%
    filter(datetime >= as.POSIXct("2007-02-01"), datetime < as.POSIXct("2007-02-03"))


Sys.setlocale("LC_TIME", "en_US.UTF-8") # time locale changed to display English names of the weekdays

# Creating desired graph into the file 'plot4.jpg'.
png(filename="plot4.png", height = 480, width = 480, bg = "transparent")
par(mfrow=c(2,2))
within(a, {
plot(datetime, Global_active_power, pch = 46, type = "o", 
     xlab = "", ylab = "Global Active Power")
plot(datetime, Voltage, pch = 46, type = "o", xlab = names(a)[10], ylab = "Voltage")
plot(datetime, Sub_metering_1, pch = 46, type = "o", xlab = "", ylab = "Energy sub metering")
lines(datetime, Sub_metering_2, col = "red")
lines(datetime, Sub_metering_3, col = "blue")
legend("topright", names(a)[7:9], 
       col = c("black", "red", "blue"), bty = "n", lty=1)
plot(datetime, Global_reactive_power, pch = 46, type = "o", 
     xlab = names(a)[10], ylab = "Global_reactive_power")
})
dev.off()