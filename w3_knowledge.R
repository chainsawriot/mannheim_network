require(igraph)
require(tidyverse)

music <- read_graph("./data/musical_SUB_genres_net.graphml", format = "graphml")

music_wc <- cluster_walktrap(music)

music_betweenness <- betweenness(music)

music_grouping <- tibble(genre = V(music)$genre, betweenness = music_betweenness, member = membership(music_wc))

music_grouping %>% filter(member == 1) %>% arrange(desc(betweenness)) %>% print(n = 100)

music_grouping %>% filter(member == 2) %>% arrange(desc(betweenness)) %>% print(n = 100)

music_grouping %>% filter(member == 3) %>% arrange(desc(betweenness)) %>% print(n = 100)

music_grouping %>% filter(member == 9) %>% arrange(desc(betweenness)) %>% print(n = 100)
