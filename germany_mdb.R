require(rtweet)
require(tidyverse)

##mdb <- lists_members(slug = "mdb-liste", owner_user = "handelsblatt")
##saveRDS(mdb, "mdb.RDS")
## friends <- get_friends(mdb$user_id, retryonratelimit = TRUE)
## saveRDS(friends, "mdb_friends.RDS")

mdb <- readRDS('mdb.RDS') %>% select(user_id, name, screen_name, description, followers_count, friends_count)
mdb_friends <- readRDS("mdb_friends.RDS")
mdb_friends %>% filter(user_id %in% mdb$user_id) %>% rename(ego = 'user', friends = 'user_id') -> mdb_edges

require(igraph)
mdb_graph <- graph_from_data_frame(d = mdb_edges, vertices = mdb)

