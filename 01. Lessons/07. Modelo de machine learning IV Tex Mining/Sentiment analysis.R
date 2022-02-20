#Execute if needed: clean up what is in memory
rm(list=ls())

#Loading libraries.
library(dplyr)
library(ggplot2)
library(wordcloud)
library(tidytext)
library(syuzhet)
library(SnowballC)
library(qdap)

options(stringsAsFactors = FALSE)

reviews_df <- read.csv("../hotel-reviews.csv") 

# Load "translation" of emoticons
data(emoticon)
head(emoticon)

reviews_df$Description <- as.character(reviews_df$Description)  %>%
  tolower() %>%
  {mgsub(emoticon[,2],emoticon[,1],.)} %>%
  {gsub("\\n", " ", .)} %>%                        # Remove \n (newline)     
  {gsub("[?!]+",".",.)} %>%                        # Remove ? and ! (replace by single .)
  {gsub("[\\[\\*\\]]*"," ",.)} %>%                 # Remove [ and ] * (replace by single space)
  {gsub("(\"| |\\$)-+\\.-+"," number ", .)} %>%    # Find numbers
  {gsub("(-+:)*-+ *am"," timeam", .)} %>%          # Find time AM
  {gsub("(-+:)*-+ *pm"," timepm", .)} %>%          # Find time PM
  {gsub("-+:-+","time", .)} %>%                    # Find general time
  {gsub("( |\\$)--+"," number ", .)} %>%           # Find remaining numbers
  {gsub("-"," ", .)} %>%                           # Remove all -
  {gsub("\"+"," ", .)} %>%                         # Remove all "
  {gsub(";+"," ", .)} %>%                          # Remove excess ;
  {gsub("\\.+","\\. ", .)} %>%                     # Remove excess .
  {gsub(" +"," ", .)} %>%                          # Remove excess spaces
  {gsub("\\. \\.","\\. ", .)}                      # Remove space between periods

print("number of reviews")
nrow(reviews_df)

# Continue with first 500 reviews (for speed during demonstrations)
reviews_df_backup <- reviews_df
reviews_df <- reviews_df[1:500,]

get_sentiment("beautiful", method = "bing", language = "english")
wordStem("beautiful", language = "porter")
get_sentiment( wordStem("beautiful", language = "porter") , 
               method = "bing", language = "english")

polarity("beautiful")
wordStem("beautiful", language = "porter")
polarity( wordStem("beautiful", language = "porter") )

all_words <- reviews_df[,] %>%
  unnest_tokens("Description", output = "word") %>%
  anti_join(stop_words, by = "word") %>%
  count(word, sort = TRUE) %>%
  filter(n>50)

#all_words$sentiment <- get_sentiment(all_words$word, method = "bing", language = "english")
sentiment_scores <- polarity(all_words$word)$all
all_words$sentiment <- sentiment_scores[,"polarity"]

all_words %>%
  #  filter(n > 1500) %>%
  filter(sentiment != 0) %>%
  mutate(n = ifelse(sentiment == -1, -n, n)) %>%
  mutate(word = reorder(word, n)) %>%
  mutate(Sentiment = ifelse(sentiment == 1, "Postive","Negative")) %>%
  ggplot(aes(word, n, fill = Sentiment)) +
  geom_col() +
  coord_flip() +
  labs(y = "Contribution to \"total\" sentiment", x = "Word (min freq = 50)")

library(qdap)
sent = list("The food is good", "The food is very good", "The food is bad", "The food is not bad", "The food is not very good")
for (s in sent)
{
  r <- polarity(s)$all  
  cat(s, "(", sqrt(r$wc)*r$polarity, ")\n")
}

pol <- polarity(reviews_df[,"Description"])$all
reviews_df$polarity <- pol[,"polarity"]
reviews_df$sent_bing  <- get_sentiment(reviews_df$Description, method = "bing")
#reviews_df$sent_syu  <- get_sentiment(reviews_df$Description, method = "syuzhet")
#reviews_df$sent_afinn<- get_sentiment(reviews_df$Description, method = "afinn")
#reviews_df$sent_nrc  <- get_sentiment(reviews_df$Description, method = "nrc")

head(reviews_df)

pos_reviews      <- reviews_df %>% filter(Is_Response == "happy")
neg_reviews      <- reviews_df %>% filter(Is_Response == "not happy")

for (v in c("sent_bing","polarity"))
{
  cat(v)
  cat(" ", mean(neg_reviews[, v]), " ", mean(pos_reviews[, v]), "\n")
}

# Histograms of sentiment split on Happy/Unhappy on plain counting

ggplot( ,aes(sent_bing)) +
  geom_histogram(aes(fill = "Happy"),   data = pos_reviews, alpha = 0.5) +
  geom_histogram(aes(fill = "Unhappy"), data = neg_reviews, alpha = 0.5) +
  scale_colour_manual("Evaluation", values = c("green", "red"), aesthetics = "fill")

ggplot( ,aes(sent_bing)) +
  geom_density(aes(fill = "Happy"),   data = pos_reviews, alpha = 0.5) +
  geom_density(aes(fill = "Unhappy"), data = neg_reviews, alpha = 0.5) +
  scale_colour_manual("Evaluation", values = c("green", "red"), aesthetics = "fill")

ggplot( ,aes(polarity)) +
  geom_histogram(aes(fill = "Happy"),   data = pos_reviews, alpha = 0.5) +
  geom_histogram(aes(fill = "Unhappy"), data = neg_reviews, alpha = 0.5) +
  scale_colour_manual("Polarity", values = c("green", "red"), aesthetics = "fill")

ggplot( ,aes(polarity)) +
  geom_density(aes(fill = "Happy"),   data = pos_reviews, alpha = 0.5) +
  geom_density(aes(fill = "Unhappy"), data = neg_reviews, alpha = 0.5) +
  scale_colour_manual("Polarity", values = c("green", "red"), aesthetics = "fill")

all_neg_review_words <- reviews_df  %>% filter(reviews_df$polarity<0)

all_neg_review_words <- all_neg_review_words %>%
  unnest_tokens(word,Description) %>%
  anti_join(stop_words, by = "word")

all_neg_review_words%>%
  count(word, sort=TRUE) %>%
  mutate(word = reorder(word,n)) %>%
  top_n(25, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() +
  labs(x = NULL, y = "Number of occurences") +
  coord_flip() +
  theme(text = element_text(size = 17)) +
  ggtitle("Word Frequencies: negatively classified reviews")

# Same for positive sentiment reviews

all_pos_review_words <- reviews_df  %>% filter(reviews_df$polarity>0)

all_pos_review_words <- (all_pos_review_words) %>% unnest_tokens(word,Description) %>% anti_join(stop_words, by = "word")

all_pos_review_words%>%
  count(word, sort=TRUE) %>%
  mutate(word = reorder(word,n)) %>%
  top_n(25, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() +
  labs(x = NULL, y = "Number of occurences") +
  coord_flip() +
  theme(text = element_text(size = 17)) +
  ggtitle("Word Frequencies: positively classified reviews")


## **Sentence-based** sentiment analysis: number of positive sentences - number of negative sentences
#this needs to be done by review as it decomposes into sentences

# Allocate space for new variables
reviews_df <- cbind(reviews_df, sentence_sent_polarity   = 0*cbind(1:nrow(reviews_df)),
                    sentence_sent_syu   = 0*cbind(1:nrow(reviews_df)),
                    sentence_sent_afinn = 0*cbind(1:nrow(reviews_df)),
                    sentence_sent_bing  = 0*cbind(1:nrow(reviews_df)),
                    sentence_sent_nrc   = 0*cbind(1:nrow(reviews_df)))

totalNoSentences = 0
for (j in 1:nrow(reviews_df)) {
  if (j%%1000==0){
    print(100*j/nrow(reviews_df))
  }
  localSentences <- get_sentences(reviews_df[j,]$Description)
  totalNoSentences = totalNoSentences + length(localSentences)
  
  reviews_df[j,]$sentence_sent_polarity <- polarity(localSentences)$all[,"polarity"] %>% sign() %>% sum()
  
  #reviews_df[j,]$sentence_sent_syu <-
  #    get_sentiment(localSentences, method = "syuzhet", language = "english") %>% sign()  %>% sum()
  
  #reviews_df[j,]$sentence_sent_afinn <-
  #  get_sentiment(localSentences, method = "afinn", language = "english") %>% sign()  %>% sum()
  
  reviews_df[j,]$sentence_sent_bing <-
    get_sentiment(localSentences, method = "bing", language = "english") %>% sign()  %>% sum()
  
  #reviews_df[j,]$sentence_sent_nrc <-
  #  get_sentiment(localSentences, method = "nrc", language = "english") %>% sign()  %>% sum()
}

# Get sentence-level sentiment scores

all_sentences <- data.frame(sentence    = rep(0, totalNoSentences),
                            sentiment   = rep(0, totalNoSentences),
                            polarity   = rep(0, totalNoSentences),
                            User_ID     = rep(reviews_df[1,"User_ID"],     totalNoSentences),
                            Is_Response = rep(reviews_df[1,"Is_Response"], totalNoSentences), stringsAsFactors = FALSE)

sentenceIndex = 1
for (j in 1:nrow(reviews_df)) {
  if (j%%2000==0){
    print(100*j/nrow(reviews_df))
  }
  
  localSentences <- reviews_df[j,]$Description %>% get_sentences()
  
  all_sentences[sentenceIndex : (sentenceIndex+length(localSentences)-1), "sentence"] <- localSentences
  
  all_sentences[sentenceIndex : (sentenceIndex+length(localSentences)-1), "sentiment"] <-
    get_sentiment(localSentences, method = "bing")
  all_sentences[sentenceIndex : (sentenceIndex+length(localSentences)-1), "polarity"] <-
    polarity(localSentences)$all[,"polarity"]
  
  all_sentences[sentenceIndex : (sentenceIndex+length(localSentences)-1), "User_ID"]     <- reviews_df[j,]$User_ID
  all_sentences[sentenceIndex : (sentenceIndex+length(localSentences)-1), "Is_Response"] <- reviews_df[j,]$Is_Response
  
  sentenceIndex = sentenceIndex + length(localSentences)
}

# Remove stop words and look at words that occur often in pos or neg sentences

all_pos_sentences <- all_sentences %>% filter(polarity>0)
all_neg_sentences <- all_sentences %>% filter(polarity<0)

data(stop_words)
all_neg_sentences_words <- all_neg_sentences  %>%
  unnest_tokens(word, sentence) %>%
  anti_join(stop_words, by = "word")

all_neg_sentences_words %>%
  count(word, sort=TRUE) %>%
  mutate(word = reorder(word,n)) %>%
  top_n(25, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() +
  labs(x = NULL, y = "Number of occurences") +
  coord_flip() +
  theme(text = element_text(size = 17)) +
  ggtitle("Word Frequency Histogram (negative sentences)")

all_pos_sentences_words<- all_pos_sentences  %>%
  unnest_tokens(word,sentence) %>%
  anti_join(stop_words, by = "word")

all_pos_sentences_words %>%
  count(word, sort=TRUE) %>%
  mutate(word = reorder(word,n)) %>%
  top_n(25, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() +
  labs(x = NULL, y = "Number of occurences") +
  coord_flip() +
  theme(text = element_text(size = 17)) +
  ggtitle("Word Frequency Histogram (positive sentences)")

# Look at difference of frequency of words in positive vs negative sentences

# Get counts of words in pos (and neg) sentences
all_sentence_words <- full_join(all_pos_sentences_words %>% count(word, sort=TRUE),
                                all_neg_sentences_words %>% count(word, sort=TRUE),
                                by="word")
all_sentence_words[is.na(all_sentence_words$n.x), "n.x"] <- 0
all_sentence_words[is.na(all_sentence_words$n.y), "n.y"] <- 0

# Normalize counts by total number of words in each group and calculate ratio
all_sentence_words$n.x  <- all_sentence_words$n.x/sum(all_sentence_words$n.x)
all_sentence_words$n.y  <- all_sentence_words$n.y/sum(all_sentence_words$n.y)
all_sentence_words$diff <- all_sentence_words$n.x-all_sentence_words$n.y

all_sentence_words%>%
  mutate(word = reorder(word, -diff)) %>%           
  top_n(-20, diff) %>%
  ggplot(aes(word,diff)) +  
  geom_col() +
  labs(x = NULL, y = "Difference in word frequency (pos-neg)") +
  coord_flip() +
  theme(text = element_text(size = 17)) +
  ggtitle("Specific negative words")

all_sentence_words%>%
  mutate(word = reorder(word,diff)) %>%           
  top_n(20, diff) %>%
  ggplot(aes(word,diff)) +  
  geom_col() +
  labs(x = NULL, y = "Difference in word frequency (pos-neg)") +
  coord_flip() +
  theme(text = element_text(size = 17)) +
  ggtitle("Specific positive words")

# Focus op nouns: First create a "POS tagger"

#install.packages("RDRPOSTagger", repos = "http://www.datatailor.be/rcube", type = "source")
library(RDRPOSTagger)

POS_specs <- rdr_model(language = "English", annotation =  "POS")

# Identify all nouns and save them in a file (in data.frame is
#very slow, file is also slow)

#Write header of file
outFile <- file("nouns", open="w")
write("doc_id,token_id,token,pos,Is_Response,sentiment", outFile);
close(outFile)

# Process all sentences
library(data.table)
startIndex = 1
for (j in startIndex:nrow(all_sentences)) {
  if (j%%1000==0){
    print(100*j/nrow(all_sentences))
  }
  to_analyse <-  all_sentences[j,"sentence"]  %>% 
    {gsub("(^ *[,\\.)]+)+","",.)} %>%  # remove leading , or . or ) (also repetitions of this)
    {gsub("(\\(|\\))"," ", .)} # remove ( and )
  to_analyse <-  to_analyse  %>% gsub("  +"," ", .) # remove double spaces
  
  if(nchar(to_analyse)>1) {
    
    sentence_nouns <- tryCatch(
      rdr_pos(POS_specs, to_analyse,  doc_id = all_sentences[j,"User_ID"]),
      error = function(e) print(cat(" POS fails on: ", to_analyse, " sentence: ", j ))
    )
    if (!is.null(sentence_nouns))
    {
      sentence_nouns <- sentence_nouns %>% filter(pos == "NN")
      if (nrow(sentence_nouns)>0)
      {
        sentences_nouns <- data.frame(sentence_nouns, Is_Response = all_sentences[j,"Is_Response"],
                                      sentiment =  all_sentences[j,"sentiment"])
        fwrite(sentences_nouns,file="nouns", append=TRUE)
      }
    }
  }
}

all_sentences_nouns <- read.csv("nouns_svd")
all_sentences_nouns$token <- as.character(all_sentences_nouns$token)

# Plot frequencies of nouns in neg sentences

all_neg_sentences_nouns <- all_sentences_nouns %>%
  filter(all_sentences_nouns$sentiment<0) %>%
  unnest_tokens(word,token) %>%
  anti_join(stop_words, by = "word")

all_neg_sentences_nouns %>%
  count(word, sort=TRUE) %>%
  mutate(word = reorder(word,n)) %>%
  top_n(20, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() +
  labs(x = NULL, y = "Number of occurrences") +
  coord_flip() +
  theme(text = element_text(size = 17)) +
  ggtitle("Nouns Frequency Histogram (negative sentences)")

# Same for positive sentences

all_pos_sentences_nouns <- all_sentences_nouns %>%
  filter(all_sentences_nouns$sentiment>0) %>%
  unnest_tokens(word,token) %>%
  anti_join(stop_words, by = "word")

all_pos_sentences_nouns %>%
  count(word, sort=TRUE) %>%
  mutate(word = reorder(word,n)) %>%
  top_n(20, word) %>%
  ggplot(aes(word,n)) +  
  geom_col() +
  labs(x = NULL, y = "Number of occurences") +
  coord_flip() +
  theme(text = element_text(size = 17)) +
  ggtitle("Nouns Frequency Histogram (positive sentences)")

# Comparison clouds

avgsentiment_nouns <-
  group_by(all_sentences_nouns, token) %>%
  summarize(m = mean(sentiment), count = n()) %>%
  arrange(desc(abs(m)))
avgsentiment_nouns


avgsentiment_nouns$Positive_nouns <-  avgsentiment_nouns$count*(avgsentiment_nouns$m > 0)
avgsentiment_nouns$Negative_nouns <-  avgsentiment_nouns$count*(avgsentiment_nouns$m < -0)

avgsentiment_nouns <- as.data.frame(avgsentiment_nouns)
rownames(avgsentiment_nouns) <-  avgsentiment_nouns$token

comparison.cloud(avgsentiment_nouns[,c("Positive_nouns","Negative_nouns")], scale=c(4, 0.5), max.words=100, title.size=1)


#Emotion classification

get_nrc_sentiment("The room was kind of clean but had a very strong smell of dogs.")


#Score each word on emotion.

tmp <- all_sentences_nouns %>% group_by(token) %>% summarise(cnt=n())  
emotion <- get_nrc_sentiment(tmp$token)
rownames(emotion) <- tmp$token
emotion <- emotion*tmp$cnt
comparison.cloud(emotion[,c("anger","fear","disgust","anticipation",
                            "joy","sadness","surprise","trust")], scale=c(3, 0.3), title.size=1)
