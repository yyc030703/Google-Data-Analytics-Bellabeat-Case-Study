# Google-Data-Analytics-Cyclistic-Case-Study
Capstone project for the Google Data Analytics Certificate on Coursera

## Table of Contents

1. [Introduction](README.md#introduction)
2. [Ask](README.md#ask)
3. [Prepare](README.md#prepare)
4. [Process](README.md#process)
5. [Analysis and Viz](README.md#analysis-and-viz)
6. [Conclusion and Recommendations](README.md#conclusions)
   
## Introduction
This Google Data Analytics Cyclistic Case Study is to work for a fictional company, Cyclistic. In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The goal is to design marketing strategies to convert casual riders into annual members and my own task is to understand how casual riders and Cyclistic members behave differently. In order to answer the key business questions, the steps of the data analysis process: ask, prepare, process, analyze, share, and act will be launched.

## Ask
> **Business Task**: To clean, analyze and visualize the data to observe how casual riders use the bike rentals differently from annual member riders and determine the best marketing strategies to turn casual bike riders into annual members.

## Prepare
The datasets are retrieved from https://divvy-tripdata.s3.amazonaws.com/index.html and are in .csv format. Given that the data is in large amounts, I decided to use Rstudio to prepare and clean up the data.

First, Install the required packages for the project.
```
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
```

Save each csv files into data frames.
```
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
```
Check if there is any mismatch of the column name before combining
```
compare_df_cols(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12, return = "mismatch")
```
Bind the dataframes into one dataframe
```
data2022<-rbind(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12)
```

## Process
Clean the data by dropping NA values and using the distinct function.
```
data2022_clean<-data2022%>%
  drop_na()%>%
  distinct()
```
Add columns that separate the dates into month, day, year and day of the week:
```
data2022_clean$Date<-as.Date(data2022_clean$started_at)
data2022_clean$Month<- format(as.Date(data2022_clean$Date), "%m")
data2022_clean$Day<- format(as.Date(data2022_clean$Date), "%d")
data2022_clean$Year<- format(as.Date(data2022_clean$Date), "%Y")
data2022_clean$Day_of_week<- format(as.Date(data2022_clean$Date), "%A")
```
Create a new columns called "ride length". The unit is second.
```
data2022_clean$ride_length <- difftime(data2022_clean$ended_at,data2022_clean$started_at)
```
Inspect the structure of the columns
```
str(data2022_clean)
```
Convert "ride_length" from Factor to numeric so we can run calculations on the data
```
is.factor(data2022_clean$ride_length)
data2022_clean$ride_length <- as.numeric(as.character(data2022_clean$ride_length))
is.numeric(data2022_clean$ride_length)
```
Remove "bad" data: The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality by Divvy or ride_length was negative
```
data2022_clean <- data2022_clean[!(data2022_clean$start_station_name == "HQ QR" | data2022_clean$ride_length<0),]
```

# Recommendations

* In order to convince casual users to become annual members, we need to convince them to see bicycles as an every day mode of transportation. This could be done by creating incentives for consistent use. An example would be presenting our bikes as an environmentally friendly alternative to cars and public transportation and creating an environmental awareness program, with rewards for annual members who consistently use the service.

* According to my analysis, the vast majority of casual riders use the bikes during the weekend. We could create limited time offers that only last during specific weekends, in order to both target as many casual members as possible and entice them with a time incentive.

* Casual riders' use of the bikes rises sharply, to even surpass that of members,  during the summer months. Thus, the best time to launch a major marketing campaign would be from mid May to early/mid September.
