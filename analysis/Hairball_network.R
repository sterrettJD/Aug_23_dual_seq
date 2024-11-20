library(ggraph)
library(ggplot2)

generate.network <- function(n, p) {
    # Generate matrix values, sampling 0 or 1 with given probabilities
    matvals <- sample(c(0, 1), 
                      n * (n - 1)/2, 
                      replace=TRUE, 
                      prob=c(1 - p,
                               p))
    
    # From the values above, generate a symmetric matrix
    networkmat <- matrix(rep(0, n * n), 
                         ncol=n)
    mv <- 1
    for (i in 1:n) {
        for (j in 1:n) {
            if (i > j) {
                networkmat[i, j] <- matvals[mv]
                networkmat[j, i] <- matvals[mv]
                mv <- mv + 1
            }
        }
    }
    return(networkmat)
}
N <- 1000
network <- generate.network(N, 0.01)
i.net <- igraph::graph_from_adjacency_matrix(network)
igraph::V(i.net)$color <- sample(x=c("Host", "Microbial"), size=N, replace=T)
ggraph(i.net) +
    geom_edge_link(alpha=0.01) +   # add edges to the plot
    geom_node_point(aes(color=color), size=1.5) +
    scale_color_manual(labels=c("Host", "Microbial"),
                       values=c("blue3", "red3")) +
    theme_void()
