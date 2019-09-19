require(rio)
require(igraph)
require(tidyverse)

### Put the google sheet URL here.
mkw_url <- ""

mkw_raw <- rio::import(mkw_url)

mkw_raw[, 1:3]

mkw_nodes <- mkw_raw[, c(2, 1)]
colnames(mkw_nodes) <- c("id", "student_name")


extract_relationship <- function(i, mkw_raw) {
    neig <- str_split(mkw_raw[i,3], ", ?")[[1]]
    tibble(from = as.character(i), to = neig)
}

mkw_edges <- map_dfr(1:23, extract_relationship, mkw_raw = mkw_raw)

mkw_edges %>% filter(to != "") %>% mutate(to = str_trim(to), from = str_trim(from)) -> mkw_edges_clean

mkw_nodes$id <- as.character(mkw_nodes$id)

mkw_graph_raw <- graph_from_data_frame(d = mkw_edges_clean, vertices = mkw_nodes, directed = TRUE)

### remove those who have not answered and remove loops

mkw_graph <- delete.vertices(mkw_graph_raw, V(mkw_graph_raw)$name %in% c("14", "17", "18", "23")) %>% igraph::simplify(remove.multiple = FALSE, remove.loops = TRUE)
