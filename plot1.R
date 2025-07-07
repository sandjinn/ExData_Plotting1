#############################################################################
####    Exploratory Data Analysis
####    Assignment 1
####    Plot 1
#############################################################################

#############################################################################
####    Preliminaries
###     Load Packages

library(data.table)


library(lubridate)

###     Download the zipped file into the working directory

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(fileUrl, destfile = "./data.zip", method = "curl")


###	    Unzip the file and save the unzip folder and unzipped file name

zip_file <- "./data.zip"
unzip_path <- "./unzip"

unzip(zip_file, exdir = unzip_path)

unzip_name <- list.files(unzip_path)


###     Reading in the data
#       Because the file is large the data will first be imported into a temp file
#       The temp file will then be subet to only include the dates needed
#       Save the data to a working data.frame and then close the temp file


dataTemp <- tempfile()

data_Temp <- read.table(paste(unzip_path,"/", unzip_name, sep = ""), header = TRUE, sep = ";")

data_in <- subset(data_Temp, data_Temp$Date == "1/2/2007" | data_Temp$Date == "2/2/2007")

unlink(dataTemp)

###     Cleaning the data
#       Create new data frame to hold processed data
#       Replace all existing NA symbols (?) with NA and s

data_work <- data_in

data_work[data_work == "?"] <- NA

#	Remove all cases with NA

data_work <- data_work[complete.cases(data_in),]

#	convert the date data to a time format
#	the format will go from dd/mm/yyyy to yyyy-mm-dd

data_work$Date <- as.Date(data_work$Date, format="%d/%m/%Y")

head(data_work)

#	Combine the date and time in preparation for converting the time to POSIXlt format which combines date and time

data_work$datetime <- paste(data_work$Date, data_work$Time)

head(data_work)

#	convert the time data to a POSIXlt with strptime()

data_work$datetime <- strptime(data_work$datetime, format="%Y-%m-%d %H:%M:%S")

head(data_work)

#############################################################################
####    Making Plot 1: Histogram of global active power (kilowatts)

#	Extract the Global Active Power values and make sure they are numeric

data1 <- as.numeric(data_work$Global_active_power)

#	Open plot device

png(filename = "plot1.png", width = 480, height = 480)


#	Plot the values and set the color, title and x axis label, and text sizes

hist(data1, col = "red", 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)",
     cex.main = 1,
     cex.lab = 0.9,
     cex.axis= 0.8)

#	Close plot device

dev.off()





