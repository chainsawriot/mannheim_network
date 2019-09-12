require(igraph)
require(rio)

lotr_nodes <- rio::import("./data/ontology.csv")
lotr_edges <- rio::import("./data/networks-id-3books.csv")

lotr_raw <- graph_from_data_frame(d = lotr_edges, vertices = lotr_nodes, directed = TRUE)

V(lotr_raw)$Label

### centrality measures
plot(lotr_raw)

degree(lotr_raw) %>% sort

### If you want to know the name
require(tidyverse)
tibble(name = V(lotr_raw)$Label, type = V(lotr_raw)$type, centrality = degree(lotr_raw)) %>% 
    arrange(desc(centrality))


## how to get rid of places, groups, etc.

table(V(lotr_raw)$type)

V(lotr_raw)$type == "per"
which(V(lotr_raw)$type == "per")

lotr <- delete.vertices(lotr_raw, V(lotr_raw)$type != "per")
plot(lotr)

tibble(name = V(lotr)$Label, type = V(lotr)$type, centrality  = degree(lotr)) %>% 
    arrange(desc(centrality))

## Raw betweenness
tibble(name = V(lotr)$Label, type = V(lotr)$type, centrality  = betweenness(lotr)) %>% 
    arrange(desc(centrality))

## Weighted Betweenness
tibble(name = V(lotr)$Label, type = V(lotr)$type, 
       centrality = betweenness(lotr, weights = E(lotr)$Weight)) %>% 
    arrange(desc(centrality))

## Eigenvector centrality / PageRank
tibble(name = V(lotr)$Label, type = V(lotr)$type, 
       centrality = evcent(lotr)$vector) %>% 
    arrange(desc(centrality))

## Coreness
tibble(name = V(lotr)$Label, type = V(lotr)$type, 
       centrality = coreness(lotr)) %>% 
    arrange(desc(centrality)) %>% print(n = 50)

## Vis is PITA!
### https://igraph.org/r/doc/plot.common.html

plot(lotr)

plot(lotr, vertex.label = V(lotr)$Label)

V(lotr)$subtype

plot(lotr, vertex.label = V(lotr)$Label, 
     vertex.color = ifelse(V(lotr)$subtype == "hobbit", "green", "grey"))

plot(lotr, vertex.label = V(lotr)$Label, 
     vertex.color = ifelse(V(lotr)$subtype == "hobbit", "green", "grey"),
     vertex.size = evcent(lotr)$vector)
     

plot(lotr, vertex.label = V(lotr)$Label, 
     vertex.color = ifelse(V(lotr)$subtype == "hobbit", "green", "grey"),
     vertex.size = evcent(lotr)$vector * 10)     


plot(lotr, vertex.label = V(lotr)$Label, 
     vertex.color = ifelse(V(lotr)$subtype == "hobbit", "green", "grey"),
     vertex.size = evcent(lotr)$vector * 10)

plot(lotr, vertex.label = V(lotr)$Label, 
     vertex.color = ifelse(V(lotr)$subtype == "hobbit", "green", "grey"),
     vertex.size = evcent(lotr)$vector * 10, layout = layout.circle)

plot(lotr, vertex.label = V(lotr)$Label, 
     vertex.color = ifelse(V(lotr)$subtype == "hobbit", "green", "grey"),
     vertex.size = evcent(lotr)$vector * 10, layout = layout.circle)

## enough is enough, export the graph and plot it with Gephi.

write_graph(lotr, "lotr.gml", format = "gml")
