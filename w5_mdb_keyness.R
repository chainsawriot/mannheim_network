require(rtweet)
require(tidyverse)
require(quanteda)

mdb <- readRDS('data/mdb.RDS') %>% select(user_id, name, screen_name, description, followers_count, friends_count)
mdb_friends <- readRDS("data/mdb_friends.RDS")
mdb_friends %>% filter(user_id %in% mdb$user_id) %>% rename(ego = 'user', friends = 'user_id') -> mdb_edges

require(igraph)
mdb_graph <- graph_from_data_frame(d = mdb_edges, vertices = mdb)

set.seed(42)
mdb_wc <- cluster_walktrap(mdb_graph)

tibble(name = V(mdb_graph)$name, gp = membership(mdb_wc))

tibble(name = V(mdb_graph)$name, gp = membership(mdb_wc)) %>% left_join(mdb)

tibble(name = V(mdb_graph)$name, gp = membership(mdb_wc)) %>% left_join(mdb) %>% select(description, gp) -> mdb_info

mdb_dfm <- dfm(mdb_info$description)

textstat_keyness(mdb_dfm, mdb_info$gp == 1) %>% head(n = 10)
textstat_keyness(mdb_dfm, mdb_info$gp == 1) %>% textplot_keyness

mdb_dfm2 <- dfm(mdb_info$description, group = mdb_info$gp)
mdb_dfm2 %>% dfm_trim(min_termfreq = 3, verbose = FALSE) %>%
    textplot_wordcloud(comparison = TRUE)