library(ggplot2)
library(data.table)
library(stringr)
library(stringi)
library(lubridate)

# Read the data about bees
DT_flow <- fread("flow_2017.csv")
DT_weight <- fread("weight_2017.csv")


# Average all of the measured variables that were recorded for the same moment in time
DT_flow<-dcast(DT_flow,timestamp~.,mean,value.var="flow") 
setnames(DT_flow,".","flow") 
DT_weight<-dcast(DT_weight,timestamp~.,mean,value.var="weight") 
setnames(DT_weight,".","weight")

# Merge into a single table
merge_rable <- merge(DT_flow, DT_weight, all.x = T)    

# Check the missing values                      
sum(is.na(merge_rable))
                      
# Change the timestamp frame into seperate columns
merge_rable$timestamp <- ymd_hms(merge_rable$timestamp)
merge_rable$month <- month(merge_rable$timestamp)
merge_rable$hour <- hour(merge_rable$timestamp)                    
merge_rable$day_of_year <- yday(merge_rable$timestamp)   

# Calculate the average weight for each month
Avg_weight_table <- dcast(merge_rable, month ~., mean, na.rm = T, value.var = c("weight"))

# Calculate the average flow for each month
Avg_flow_table <- dcast(merge_rable, hour ~., mean, na.rm = T, value.var = c("flow"))

# run a linear regression
model <- lm(flow ~ weight, data = merge_rable)
model








                      