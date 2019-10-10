require(rtweet)
require(igraph)
require(tidyverse)

all_tm <- readRDS('data/all_tm.RDS')
all_tm %>% filter(!is.na(retweet_screen_name)) %>% 
    group_by(screen_name, retweet_screen_name) %>%
    tally %>% filter(n > 1) %>% ungroup %>% 
    rename(weight = "n") %>% graph_from_data_frame %>%
    simplify -> all_users_network

set.seed(42)
au_wc <- cluster_walktrap(all_users_network)

tibble(screen_name = V(all_users_network)$name, 
       gp = membership(au_wc)) -> au_gp

au_gp %>% group_by(gp) %>% tally %>% arrange(desc(n))


all_tm %>% left_join(au_gp) %>% 
    filter(gp %in% c(1,4,5,2,31,29)) %>%
    select(text, gp) -> user_prof

require(quanteda)
tweet_dfm <- dfm(user_prof$text, remove_numbers = TRUE, remove_punct = TRUE, 
                 remove_url = TRUE, tolower = TRUE, remove = stopwords("en"), 
                 remove_twitter = TRUE) %>% 
    dfm_trim(min_docfreq = 3, docfreq_type = 'count')


docvars(tweet_dfm, "gp") <- as.factor(user_prof$gp)


dfm_stm <- quanteda::convert(tweet_dfm, to = "stm")

stm_model <- stm(dfm_stm$documents, dfm_stm$vocab, K = 0, data = dfm_stm$meta, 
                 init.type = "Spectral", seed = 123456789, prevalence =~ gp)

labelTopics(stm_model)

prep <- estimateEffect(1:51~gp, stm_model, meta = dfm_stm$meta)
summary(prep)
labelTopics(stm_model, topic = 50)

au_gp %>% filter(gp == 4)

labelTopics(stm_model, topic = 41)

au_gp %>% filter(gp == 5)

labelTopics(stm_model, topic = 22)
au_gp %>% filter(gp == 31) %>% print(n = 100)
