require(igraph)

autobahn <- rio::import("./data/autobahn_edgelist.csv")
autobahn_network <- graph_from_data_frame(autobahn, directed = FALSE)

degree(autobahn_network) %>% hist

autobahn_hist <- hist(degree(autobahn_network))
plot(1:length(autobahn_hist$counts), autobahn_hist$counts+1, xlab = "Degree",ylab = "Frequency", cex.lab = 1.5,main = "Autobahn (log-log scale)", log = "xy")

set.seed(1212121)
er_network <- erdos.renyi.game(n = 50, p = 0.06)
degree(er_network) %>% hist

plot(er_network)

er_hist <- hist(degree(er_network))
plot(1:length(er_hist$counts), er_hist$counts+1, xlab = "Degree",ylab = "Frequency", cex.lab = 1.5,main = "Erdos-Renyi (log-log scale)", log = "xy")


ba_network <- sample_pa(n = 50, directed = FALSE)
degree(ba_network) %>% hist

ba_hist <- hist(degree(ba_network))
plot(1:length(ba_hist$counts),ba_hist$counts+1, xlab = "Degree",ylab = "Frequency", cex.lab = 1.5,main = "Scale-Free (log-log scale)", log = "xy")

## Let's make a event bigger ba_network
big_ba_network <- sample_pa(n = 1000, directed = FALSE, m = 10)
big_ba_hist <- hist(degree(big_ba_network))
plot(1:length(big_ba_hist$counts), big_ba_hist$counts+1, xlab = "Degree",ylab = "Frequency", cex.lab = 1.5,main = "Scale-Free (log-log scale)", log = "xy")
