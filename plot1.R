## The R-script for generating the first graph of Course project 1 of the Exploratory
## Data Analysis class on coursera.org.
## The script reads data from the provided dataset (the zipfile was unzipped into the
## working directory), filters them according to specified dates and plots desired graph 
## into the file 'plot1.png' in the working directory.

# Data parsing using library dplyr. For memory and time saving, only a subset of data is
# read - parameters nrows and skip of the read.table() function.
library(dplyr)
consumption<-tbl_df(read.table("household_power_consumption.txt",
                     sep = ";", 
                     col.names = c("Date", "Time", "Global_active_power",
                                   "Global_reactive_power",
                                   "Voltage",
                                   "Global_intensity",
                                   "Sub_metering_1",
                                   "Sub_metering_2",
                                   "Sub_metering_3"),
                     na.strings = "?",
                     nrows = 3*24*60, #selects just 3 days interval (72 hours resp.)
                     skip = 24*60*46)) #cca 46 days after the begining of measurement 

# Joining date and time information into a single new row - 'datetime' stored in POSIXct format.
# Filtering data according to specified dates (2007/2/1 - 2007/2/2).
consumption <- consumption %>%
    mutate(datetime = paste(Date, Time) %>% 
               strptime(format = "%d/%m/%Y %H:%M:%S") %>% 
               as.POSIXct()) %>%
    filter(datetime >= as.POSIXct("2007-02-01"), datetime < as.POSIXct("2007-02-03"))

# Creating desired graph into the file 'plot1.jpg'.
png(filename="plot1.png", height = 480, width = 480, bg = "transparent")
hist(consumption$Global_active_power, 
     col = "red", 
     xlab = "Global Active Power (kilowatts)", 
     ylab = "Frequency", 
     main = "Global Active Power")
dev.off()