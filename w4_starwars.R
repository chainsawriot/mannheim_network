### finding structural bridges

require(igraph)

sw_edges <- rio::import("./data/star-wars-network-edges.csv")



plot(graph_from_data_frame(d = sw_edges))

starwars_graph <- graph_from_data_frame(d = sw_edges, directed = FALSE)

eb <- edge_betweenness(starwars_graph, weights = E(starwars_graph)$weight)
which.max(eb)

E(starwars_graph)[7]
betweenness(starwars_graph, weights = E(starwars_graph)$weight)

neighborhood(starwars_graph)

starwars_graph[]
constraint(starwars_graph)
