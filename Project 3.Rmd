---
title: "Project 3"
output:
  pdf_document: default
  html_document: default
  word_document: default
date: "October 4th 2020"
theme: cerulean
---


## Name: Project 3 

### This project deals with the analysis of the New York city flight  for 2013. Also includes useful 'metadata' on airlines, airports, weather, and planes. This data is already a package in r so it will be very important to install the package.

```{r}
### Working with New York City flights dataset already in r.
library(tidyverse)
library(nycflights13)
### By checking all the metadata
flights
airlines
planes
weather

### Checking if year, month, day, hour, and origin is a primary key for waether. 
weather %>% count(year, month, day, hour, origin) %>% filter(n>1)
#### It shows that weather is not a primary key because there are three instances where there are more than one observation.

### Checking if there are more than one observation for every combination of year, month, day, hour, tailnum.
flights %>% count(year, month, day, hour, tailnum) %>% filter(n>1)
### Yes there are.


flights %>% select(year, month, day, hour, minute)
flights1<- flights %>% select(year, month, day, hour, minute)
### Creating a new variable 'departure' from  the above five variables.
flights1 %>% mutate(departure= make_datetime(year, month, day, hour, minute))
```

### Joining two tables using mutations joins. Adding full names of the carrier from airlines to to the flight table. The flight table here contains only carrier codes. 
```{r}
flights %>% select(year, month, day, hour, tailnum, carrier) %>% left_join(airlines, by = "carrier")
```

### Creating a frequency plot for the number of departing flights 1.
```{r}
flights1 %>% mutate(departure= make_datetime(year, month, day, hour, minute)) %>% ggplot(aes(departure)) + geom_freqpoly(binwidth=86400) #86400 seconds= 1 day
```

### Keeping only flights with departure times earlier than 20130102.
```{r}
flights1 %>% mutate(departure= make_datetime(year, month, day, hour, minute)) %>% filter(departure< ymd(20130102)) %>% ggplot(aes(departure)) + geom_freqpoly(binwidth=600) # 600 seconds = 10 minutes.
```

### Keeping only flights with departure times after 20130102.
```{r}
flights1 %>% mutate(departure= make_datetime(year, month, day, hour, minute)) %>% filter(departure> ymd(20130102)) %>% ggplot(aes(departure)) + geom_freqpoly(binwidth=600) # 600 seconds = 10 minutes.
```

### Selecting some few columns in the flights data sets
```{r}
flights1<- flights %>% select(year, month, day, hour, carrier, flight, origin, dest, tailnum)
```

### Identifying the top 7 'origin and destination pairs of the flight1 data set created
```{r}
topflights<- flights1 %>% count(origin, dest, sort = TRUE) %>% head(7)
topflights
```

### Finding the flights the matches these top seven origin-destination pairs.
```{r}
flights1 %>% semi_join(topflights)
```


### Counting the observations in flights that do not have a match in planes data set.
```{r}
flights %>% anti_join(planes, by= "tailnum") %>% count(tailnum, sort = TRUE)
```


### joining flight1 and waether datasets using using left_join. You realize that they use the common variables as the key variables.
```{r}
flights1 %>% left_join(weather)
```

### Joining the flight1 and plane dataset by 'tailnum'. Look at this datsa carefully as there are two dates in ther combined dataset. year.x comes from the flight1 dataset and year.y comes from planes dataset.
```{r}
flights1 %>% left_join(planes, by = "tailnum")
```

### Using by arguments to specify keys consisting of multiple arguemnts. 
```{r}
flights1 %>% left_join(weather, by = c("origin", "year", "month", "day", "hour"))

### Without 'origin"
flights1 %>% left_join(weather, by = c( "year", "month", "day", "hour"))

### Another. 
flights1 %>% left_join(airports, by = c("dest"= "faa"))
```
