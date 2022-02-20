#----
# Desafio N2
#----

#----
# Light-beer purchases
#----

# Another subsample of the Nielson Home Scan database considers light-beer 
# purchases in the US. The data object "lightBeer.RData" is available for 
# download on Canvas.

#----
# Task 1: Data exploration
#----

# Like in the lecture, start exploring the new data set by anserwing the 
# following questions:

# Question 1: What is the size of the data set?

# Question 2: What variables are included? (Note: use all functions that 
# have been described in the lecture.)

# Question 3: Are there implausible/ missing values? (Hint: consider 
# "beer_spend" and "beer_floz" for doing the diagnostic checks.)

# Question 4: How are values distributed over variables? 
#  - Derive mean, sd, min and max for describing "beer_spend" as well 
#    as "beer_floz".
#  - In addition, investigate the frequency distribution (absolute and 
#    relative frequencies) of "beer_brand" and "container_descr" as well 
#    as customer "buyertype" and "age". 
#    (Hint: use the functions table() and prop.table())

#----
# Task 2: Data preparation
#----

# Calculate the average unit price in Euro per Liter. (Hint: One Dollar 
# corresponds to 1.11 Euros and 1 FL OZ corresponds to  29.57353 mL.)

# Again, calculate mean, sd, minimum and maximum of "Unit.price" 

# Append "Unit.price" to the LightBeer data object.
#  - On which position (column number) is "Unit.price" added?

# Group the average "Unit.price" according to the different beer brands.
#  - Which brand is the cheapest and which one is the most expensive?

# Group the average "Unit.price" according to the different beer brands 
# and promotion.

# Again, Group the average "Unit.price" according to the different beer 
# brands and promotion. This time, consider only CANs (from "container_descr").

#----
# Task 3: Tidyverse
#----

# Repeat all the data exploration steps using the "tidyverse" package:

# 1. Calculate the average unit price in Euro per Liter. Derive mean, 
#    sd, min, and max

# 2. Group the average "Unit.price" according to the different beer 
#    brands and promotion:

# 3. Consider only CANs (from the "container_descr" column):

# Next, add the number of observations per variable combination and 
# round the final result to two digits.
# Hint: for base R you can use the print.data.frame()-function. For 
# tidyverse you can use mutate_if() to format all numeric values of 
# the output.

# Display the structure of the LightBeer data object:


# How many levels are in the `container_descr` column?


# Check the levels of the `container_descr`` column:


# Use either the function `revalue()` or `mapvalues()` from the `plyr` package to rename the levels 
# "KEG" & "KEG BALL" into "KEG" and the levels "NON REFILLABLE BOTTLE ALUMINUM" & "NON REFILLABLE BOTTLE PLASTIC" 
# into "NON REFILLABLE BOTTLE". Store the renamed levels in a new vector named `container_new`:


# Override the values in the `container_descr` column with the renamed `container_new` vector:


# Check the levels of the `container_descr` column:


# Repeat the previous steps using replacement operations: 
# Note: therefore you need to load the LightBeer data object again!


# Again, obtain the levels of the `container_descr` column:


# Calculate the purchase frequencies for the renamed levels of the `container_descr` column:


# Calculate the unit price in Euro per Liter (cf. week 2) and group the average "Unit.price" according to the 
# different containers and promotion. This time, set the level "NON REFILLABLE BOTTLE" as the first reference. 


# Order the levels of `container_descr` as follows: "CAN", "NON REFILLABLE BOTTLE", "REFILLABLE BOTTLE" and "KEG".
# Store the ordered levels in a new vector named `container_new`:


# Check the levels of the `container_new` vector:


# Override the values in the `container_descr` column with the renamed `container_new` vector:


# Again, group the average "Unit.price" according to the different containers and promotion. 


#----
# Task 2: R release dates
#----

# Import the data file Rversions.csv into R. The dataset includes the version numbers, relase dates and nicknames of 
# all released R-versions since its first appearance in 1997.

Rversions <- read.csv("Rversions.csv")

# Convert the entries in the "date" column into proper "dates". Store the result in a vector named `dates`:


# Convert the dates into its internal form (i.e. the days passed since January 1st, 1970):


# Obtain the median, minimum, maximum and range of `dates`:


# Calculate the time difference between the last and the first version release in days:


# Calculate the time difference between the last and the first version release in weeks:


# Get the weekdays of the R-version releases:


# On which days of the week are R-versions most often released?


# Use the `lubridate` package and the function `wday()` to obtain the weekdays of R-version releases:


# Set the first day of the week to "Monday":


# Again, obtain a frequency table over the weekdays of R_version releases:


# Calculate the time difference (in seconds) between the first R-version release and all preceding version releases:


# Convert the time differences into weeks:


# Convert the time differences into years:
