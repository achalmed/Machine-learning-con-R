
#----
# Stage 1: Discover
#----

# Question 1: What is the size of the data set?
  
# Check the number of columns and rows / the dimension of the data set:
nrow(BenAndJerry)
ncol(BenAndJerry)
dim(BenAndJerry)


# Question 2: What variables are included?
  
# Check the column names:
names(BenAndJerry)

# Display the first observations:
head(BenAndJerry)

# Display the last observations:
tail(BenAndJerry)

# Display the structure of the data set:
str(BenAndJerry)

# Note: data frames are list vectors! 
length(BenAndJerry)  # data vectors in the list
ncol(BenAndJerry)    # number of columns

# Use $ to exract single columns / data vectors
BenAndJerry$price_paid_deal


# Question 3: Are there inplausible/ missing values?
  
# Check for observations with 0 or negative pruchases:
BenAndJerry$total_spent <= 0
# Calculating the sum of all TRUE entries:
sum(BenAndJerry$total_spent <= 0)  

# Check for observations with missing purchases:
is.na(BenAndJerry$total_spent)
# Again, calculating the sum of all TRUE entries:
sum(is.na(BenAndJerry$total_spent))


# Question 4: How are values distributed over variables?

# Calculate the average price paid for deal and non deal:
mean(BenAndJerry$price_paid_deal)
mean(BenAndJerry$price_paid_non_deal)

# Calculate the spread of the values:
var(BenAndJerry$price_paid_deal)
sqrt(var(BenAndJerry$price_paid_deal))
sd(BenAndJerry$price_paid_deal)

# Do it all at once:
summary(BenAndJerry)


#----
# Stage 2: Prepare
#----

# Calculate the `price_paid_deal` and `price_paid_non_deal` PER UNIT:
Unit.price.deal <- BenAndJerry$price_paid_deal/BenAndJerry$quantity
Unit.price.non.deal <- BenAndJerry$price_paid_non_deal/BenAndJerry$quantity

# Calculate the average unit price paid for deal and non deal:
mean(Unit.price.deal)
mean(Unit.price.non.deal)

BenAndJerry$Unit.price.deal <- Unit.price.deal
BenAndJerry$Unit.price.non.deal <- Unit.price.non.deal

names(BenAndJerry)

# Group the average `Unit.price.deal` according to the different package sizes:
aggregate(Unit.price.deal ~ size1_descr, 
          FUN = mean, data = BenAndJerry)

# Group the mean of `Unit.price.deal` according to package size and amount of fat:
aggregate(Unit.price.deal ~ size1_descr + formula_descr, 
          FUN = mean, data = BenAndJerry)
# Does the same job:
aggregate(Unit.price.deal ~ size1_descr * formula_descr, 
          FUN = mean, data = BenAndJerry)

# Consider only observations with purchases larger than 0:
aggregate(Unit.price.deal ~ size1_descr + formula_descr, 
          FUN = mean, subset = total_spent > 0 , data=BenAndJerry)

# Group average `Unit.price.deal` AND `Unit.price.non.deal` according package size and fat:
aggregate(cbind(Unit.price.deal,Unit.price.non.deal) ~ size1_descr + formula_descr,
          FUN = mean, subset = total_spent > 0 , data = BenAndJerry)
