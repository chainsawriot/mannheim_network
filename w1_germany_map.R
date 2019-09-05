require(igraph)
require(rio)

germany <- rio::import("./data/germany_map.csv")
germany_network <- graph_from_data_frame(germany, directed = FALSE)

plot(germany_network)

plot(simplify(germany_network))

germany_network2 <- simplify(germany_network)

germany_network2

V(germany_network2)$name
centralization.degree(germany_network2)

### What is the shortest path from BW to BE?

V(germany_network2)$name[1]
V(germany_network2)$name[2]
shortest_paths(germany_network2, from = 1, to = 14)

autobahn <- rio::import("./data/autobahn_edgelist.csv")
autobahn_network <- graph_from_data_frame(autobahn, directed = FALSE)
degree(autobahn_network) %>% sort(decreasing = TRUE) %>% head
betweenness(autobahn_network) %>% sort(decreasing = TRUE) %>% head(n = 10)
set.seed(42)
wc <- cluster_walktrap(autobahn_network)
membership(wc) %>% table
membership(wc)[membership(wc) == 4]

degree(autobahn_network) %>% hist()

### https://igraph.org/r/doc/plot.common.html
autobahn_network %>% plot(vertex.label = "", vertex.size = betweenness(autobahn_network, normalized = TRUE) * 50)

### https://tinyurl.com/mkw-nachnarn
