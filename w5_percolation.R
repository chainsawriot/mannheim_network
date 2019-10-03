### percolation

er_network1 <- erdos.renyi.game(n = 19, p = 0.001)
components(er_network1)
plot(er_network1)

er_network2 <- erdos.renyi.game(n = 19, p = 0.01)
components(er_network2)
plot(er_network2)


er_network3 <- erdos.renyi.game(n = 19, p = 0.1)
components(er_network3)
plot(er_network3)


require(tidyverse)

### unsmoothed
tibble(p = seq(0.0001, 0.5, by = 0.001), 
     nco = map_int(seq(0.0001, 0.5, by = 0.001), ~ components(erdos.renyi.game(n = 19, p = .))$no)) %>%
    ggplot(aes(x = p, y = nco)) + geom_point()

### smoothed
p <- rep(seq(0.0001, 0.5, by = 0.001), 50)
nco <- map_int(p, ~ components(erdos.renyi.game(n = 19, p = .))$no)

tibble(p = p, nco = nco) %>% group_by(p) %>% summarise(nco = mean(nco)) %>% ggplot(aes(x = p, y = nco)) + geom_point()
