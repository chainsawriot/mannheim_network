require(rtweet)
require(tidyverse)
f4fusers <- search_users("#fridaysforfuture", n = 30)
saveRDS(f4fusers, "f4fusers.RDS")

f4fusers_tm <- get_timelines(f4fusers$user_id, n = 300)
saveRDS(f4fusers_tm, "f4fusers_tm.RDS")

require(igraph)
head(f4fusers_tm$text, 100)
f4fusers_tm %>% filter(is_retweet) %>% group_by(screen_name, retweet_screen_name) %>%
  tally %>% ungroup %>% graph_from_data_frame() -> f4f_graph

degree(f4f_graph) %>% sort %>% tail

betweenness(f4f_graph) %>% sort %>% tail

### @GiuseppeConteIT
### @POTUS
### @BorisJohnson
### @EmmanuelMacron
### @AbeShinzo
### @JunckerEU
### @JustinTrudeau
### @RegSprecher

g7_heads <- lists_members(slug = '', owner_user = "")

g7_frds <- get_friends(g7_heads$user_id, retryonratelimit = TRUE)
