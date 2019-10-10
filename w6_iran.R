require(igraph)
require(tidyverse)

### https://about.twitter.com/en_us/values/elections-integrity.html#data

## iran_bots <- rio::import("iran_201901_1_tweets_csv_hashed_3.csv") %>% as_tibble
## iran_bots %>% filter(tweet_language == "en") %>% filter(retweet_userid != "" & str_detect(userid, "^[0-9]+$")) -> en_bots
## en_bots %>% select(userid, retweet_userid, tweet_text) %>% saveRDS("en_bots.RDS")

en_bots <- readRDS("data/en_bots.RDS")

en_bots %>% select(retweet_userid, userid) %>% group_by(retweet_userid, userid) %>% tally %>% rename(weight = "n") %>% filter(weight >= 5) %>% graph_from_data_frame -> bots_network

set.seed(42)
en_bots_wc <- cluster_walktrap(bots_network)


tibble(userid = names(membership(en_bots_wc)), gp = membership(en_bots_wc)) -> wc_res

membership(en_bots_wc) %>% table

### we are only interested in group 2, 4, 6, 7, 8, 9, 10, 13, 14.

wc_res %>% filter(gp %in% c(2, 4, 6, 7, 8, 9, 10, 13, 14)) -> wc_target

en_bots %>% filter(userid %in% wc_target$userid) %>% 
    select(userid, tweet_text) %>% group_by(userid) %>% 
    summarise(alltext = paste(tweet_text, collapse = " ")) %>% 
    left_join(wc_target) -> user_prof

### What is a user profile?

substr(user_prof$alltext, 1, 1000)


require(quanteda)
require(stm)

tweet_dfm <- dfm(user_prof$alltext, remove_numbers = TRUE, remove_punct = TRUE, 
                 remove_url = TRUE, tolower = TRUE, remove = stopwords("en"), 
                 remove_twitter = TRUE)

tweet_dfm %>% dfm_trim(min_docfreq = 3, docfreq_type = 'count') -> tweet_dfm

docvars(tweet_dfm, "gp") <- as.factor(user_prof$gp)

dfm_stm <- quanteda::convert(tweet_dfm, to = "stm")

##install.packages(c('geometry', 'Rtsne', 'rsvd'))
saveRDS(dfm_stm, "data/dfm_stm.RDS")

### reset.

require(stm)
dfm_stm <- readRDS('data/dfm_stm.RDS')
stm_model <- stm(dfm_stm$documents, dfm_stm$vocab, K = 3, data = dfm_stm$meta, 
                 init.type = "Random", seed = 123456789, prevalence =~ gp)

labelTopics(stm_model)

prep <- estimateEffect(1:3 ~ gp, stm_model, meta = dfm_stm$meta)
summary(prep, topic = 3)
