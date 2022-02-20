#----
# Vectors
#----

# Concatinating elements together with **`c()`**.

c(0.5, 0.6, 0.25)            # double
c(9L, 10L, 11L, 12L, 13L)    # integer
c(9:13)                      # integer sequence
c(TRUE, FALSE, FALSE)        # logical
c(1+0i, 2+4i)                # complex
c("a", "b", "c")             # character

#----
# Vector actions
#----

# Assign the vectors to names:

dbl <- c(0.5, 0.6, 0.25)     
chr <- c("a", "b", "c")      

# Print out the dbl and chr vectors on the console:
dbl
chr
# Check the number of elements in dbl and chr:
length(dbl)
# Check the data type dbl and chr:
typeof(dbl)
# Combine two vectors:
c(dbl,dbl)
c(dbl,chr)

#----
# Vector arithmetic
#----

# Define two new numeric vectors `a` and `b` each having 4 elements:
a <- c(1, 2, 3, 4)
b <- c(10, 20, 30, 40) 

# Multiply each element in a by 5 (scalar multiplication):
a*5
# Multiply the elements in a by the elements in b (vector multiplication):
a*b
# Multiply the elements in a by the elements of some numeric vector v of length 5:
v <- c(1.1, 1.2, 1.3, 1.4, 1.5) 

#----
# Matrices
#----

# Option (1): Combining two vectors columnwise with cbind():
A <- cbind(a, b)  

# Option (2): Combining two vectors rowwise with rbind():
B <- rbind(a, b)  

# Option (3): Creating a matrix from elements of a vector with `matrix()`:
A <- matrix(a, ncol=2, nrow=2)

A <- matrix(a, ncol=2)

B <- matrix(a, ncol=2, byrow=TRUE)

#----
# Matrix actions
#----

# Checking the number of rows:
nrow(A)
# Checking the number of columns:
ncol(A)
# Checking the dimension `[nrow, ncol]`:
dim(A)
# Combine two matrices:
D.wide <- cbind(A,A)
D.long <- rbind(A,A)
D <- cbind(D.wide, D.long)

#----
# Matrix arithmetic
#----

# Matrix addition:
B+B
# Scalar multiplication:
B*2
# Elementwise multiplication:
a=B*B
# Matrix multiplication:
C=B%*%B
#----
# Data frames
#----

dbl <- c(0.5, 0.6, 0.25, 1.2, 0.333)      # double
int <- c(9L, 10L, 11L, 12L, 13L)          # integer
lgl <- c(TRUE, FALSE, FALSE, TRUE, TRUE)  # logical
chr <- c("a", "b", "c", "d", "e")         # character
df <- data.frame(dbl,int,lgl,chr)
df

# Data frame actions

# Checking the number of rows:
nrow(df)

# Checking the number of columns:
ncol(df)

# Checking the dimension `[nrow, ncol]`:
dim(df)        


#----
# Lists
#----

a <- 1L                                   # scalar
dbl <- c(0.5, 0.6, 0.25, 1.2, 0.333)      # numeric vector of length 5
chr <- c("a", "b", "c"        )           # charcter vector of length 3
v <- c(1.1, 1.2, 1.3, 1.4)
mat <- matrix(v, ncol=2)                  # 2 x 2 matrix

l <- list(a, dbl, chr, mat)
l




  