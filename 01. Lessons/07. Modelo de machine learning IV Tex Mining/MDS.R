
# load packages
library(dplyr)
library(wordcloud)
library(tidytext)
library(ggrepel)
library(smacof)
library(ggfortify)
library(ggthemes)
library(quanteda)
library(tm)
library(anacor)
library(stringi)
library(stringr)
library(igraph)
library(dendextend)
library(circlize)
library(SnowballC)
library(FactoMineR)
library(factoextra)
library(qdap)
load("cleaned_reviews.Rdata")

hotel.df <- reviews_df

#part of the drawing algorithm is random. It is always good when coding to be able to replicate what you do. To achieve this, we fix what is called the seed of the random number generator. Please see the difference for different seeds

wordcount_all <- hotel.df %>% unnest_tokens(word,Description) %>% count(word, sort=TRUE)



set.seed(1223)
wordcloud(words = wordcount_all$word, freq = wordcount_all$n, min.freq = 1000,
          max.words=70, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))


set.seed(1234)
wordcloud(words = wordcount_all$word, freq = wordcount_all$n, min.freq = 1000,
          max.words=70, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

# Histogram output of wordcount
wordcount_all %>% 
  mutate(word = reorder(word,n)) %>% 
  top_n(20, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() + 
  labs(x = NULL, y = "Number of occurences") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Word Frequency Histogram")

#Dataframe with happy reviews
wordcount_happy <- hotel.df %>% unnest_tokens(word,Description) %>% filter(Is_Response=="happy") %>%count(word, sort=TRUE)
names(wordcount_happy)[2] <- "n_happy"

wordcount_happy %>% 
  mutate(word = reorder(word,n_happy)) %>% 
  top_n(20, word) %>%
  ggplot(aes(word,n_happy)) +  
  geom_col() + 
  labs(x = NULL, y = "Number of occurences") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Word Frequency Histogram Happy")

#Dataframe with happy reviews
wordcount_unhappy <- hotel.df %>% unnest_tokens(word,Description) %>% filter(Is_Response=="not happy") %>%count(word, sort=TRUE)
names(wordcount_unhappy)[2] <- "n_unhappy"

wordcount_unhappy %>% 
  mutate(word = reorder(word,n_unhappy)) %>% 
  top_n(20, word) %>%
  ggplot(aes(word,n_unhappy)) +  
  geom_col() + 
  labs(x = NULL, y = "Number of occurences") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Word Frequency Histogram Unhappy")

corpus <- corpus(hotel.df, docid_field = "User_ID", text_field = "Description",  metacorpus = NULL, compress = TRUE)




hotel.dfm <- dfm(corpus)
wordfreqs <- colSums(as.matrix(hotel.dfm)) 
wordfreqs <- data.frame(word = names(wordfreqs), n=wordfreqs)

wordfreqs %>%
  mutate(word = reorder(word,n)) %>% 
  top_n(20, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() + 
  labs(x = NULL, y = "Number of occurences") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Word Frequency Histogram ")

corpus <- corpus(hotel.df, docid_field = "User_ID", text_field = "Description",  metacorpus = NULL, compress = TRUE)
hotel.dfm <- dfm(corpus)
docfreqs <- docfreq(hotel.dfm) %>% sort(decreasing = TRUE)
docfreqs <- data.frame(word = names(docfreqs), n_docs=docfreqs)

docfreqs %>%
  mutate(word = reorder(word,n_docs)) %>% 
  top_n(20, word) %>%
  ggplot(aes(word,n_docs)) +  
  geom_col() + 
  labs(x = NULL, y = "Number of occurences") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Document Frequency Histogram ")

tf_idf_table <- merge(docfreqs, wordcount_all)

tf_idf_table$tf_idf <- tf_idf_table$n/tf_idf_table$n_docs

tf_idf_table<-tf_idf_table[order(-tf_idf_table$tf_idf),]
names(wordcount_unhappy)[2] <- "n_unhappy"

tf_idf_table %>%
  mutate(word = reorder(word,tf_idf)) %>% 
  top_n(20, tf_idf) %>%
  ggplot(aes(word,tf_idf)) +  
  geom_col() + 
  labs(x = NULL, y = "tf_idf") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("TF-IDF value ")

both_un_happy <- merge(wordcount_unhappy, wordcount_happy)

both_un_happy$ratio <- both_un_happy$n_happy / both_un_happy$n_unhappy

both_un_happy<-both_un_happy[order(-both_un_happy$ratio),]

both_un_happy %>%
  mutate(word = reorder(word,ratio)) %>% 
  top_n(20, ratio) %>%
  ggplot(aes(word,ratio)) +  
  geom_col() + 
  labs(x = NULL, y = "ratio") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Relatively most frequent words in happy ")

both_un_happy %>%
  mutate(word = reorder(word,-ratio)) %>% 
  top_n(-20, ratio) %>%
  ggplot(aes(word,ratio)) +  
  geom_col() + 
  labs(x = NULL, y = "ratio") + 
  coord_flip() + 
  theme(text = element_text(size = 17)) + 
  ggtitle("Relatively most frequent words in unhappy ")

review_tdm <- hotel.df %>% unnest_tokens(word,Description) %>%
              count(word,Is_Response,sort=TRUE) %>%ungroup()%>%
              cast_tdm(word,Is_Response,n)

#a comparison cloud focuses on the differences in frequencies across the two groups. Words that occur very often in both are not shown as prominently

comparison.cloud(as.matrix(review_tdm), scale=c(3,0.5), 
                 random.order=FALSE, colors = c("indianred3","lightsteelblue3"),
                 max.words=30, rot.per = 0.3)

commonality.cloud(as.matrix(review_tdm), scale=c(3,0.5), 
                  random.order=FALSE, colors=brewer.pal(8, "Dark2"),
                  max.words=30, rot.per = 0.3)

#an alternative way of getting the total 
hotel.dfm <- dfm(corpus) 
counts <- colSums(as.matrix(hotel.dfm)) 
sortedcount <- counts%>% sort(decreasing=TRUE)
sortednames <- names(sortedcount)

nwords<-200
subset_words<-as.matrix(sortedcount[1:nwords])

reviews_corp <- corpus(hotel.df, docid_field = "User_ID", text_field = "Description")

# feature cooccurrence matrix : fcm()
Burt_fcm <- fcm(x = reviews_corp, context = "document", count = "boolean", tri=FALSE)


#Need number of documents with each word on the diagonal
hotel.dfm <- dfm(corpus) # get document frequency matrix

# Does not seem to work due to RAM error
counts <- colSums(as.matrix(hotel.dfm)>0) # count how often frequency is positive
Burt_fcm <- as.matrix(Burt_fcm)
diag(Burt_fcm) <- counts[subset_words[, 1] > 0]


distances <- sim2diss(Burt_fcm, method = "cooccurrence") # Transform similarities to distances.
distances[1:15,1:15]
min(distances) #check whethet minimum distance is positive. Sometimes the counting procedure did something unexpected.
max(distances) #check whethet minimum distance is positive. Sometimes the counting procedure did something unexpected.
MDS_map <- smacofSym(distances) # run the routine that finds the best matching coordinates in a 2D mp given the distances
ggplot(as.data.frame(MDS_map$conf), aes(D1, D2, label = rownames(MDS_map$conf))) +
  geom_text(check_overlap = TRUE) + theme_minimal(base_size = 15) + xlab('') + ylab('') +
  scale_y_continuous(breaks = NULL) + scale_x_continuous(breaks = NULL)
# the conf element in the MDS output contains the coordinatis with as names D1 and D2.


Burt_fcm <- fcm(x = reviews_corp, context = "window", window=2, count = "boolean", tri=FALSE)

Burt_fcm<-Burt_fcm[sortednames[1:nwords],sortednames[1:nwords]]

diag(Burt_fcm) <- counts[sortednames[1:nwords]]
Burt_fcm[1:15,1:15]
distances <- sim2diss(Burt_fcm, method = "cooccurrence") # Transform similarities to distances.
min(distances) #check whethet minimum distance is positive. Sometimes the counting procedure did something unexpected.
max(distances) #check whethet minimum distance is positive. Sometimes the counting procedure did something unexpected.

MDS_map <- smacofSym(distances) # run the routine that finds the best matching coordinates in a 2D mp given the distances
ggplot(as.data.frame(MDS_map$conf), aes(D1, D2, label = rownames(MDS_map$conf))) +
  geom_text(check_overlap = TRUE) + theme_minimal(base_size = 15) + xlab('') + ylab('') +
  scale_y_continuous(breaks = NULL) + scale_x_continuous(breaks = NULL)
# the conf element in the MDS output contains the coordinatis with as names D1 and D2.

Burt_fcm <- fcm(x = reviews_corp, context = "window", window=4, count = "boolean", tri=FALSE)

Burt_fcm<-Burt_fcm[sortednames[1:nwords],sortednames[1:nwords]]

diag(Burt_fcm) <- counts[sortednames[1:nwords]]
Burt_fcm[1:15,1:15]
distances <- sim2diss(Burt_fcm, method = "cooccurrence") # Transform similarities to distances.
min(distances) #check whethet minimum distance is positive. Sometimes the counting procedure did something unexpected.
max(distances) #check whethet minimum distance is positive. Sometimes the counting procedure did something unexpected.
MDS_map <- smacofSym(distances) # run the routine that finds the best matching coordinates in a 2D mp given the distances
ggplot(as.data.frame(MDS_map$conf), aes(D1, D2, label = rownames(MDS_map$conf))) +
  geom_text(check_overlap = TRUE) + theme_minimal(base_size = 15) + xlab('') + ylab('') +
  scale_y_continuous(breaks = NULL) + scale_x_continuous(breaks = NULL)
# the conf element in the MDS output contains the coordinatis with as names D1 and D2.



