

rm(list=ls()) # clean up what is in memory

## Libraries we will need 
library(dplyr)
library(ggplot2)
library(tokenizers)
library(tidytext)
library(SnowballC)
library(tm)
library(stringi)
library(ggrepel)

setwd("C:/Users/GLORIA/Desktop/Curso R/Clase 7")

#Coding in R: <- assigns result on the right to variable on the left. Is similar to "=" sign
reviews_df<-read.csv('hotel-reviews.csv')
reviews_df$Description <- as.character(reviews_df$Description)
print("number of reviews")
nrow(reviews_df)

#display first two lrows of data
head(reviews_df, n=2)

#grepl returns true for the rows where 'regexp' is present, false otherwise
# How often is Chicago mentioned?
Chicago <- (grepl('Chicago', reviews_df$Description,ignore.case=T))
sum(Chicago)

# How often is New York mentioned?
NY <- (grepl('New York', reviews_df$Description,ignore.case=T))
sum(NY)

# How often is New York really mentioned?
NY <- (grepl(c('New York|NY'), reviews_df$Description,ignore.case=T))
sum(NY)

#Now we want to see in which reviews the words 'Westin' AND 'New York' appear
Westin_in_NY <- grepl(c('New York|NY'), reviews_df$Description,ignore.case=T) & grepl('Westin', reviews_df$Description,ignore.case=T)
Westin_in_Ch <- grepl(c('Chicago'), reviews_df$Description,ignore.case=T) & grepl('Westin', reviews_df$Description,ignore.case=T)
print("nr of reviews")
sum(Westin_in_Ch)
sum(Westin_in_NY)

#review share of Westin in Chicago and in NY
print("Market shares")
sum(Westin_in_Ch)/sum(Chicago)
sum(Westin_in_NY)/sum(NY)

#cut text into words by splitting on spaces and punctuation
review_words <- reviews_df %>% unnest_tokens(word,Description,to_lower=FALSE) 
print("number of words")
nrow(review_words)

#Count the number of times each word occurs
counts <- review_words %>%count(word, sort=TRUE) # sort = TRUE for sorting in descending order of n. 
# For questions about a function type ?fun in the console. For example ?count
print("number of unique words")
nrow(counts)

# select the most and least mentioned words
counts_high <- head(counts, n = 25) #select the top 25 rows
counts_low <- tail(counts, n = 25) #select the bottom 25 rows

counts_high %>% 
  mutate(word = reorder(word,n)) %>% 
  top_n(20, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() + 
  labs(x = NULL, y = "Number of occurences") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Word Frequency Histogram") # reorder() function is 
#needed to convert character string to factor in R, such that the plot 
#is made on the number of occurences and not on alphabethic order 
#(which is done when the input is a character vector)

data(stop_words)
review_words_nostop <- review_words %>% 
  anti_join(stop_words)
counts <- review_words_nostop %>%
  count(word, sort=TRUE)

print("number of words without stop words")
sum(counts$n)
print("number of unique words")
nrow(counts)

counts %>% 
  mutate(word = reorder(word,n)) %>% 
  top_n(20, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() + 
  labs(x = NULL, y = "Number of occurences") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Word Frequency Histogram")

#cut text into words by splitting on spaces and punctuation
review_words <- reviews_df %>% unnest_tokens(word,Description,to_lower=TRUE) 
print("number of words")
nrow(review_words)

#Count the number of times each word occurs
counts <- review_words %>%count(word, sort=TRUE) # sort = TRUE for sorting in descending order of n. 
# For questions about a function type ?fun in the console. For example ?count
print("number of unique words")
nrow(counts)

review_words_nostop <- review_words %>% 
  anti_join(stop_words)
counts <- review_words_nostop %>%
  count(word, sort=TRUE)

print("number of words without stop words")
sum(counts$n)

counts %>% 
  mutate(word = reorder(word,n)) %>% 
  top_n(20, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() + 
  labs(x = NULL, y = "Number of occurences") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Word Frequency Histogram")


# Creating the full review from the cleaned+stemmedwords
j<-1
for (j in 1:nrow(reviews_df)) {
  stemmed_description<-  anti_join((reviews_df[j,] %>% unnest_tokens(word,Description, drop=FALSE,to_lower=TRUE) ),stop_words)
  
  stemmed_description<-(wordStem(stemmed_description[,"word"], language = "porter"))
  
  reviews_df[j,"Description"]<-paste((stemmed_description),collapse = " ")
  
}

#cut text into words by splitting on spaces and punctuation
review_words <- reviews_df %>% unnest_tokens(word,Description,to_lower=TRUE) 
print("number of words")
nrow(review_words)

#Count the number of times each word occurs
counts <- review_words %>%count(word, sort=TRUE) # sort = TRUE for sorting in descending order of n. 
print("number of unique words after stemming and without stop words")
nrow(counts)

# What are the most frequent words?

counts %>% 
  mutate(word = reorder(word,n)) %>% 
  top_n(20, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() + 
  labs(x = NULL, y = "Number of occurences") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Word Frequency Histogram")

#What are the most infrequent words?

counts %>% 
  mutate(word = reorder(word,n)) %>% 
  top_n(-20, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() + 
  labs(x = NULL, y = "Number of occurences") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Word Frequency Histogram")

#counting the counts
#Count the number of times each count occurs
counted_counts <- counts  %>%count(n, sort=TRUE) # sort = TRUE for sorting in descending order of n. 


counted_counts %>% 
  mutate(n = reorder(n,nn)) %>% 
  top_n(10, n) %>%
  ggplot(aes(n,nn)) +  
  geom_col() + 
  labs(x = NULL, y = "Number of occurences") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("count Frequency Histogram")

head(counted_counts,n=11)

infrequent <- counts %>% filter(n<0.01*nrow(reviews_df))
frequent <- counts[1:2,]
toremove  <- full_join(frequent,infrequent)
print("Number of infrequent words")
nrow(toremove)
print("Share of infrequent words")
nrow(toremove)/nrow(counts)

j<-1 
for (j in 1:nrow(reviews_df)) {
  stemmed_description<-  anti_join((reviews_df[j,] %>% unnest_tokens(word,Description,to_lower=TRUE) ),toremove)
  
  reviews_df[j,"Description"]<-   paste((stemmed_description[,"word"]),collapse = " ")
  
}
save(data,file="cleaned_reviews.Rdata") 
head(data)

counts_happy <- review_words_nostop %>%
  filter(review_words_nostop[,4] == "happy") %>% 
  count(word, sort=TRUE)
counts_happy_high <- head(counts_happy, n = 25)
counts_happy_high %>% 
  mutate(word = reorder(word,n)) %>% 
  ggplot(aes(word,n)) +  
  geom_col() + 
  coord_flip()

# It looks like that the most frequent words in happy reviews are almost 
#the same as the most frequent words overal. The x-axis is interesting because
#we see that the frequency gets lower.

counts_unhappy <- review_words_nostop %>% 
  filter(review_words_nostop[,4]=="not happy") %>%
  count(word, sort=TRUE)
counts_unhappy_high <- head(counts_unhappy, n = 25)
counts_unhappy_high %>% 
  mutate(word = reorder(word,n)) %>% 
  ggplot(aes(word,n)) +
  geom_col() + 
  coord_flip()




