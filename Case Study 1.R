install.packages("tidyverse")
install.packages("janitor")
install.packages("ggmap")
library(tidyverse)
library(tibble)
library(readr)
library(janitor)
library(rmarkdown)
library(ggplot2)
library(ggmap)

df1<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202201-divvy-tripdata.csv", header = TRUE)
df2<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202202-divvy-tripdata.csv", header = TRUE)
df3<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202203-divvy-tripdata.csv", header = TRUE)
df4<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202204-divvy-tripdata.csv", header = TRUE)
df5<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202205-divvy-tripdata.csv", header = TRUE)
df6<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202206-divvy-tripdata.csv", header = TRUE)
df7<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202207-divvy-tripdata.csv", header = TRUE)
df8<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202208-divvy-tripdata.csv", header = TRUE)
df9<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202209-divvy-publictripdata.csv", header = TRUE)
df10<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202210-divvy-tripdata.csv", header = TRUE)
df11<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202211-divvy-tripdata.csv", header = TRUE)
df12<-read.csv("/Users/yangyungchyi/Documents/Learn/Cyclistic/202212-divvy-tripdata.csv", header = TRUE)

#check if there is any mismatch of the column name before combining

compare_df_cols(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12, return = "mismatch")

#bind the dataframes into one dataframe
data2022<-rbind(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12)

#cleaning data
data2022_clean<-data2022%>%
  drop_na()%>%
  distinct()

#Add columns
data2022_clean$Date<-as.Date(data2022_clean$started_at)
data2022_clean$Month<- format(as.Date(data2022_clean$Date), "%m")
data2022_clean$Day<- format(as.Date(data2022_clean$Date), "%d")
data2022_clean$Year<- format(as.Date(data2022_clean$Date), "%Y")
data2022_clean$Day_of_week<- format(as.Date(data2022_clean$Date), "%A")

data2022_clean$ride_length <- difftime(data2022_clean$ended_at,data2022_clean$started_at)

# Inspect the structure of the columns
str(data2022_clean)

# Convert "ride_length" from Factor to numeric so we can run calculations on the data
is.factor(data2022_clean$ride_length)
data2022_clean$ride_length <- as.numeric(as.character(data2022_clean$ride_length))
is.numeric(data2022_clean$ride_length)

# Remove "bad" data
# The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality by Divvy or ride_length was negative
data2022_clean <- data2022_clean[!(data2022_clean$start_station_name == "HQ QR" | data2022_clean$ride_length<0),]

#Analyze
#summarize
summary(data2022_clean$ride_length)

# Compare members and casual users
aggregate(data2022_clean$ride_length ~ data2022_clean$member_casual, FUN = mean)
aggregate(data2022_clean$ride_length ~ data2022_clean$member_casual, FUN = median)
aggregate(data2022_clean$ride_length ~ data2022_clean$member_casual, FUN = max)
aggregate(data2022_clean$ride_length ~ data2022_clean$member_casual, FUN = min)

# See the average ride time by each day for members vs casual users
aggregate(data2022_clean$ride_length ~ data2022_clean$member_casual + data2022_clean$Day_of_week, FUN = mean)

# Reorder days of the week
data2022_clean$Day_of_week <- ordered(data2022_clean$Day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# rerun the average ride time by each day for members vs casual users
aggregate(data2022_clean$ride_length ~ data2022_clean$member_casual + data2022_clean$Day_of_week, FUN = mean)

# analyze ridership data by type and weekday
data2022_clean %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n()							
            ,average_duration = mean(ride_length)) %>% 		
  arrange(member_casual, weekday)
