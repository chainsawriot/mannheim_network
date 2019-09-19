require(rio)
require(tidyverse)
require(igraph)

congress_edges <- rio::import('./data/congress-twitter-network-edges.csv')
congress_nodes <- rio::import('./data/congress-twitter-network-nodes.csv')

congress_graph <- graph_from_data_frame(d = congress_edges, vertices = congress_nodes, directed = TRUE)

reciprocity(congress_graph)
transitivity(congress_graph)

### cluster_edge_betweenness (slow), cluster_fast_greedy (fast), cluster_walktrap (fast)

congress_wc <-cluster_label_prop(congress_graph)

table(membership(congress_wc), V(congress_graph)$party)

tibble(name = V(congress_graph)$name, party = V(congress_graph)$party, community = membership(congress_wc)) %>% filter(community == 2 & party == "Republican")

tibble(name = V(congress_graph)$name, party = V(congress_graph)$party, betweenness = betweenness(congress_graph)) %>% group_by(party) %>% summarise(mean_bet = mean(betweenness))
tibble(name = V(congress_graph)$name, gender = V(congress_graph)$gender, betweenness = betweenness(congress_graph)) %>% group_by(gender) %>% summarise(mean_bet = mean(betweenness))

tc <- triad_census(congress_graph)
?triad_census
