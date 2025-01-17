#----
## Manipulacion de datos
# The tidyverse package
#----

# Usage:
install.packages("tidyverse")  # download package from CRAN
library(tidyverse)             # load package into your worksession          

# Calculate the average `Unit.price.deal`:

# R:
mean(BenAndJerry$Unit.price.deal) 

# `tidyverse`:
BenAndJerry$Unit.price.deal %>%   # forward unit price into mean()
  mean()

# Check for observations with missing purchases:

# R
sum(is.na(BenAndJerry$total_spent))

# `tidyverse`:
BenAndJerry$total_spent %>%      # forward spendings into is.na()
  is.na() %>%                    # forward the result of is.na() into sum()
  sum()                          


#----
# Data manipulation with `dplyr`
#----

# `mutate()`: adds new variables that are functions of existing variables.
# `group_by()`: groups data by categorical variables.
# `summarise()`: summarizes the data.
# `select()`: picks existing variables based on their names.
# `filter()`: picks existing observations based on their values.
# `arrange()`: changes the ordering of the rows in the output.

# Check for observations with 0 or negative pruchases:
BenAndJerry %>%
  mutate(selection = total_spent <= 0) %>%
  summarize(sum. = sum(selection))

# Calculate the `price_paid_deal` PER UNIT. 
# Obtain the average unit price grouped by `size1_descr` (package size) and `formula_descr` (fat).
BenAndJerry %>%
  mutate(Unit.price.deal = price_paid_deal/quantity) %>%
  group_by(size1_descr, formula_descr) %>%
  summarize(mean = mean(Unit.price.deal))

# Putting it all togehter: 
BenAndJerry %>%
  filter(total_spent > 0) %>%
  mutate(Unit.price.deal = price_paid_deal/quantity) %>%
  group_by(size1_descr, formula_descr) %>%
  summarize(n = n(),
            mean = mean(Unit.price.deal),
            sd = sd(Unit.price.deal))

#----
# Data types in datasets
#----

#----
# Factors
#----

# Convert character values into `factors` with the `factor()`-function:
fat.content <- factor(BenAndJerry$formula_descr)
fat.content

# Check the levels of a factor with `levels()`:
levels(fat.content)

# Check the number of levels with `nlevels()`:
nlevels(fat.content)

# The function `summary()` handles factors differently to characters (and numbers):
summary(BenAndJerry)

# Override the elements of `formula_descr` with `fat.content`:
BenAndJerry$formula_descr <- fat.content
summary(BenAndJerry)


#----
# Unordered factors
#----

levels(fat.content)  # raw data levels
min(fat.content)     # doesn't work

#----
# Ordered factors
#----

fat.content <- factor(fat.content, levels = c("LIGHT HALF THE FAT", "REGULAR"), 
                      ordered = TRUE) # order levels

min(fat.content)     # works!
max(fat.content)     # works too!
range(fat.content)

# Changing the order of factor levels (warning: works only for unordered factors):
div.fat <- factor(sample(c("regular", "skimmed", "light"), 
                         size = 10, replace = TRUE))       # Generate a random vector of unordered factors

div.fat <- relevel(div.fat, "skimmed") # Make skimmed first
div.fat

div.fat <- relevel(div.fat, "regular") # Make regular first
div.fat

#----
# Renaming factor levels
#----

div.fat <- factor(sample(c("regular", "skimmed", "light"), 
                         size = 10, replace = TRUE), 
                  levels=c("regular","light","skimmed"), ordered=TRUE) # Generate a random vector of ordered factors

# Replace all factor levels:
levels(div.fat) <- c("10% fat", "6% fat", "0% fat")
div.fat

# Replace a single factor level by name:
levels(div.fat)[levels(div.fat) == "light"] <- "6% fat"
levels(div.fat)

# Replace a single factor level by position:
levels(div.fat)[1] <- "6% fat"
levels(div.fat)[2] <- "10% fat"
levels(div.fat)


# Rename several factor levels with `revalue()` and `mapvalues()` from `plyr`:

div.fat <- factor(sample(c("regular", "skimmed", "light"), 
                         size = 10, replace = TRUE), 
                  levels=c("regular","light","skimmed"), ordered=TRUE) # Generate a random vector of ordered factors

revalue(div.fat, c("regular" = "10% fat", "light" = "6% fat"))
mapvalues(div.fat, from = c("regular", "light"), to = c("10% fat", "6% fat"))


#----
# Dates and times
#----

# Standard formats:
as.Date("1915-6-16")
as.Date("1990/02/17")

# Convert dates to its internal form:
dates <- as.Date(c("1/10/70", "10/1/70", "1/1/00", "9/17/19"), 
                 format = "%m/%d/%y") # dates in non-standard format
dates

# Obtain the days passed since January 1, 1970:
as.numeric(dates) 

# Find the corresponding days of the week:
weekdays(dates)   

# Obtain the a sequence of each day of the year 2019:
year.2019 <- seq(from = as.Date("2019-1-1"), to = as.Date("2019-12-31"), by = "day")
year.2019 <- seq.Date(as.Date("2019-1-1"), to = as.Date("2019-12-31"), by = "day")
year.2019

# Some simple descriptives
median(year.2019)
min(year.2019)
min(year.2019)
range(year.2019)

#----
# Date / time arithmetics
#----

# Calculate the difference between the 1st and the 11th day of 2019
year.2019[11] - year.2019[1]

# in minutes:
difftime(year.2019[11], year.2019[1], units="mins")
# in hours:
difftime(year.2019[11], year.2019[1], units="hours")

# Generate a sequence of dates, each entry being the last day of the month:
dates <- seq(as.Date("2019-1-31"), to = as.Date("2019-12-31"), by = "month")
dates    # not necessarily what was expected!

# install.packages(lubridate)
library(lubridate)

dates <- as.Date("2018-01-31") %m+% months(seq(0,12))
dates    # correct!

# Extract the month from the dates:
month(dates)
# Find the corresponding days of the week:
wday(dates, label = TRUE)   

#----
# More date / time arithmetics
#----

# Calculate the time difference between two events:
start <- c("2019-08-21", "2019-09-01", "2019-08-15", "2019-09-18")
end <- c("2019-09-16", "2019-09-06", "2019-08-22", "2019-10-11")
elapsed.time <- start %--% end

# Obtain the time difference in seconds:
as.duration(elapsed.time)

# Converted the time difference to weeks:
as.duration(elapsed.time) / dweeks(1)


#----
# Indexing
#----

# Vector indexing
x_vec <- 2*(1:25)

x_vec[3]              # specific element
x_vec[length(x_vec)]  # last element
x_vec[c(1,5,6,10)]    # subset of elements
x_vec[11:19]          # range of elements
x_vec[c(1,3:5,7:25)]  # combination of ranges and single elements
x_vec[-c(1,3)]        # all but a few elements
x_vec[x_vec>10]       # all elements satisfying a certain condition

# Matrix indexing
x_mat <- matrix(x_vec,nrow=5,ncol=5)

x_mat[23]             # specific element as if all columns would be stacked as one big vector
x_mat[3,5]            # specific element using (row, column) coordinates               
x_mat[nrow(x_mat),ncol(x_mat)]  # last element
x_mat[3,]             # complete row
x_mat[,5]             # complete column
x_mat[2:3,c(1,5)]     # selection of rows and/or columns    
x_mat[,-1]            # all but one column
x_mat[x_mat<8]        # all elements satisfying a certain condition (returned as vector)

# List indexing
x_list <- list(x_vec, x_mat, "This is a list")

x_list[c(1,3)]        # return a sublist
x_list[[3]]           # access a specific element of a list
x_list[[2]][2:3,4]    # access elements of a list element
x_list[2][3,4]        # will not work, because x_list[2] is still a list and not a matrix

x_list <- list(vec = x_vec, mat = x_mat, text = "This is a list")

x_list$text           # select a named list element
x_list$vec[5:12]      # indexing on a named list element
x_list[[1]][5:12]     # indexing with numbers still works

# Data frame indexing
x_df <- data.frame(x_mat)

x_df[2:3,c(1,5)]      # (row, column) indexing works the same as for matrices
x_df[4:5]             # for single indexing, the data frame is treated as a list and returns a sublist of columns
x_df[[3]]             # to select a specific column with single indexing, use double brackets
x_df$V3               # column names can also be used to select columns
x_df[x_df>40]         # logical indexing works the same as for matrices

# Store selected elements in a new variable
a <- x_vec[1:3]
a
b <- x_mat[,-1]
b

# Change selected elements
x_vec[x_vec<10] <- 0
x_vec

x_df[,1] <- x_df[,2]
x_df

#---- 
# Functions
#----

# Creating a custom function
square <- function(x) {
  sq <- x^2
  return(sq)
}

# Calling your custom function
square(2)               # print result
a <- square(2)          # store result in variable
b <- square(a)          # use variable as input
c <- square(square(3))  # use output of function as input of another function

# Multiple inputs
product <- function(x,y) {
  return(x*y)
}

product(2,3)

# Return multiple outputs in a list
sum_and_diff <- function(x,y) {
  a <- x + y
  b <- x - y
  return(list(a,b))
}

sum_and_diff(10,3)
s <- sum_and_diff(10,3)[[1]]
d <- sum_and_diff(10,3)[[2]]

# Return named outputs in a list
sum_and_diff <- function(x,y) {
  a <- x + y
  b <- x - y
  return(list(sum = a, diff = b))
}

sum_and_diff(10,3)
s <- sum_and_diff(10,3)$sum
d <- sum_and_diff(10,3)$diff
s <- sum_and_diff(10,3)[[1]] # you can still access elements through indexing

# Named arguments
power <- function(base = x, exp = y) {
  return(base^exp)
}

power(3,2)
power(2,3)
power(base=3,exp=2)
power(exp=2,base=3) # arguments can be in different order

# Default values for arguments
power <- function(base = x, exp = 2) {
  return(base^exp)
}

power(2) # exp is now optional, it does not have to be specified
power(2,3)

#----
# Loops
#----
# Example: raise x to the power of x
x <- 1:5

# Inefficient coding
x[1]^x[1]
x[2]^x[2]
x[3]^x[3]
x[4]^x[4]
x[5]^x[5] 

# Efficient coding
for (i in 1:length(x)) {
  print(x[i]^x[i])
} 

# Alternative for-loop
for (i in x) {
  print(i^i)
} 

# Store results in a vector (instead of printing)
y <- integer(5) # intialize zero vector of length 5
for (i in 1:5) {
  y[i] <- x[i]^x[i]
  print(y) # let's print y in each iteration to see what happens
}

# Nested for loops
x <- matrix(1:9,3,3)
y <- matrix(0,nrow(x),ncol(x)) # initialize 3x3 zero matrix
for (i in 1:nrow(x)) {
  for (j in 1:ncol(x)) {
    y[i,j] <- x[i,j]^x[i,j]
  }
}
y

# For loops are relatively slow; use vector operations if possible
x <- sample(c(1:10),10^6,replace=TRUE)
y <- integer(10^6)

start_time <- Sys.time()
for(i in 1:length(x)) {
  y[i] <- log(x[i])
}
print(Sys.time() - start_time)    # slow

start_time <- Sys.time()
y <- log(x)
print(Sys.time() - start_time)    # fast

#----
# Conditions
#----

# Example: Using if to count zeros in a vector
x <- c(0,3,1,0,0,2,1)
count <- 0              # initialize count at 0

for (i in 1:length(x)) {
  if (x[i] == 0) {      # note the double "==", to check for an equality
    count <- count+1    # increase count by 1 if a zero is found
  }
}
count

# Example: using if-else to calculate the absolute value of a number
absolute <- function(x) {
  if(x < 0) {
    result <- -x
  } else {
    result <- x
  }
  return(result)
}

absolute(2)
absolute(-3)
absolute(0)

# Example: using "else if" to add another condition
sign <- function(x) {
  if (x < 0) {
    return("negative")
  } else if (x == 0) {
    return("zero")
  } else {
    return("positive")
  }
}

sign(-2)
sign(1)
sign(0)


