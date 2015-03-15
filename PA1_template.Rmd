---
title: "Reproducible Research: Peer Assessment 1"
author: "PM02"
date: "Sunday, March 10, 2015"
output: html_document
keep_md: true
---

## Loading and preprocessing the data
Records with missing data **NA** are removed from the set
```{r}
all_data <- read.csv("activity.csv", colClasses = c("numeric", "Date", "numeric"))
data <- na.omit(all_data)
```

## What is mean total number of steps taken per day?
Check if *ggplot2* Library is Loaded
```{r}
require(ggplot2)
```

* Calculate the Steps per day
```{r}
steps_per_day <- aggregate(steps ~ date, data, sum)
```

* Construct a histogram. Breaks are set to **25**
```{r}
hist(steps_per_day$steps,
     breaks = 25,
     main = "Frequency of Number of Steps Per Day",
     xlab = "Number of steps",
     col = "#008888")
```

* Mean of the total number of steps taken per day
```{r}
mean(steps_per_day$steps)

````

* Median of the total number of steps taken per day
```{r}
median(steps_per_day$steps)

````


## What is the average daily activity pattern?
```{r}
interval <- aggregate(steps ~ interval, data, mean)
ggplot(interval, aes(x=interval,y=steps)) +
  geom_line(color="#0088aa") +
  labs(x="5 Minute Interval",y="Average Number of Steps")
```

* Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
```{r}
interval[interval$steps==max(interval$steps),1]
```


## Imputing missing values
* Number of NA (missing) step values in the dataset
```{r}
sum(is.na(all_data))
```

* Strategy for filling in all of the missing values
Missing step values (NA) were replaced by the mean number of steps taken


* New Dataset with missing data filled in
```{r}
## merge original activity data frame with interval data frame
newdata <- merge(all_data, interval, by = 'interval', all.y = F)
colnames(newdata) <- c("interval", "steps", "date", "meansteps")
```

* Histogram of the total number of steps taken per day with imputed values
```{r}
newtotal <- aggregate(steps ~ date, newdata, sum, na.rm = TRUE)
hist(newtotal$steps,
     breaks = 20,
     main = "Frequency of Number of Steps Per Day",
     xlab = "Number of steps",
     col = "#cc0088")
```

**Do these values differ from the estimates from the first part of the assignment?**

* Mean of the total number of steps taken per day
```{r}
mean(newtotal$steps)

````

* Median of the total number of steps taken per day
```{r}
median(newtotal$steps)

````



## Are there differences in activity patterns between weekdays and weekends?

* Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```{r}
weekend <- weekdays(as.Date(data$date)) %in% c("Saturday", "Sunday")
data$daytype <- "weekday"
data$daytype[weekend == TRUE] <- "weekend"
data$daytype <- as.factor(data$daytype)

## Show head of dataset adter adding weekend/weekday
head(data)
```

* Make a panel plot containing a time series plot

*Make sure lattice library is loaded*
```{r}
require(lattice)
```

Construct the Plot
```{r}
timeplot <- aggregate(steps ~ interval + daytype, data, mean)
xyplot(
      steps ~ interval | daytype,
      timeplot,
      type = "l",
      layout = c(1,2),
      main = "Time Series Plot of the 5-Minute Interval",
      xlab = "5-Minute Interval",
      ylab = "Average Number of Steps Taken"
)
```