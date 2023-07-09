setwd("~/Library/Mobile Documents/com~apple~CloudDocs/MASTER/MSc Business Analytics/Semester 3/Social Network Analysis/Assignment 2")

#import libraries
library(igraph)
library(readr)
library(gridExtra)

##########
##Task 1##
##########

#read CSV for every year
auth_2016 <- read.csv("authors_2016.csv")
colnames(auth_2016) <- c('Source', 'Target', 'weight')

auth_2017 <- read.csv("authors_2017.csv")
colnames(auth_2017) <- c('Source', 'Target', 'weight')

auth_2018 <- read.csv("authors_2018.csv")
colnames(auth_2018) <- c('Source', 'Target', 'weight')

auth_2019 <- read.csv("authors_2019.csv")
colnames(auth_2019) <- c('Source', 'Target', 'weight')

auth_2020 <- read.csv("authors_2020.csv")
colnames(auth_2020) <- c('Source', 'Target', 'weight')

#Graphs
g_2016 <- graph_from_data_frame(auth_2016, directed=F)
is.weighted(g_2016)

g_2017 <- graph_from_data_frame(auth_2017, directed=F)
is.weighted(g_2017)

g_2018 <- graph_from_data_frame(auth_2018, directed=F)
is.weighted(g_2018)

g_2019 <- graph_from_data_frame(auth_2019, directed=F)
is.weighted(g_2019)

g_2020 <- graph_from_data_frame(auth_2020, directed=F)
is.weighted(g_2020)


##########
##Task 2##
##########

#Number of vertices
v16 <- vcount(g_2016)
v17 <- vcount(g_2017)
v18 <- vcount(g_2018)
v19 <- vcount(g_2019)
v20 <- vcount(g_2020)


vertices <- data.frame(c(2016:2020),c(v16, v17, v18, v19, v20))
colnames(vertices) <- c('Years', 'Num_of_vertices')
plot(vertices$Years, vertices$Num_of_vertices, xlab = 'Years', ylab = 'Number of Vertices')
lines(vertices$Years, vertices$Num_of_vertices, col = 'royalblue')

#Number of edges
e16 <- ecount(g_2016)
e17 <- ecount(g_2017)
e18 <- ecount(g_2018)
e19 <- ecount(g_2019)
e20 <- ecount(g_2020)


edges <- data.frame(c(2016:2020),c(e16, e17, e18, e19, e20))
colnames(edges) <- c('Years', 'Num_of_edges')

plot(edges$Years, edges$Num_of_edges, xlab = 'Years', ylab = 'Number of Edges')
lines(edges$Years, edges$Num_of_edges, col = 'royalblue')


#Diameter
d16 <- diameter(g_2016)
d17 <- diameter(g_2017)
d18 <- diameter(g_2018)
d19 <- diameter(g_2019)
d20 <- diameter(g_2020)


diam <- data.frame(c(2016:2020), c(d16, d17, d18, d19, d20))
colnames(diam) <- c('Years', 'Diameter')

plot(diam$Years, diam$Diameter, xlab = 'Years', ylab = 'Diameter')
lines(diam$Years, diam$Diameter, col = 'royalblue')


#Average Degree
avg_deg16 <- ecount(g_2016)/vcount(g_2016)
avg_deg17 <- ecount(g_2017)/vcount(g_2017)
avg_deg18 <- ecount(g_2018)/vcount(g_2018)
avg_deg19 <- ecount(g_2019)/vcount(g_2019)
avg_deg20 <- ecount(g_2020)/vcount(g_2020)


avg_deg <- data.frame(c(2016:2020), c(avg_deg16, avg_deg17, avg_deg18, avg_deg19, avg_deg20))
colnames(avg_deg) <- c('Years', 'Average_Degree')

plot(avg_deg$Years, avg_deg$Average_Degree, xlab = 'Years', ylab = 'Average Degree')
lines(avg_deg$Years, avg_deg$Average_Degree, col = 'royalblue')


##########
##Task 3##
##########

#Top 10 degree
top10_deg_2016 <- as.data.frame(head(sort(degree(g_2016), decreasing = T), 10))
colnames(top10_deg_2016) <- c('Degree')
top10_deg_2016
pdf("top10_deg_2016.pdf", height=11, width=8.5)
grid.table(top10_deg_2016)
dev.off()

top10_deg_2017 <- as.data.frame(head(sort(degree(g_2017), decreasing = T), 10))
colnames(top10_deg_2017) <- c('Degree')
top10_deg_2017
pdf("top10_deg_2017.pdf", height=11, width=8.5)
grid.table(top10_deg_2017)
dev.off()

top10_deg_2018 <- as.data.frame(head(sort(degree(g_2018), decreasing = T), 10))
colnames(top10_deg_2018) <- c('Degree')
top10_deg_2018
pdf("top10_deg_2018.pdf", height=11, width=8.5)
grid.table(top10_deg_2018)
dev.off()

top10_deg_2019 <- as.data.frame(head(sort(degree(g_2019), decreasing = T), 10))
colnames(top10_deg_2019) <- c('Degree')
top10_deg_2019
pdf("top10_deg_2019.pdf", height=11, width=8.5)
grid.table(top10_deg_2019)
dev.off()

top10_deg_2020 <- as.data.frame(head(sort(degree(g_2020), decreasing = T), 10))
colnames(top10_deg_2020) <- c('Degree')
top10_deg_2020
pdf("top10_deg_2020.pdf", height=11, width=8.5)
grid.table(top10_deg_2020)
dev.off()


#Top 10 PageRank
top10_page_rank_2016 <- as.data.frame(round(head(sort(page_rank(g_2016)$vector, decreasing = T), 10),4))
colnames(top10_page_rank_2016) <- c('PageRank')
top10_page_rank_2016
pdf("top10_page_rank_2016.pdf", height=11, width=8.5)
grid.table(top10_page_rank_2016)
dev.off()

top10_page_rank_2017 <- as.data.frame(round(head(sort(page_rank(g_2017)$vector, decreasing = T), 10),4))
colnames(top10_page_rank_2017) <- c('PageRank')
top10_page_rank_2017
pdf("top10_page_rank_2017.pdf", height=11, width=8.5)
grid.table(top10_page_rank_2017)
dev.off()

top10_page_rank_2018 <- as.data.frame(round(head(sort(page_rank(g_2018)$vector, decreasing = T), 10),4))
colnames(top10_page_rank_2018) <- c('PageRank')
top10_page_rank_2018
pdf("top10_page_rank_2018.pdf", height=11, width=8.5)
grid.table(top10_page_rank_2018)
dev.off()

top10_page_rank_2019 <- as.data.frame(round(head(sort(page_rank(g_2019)$vector, decreasing = T), 10),4))
colnames(top10_page_rank_2019) <- c('PageRank')
top10_page_rank_2019
pdf("top10_page_rank_2019.pdf", height=11, width=8.5)
grid.table(top10_page_rank_2019)
dev.off()


top10_page_rank_2020 <- as.data.frame(round(head(sort(page_rank(g_2020)$vector, decreasing = T), 10),4))
colnames(top10_page_rank_2020) <- c('PageRank')
top10_page_rank_2020
pdf("top10_page_rank_2020.pdf", height=11, width=8.5)
grid.table(top10_page_rank_2020)
dev.off()


##########
##Task 4##
##########

#Method 1: Fast Greedy Clustering

#This function tries to find dense subgraph, also called communities in graphs via directly optimizing a modularity score.
cluster_fast_greedy(g_2016)
cluster_fast_greedy(g_2017)
cluster_fast_greedy(g_2018)
cluster_fast_greedy(g_2019)
cluster_fast_greedy(g_2020)


#Method 2: Infomap Clustering

#Find community structure that minimizes the expected description length of a random walker trajectory
cluster_infomap(g_2016, v.weights = NULL)
cluster_infomap(g_2017, v.weights = NULL)
cluster_infomap(g_2018, v.weights = NULL)
cluster_infomap(g_2019, v.weights = NULL)
cluster_infomap(g_2020, v.weights = NULL)

#Method 3: Louvain Clustering

#This function implements the multi-level modularity optimization algorithm for finding community structure. 
#It is based on the modularity measure and a hierarchical approach.

cluster_louvain(g_2016)
cluster_louvain(g_2017)
cluster_louvain(g_2018)
cluster_louvain(g_2019)
cluster_louvain(g_2020)

#Random Author

#Check which authors are existing in all 5 graphs.
intersection_of_authors <- Reduce(intersect, list(vertex_attr(g_2016)[[1]], vertex_attr(g_2017)[[1]], 
                       vertex_attr(g_2018)[[1]], vertex_attr(g_2019)[[1]],
                       vertex_attr(g_2020)[[1]]))

intersection_of_authors

#Choose an auhtor at random 
set.seed(1)
auth <- sample(intersection_of_authors, 1)
auth

#Find the communities that the random author belongs to from 2016-2020
df16 <- as.data.frame(groups(cluster_louvain(g_2016)))
colnames(df16) <- c('Communities')
df16[grep(auth, df16$Communities), ]

df17 <- as.data.frame(groups(cluster_louvain(g_2017)))
colnames(df17) <- c('Communities')
df17[grep(auth, df17$Communities), ]

df18 <- as.data.frame(groups(cluster_louvain(g_2018)))
colnames(df18) <- c('Communities')
df18[grep(auth, df18$Communities), ]

df19 <- as.data.frame(groups(cluster_louvain(g_2019)))
colnames(df19) <- c('Communities')
df19[grep(auth, df19$Communities), ]

df20 <- as.data.frame(groups(cluster_louvain(g_2020)))
colnames(df20) <- c('Communities')
df20[grep(auth, df20$Communities), ]


#Visualizations
dev.off()

#2016
fc_2016 <- cluster_louvain(g_2016)
V(g_2016)$color <- factor(membership(fc_2016))
is_crossing_2016 <- crossing(g_2016,communities = fc_2016)
E(g_2016)$lty <- ifelse(is_crossing_2016, "solid", "dotted")
community_size_2016 <- sizes(fc_2016)
in_mid_community_2016 <- unlist(fc_2016[community_size_2016 > 50 & community_size_2016 < 90])
retweet_subgraph_2016 <- induced.subgraph(g_2016, in_mid_community_2016)

plot(retweet_subgraph_2016, vertex.label = NA,
     edge.arrow.width = 0.8, edge.arrow.size = 0.2,
     coords = layout_with_fr(retweet_subgraph_2016),
     margin = 0, vertex.size = 3)

#2017
fc_2017<- cluster_louvain(g_2017)
V(g_2017)$color <- factor(membership(fc_2017))
is_crossing_2017 <- crossing(g_2017,communities = fc_2017)
E(g_2017)$lty <- ifelse(is_crossing_2017, "solid", "dotted")
community_size_2017 <- sizes(fc_2017)
in_mid_community_2017 <- unlist(fc_2017[community_size_2017 > 50 & community_size_2017 < 90])
retweet_subgraph_2017 <- induced.subgraph(g_2017, in_mid_community_2017)

plot(retweet_subgraph_2017, vertex.label = NA,
     edge.arrow.width = 0.8, edge.arrow.size = 0.2,
     coords = layout_with_fr(retweet_subgraph_2017),
     margin = 0, vertex.size = 3)

#2018
fc_2018 <- cluster_louvain(g_2018)
V(g_2018)$color <- factor(membership(fc_2018))
is_crossing_2018 <- crossing(g_2018,communities = fc_2018)
E(g_2018)$lty <- ifelse(is_crossing_2018, "solid", "dotted")
community_size_2018 <- sizes(fc_2018)
in_mid_community_2018 <- unlist(fc_2018[community_size_2018 > 50 & community_size_2018 < 90])
retweet_subgraph_2018 <- induced.subgraph(g_2018, in_mid_community_2018)

plot(retweet_subgraph_2018, vertex.label = NA,
     edge.arrow.width = 0.8, edge.arrow.size = 0.2,
     coords = layout_with_fr(retweet_subgraph_2018),
     margin = 0, vertex.size = 3)

#2019
fc_2019<- cluster_louvain(g_2019)
V(g_2019)$color <- factor(membership(fc_2019))
is_crossing_2019 <- crossing(g_2019,communities = fc_2019)
E(g_2019)$lty <- ifelse(is_crossing_2019, "solid", "dotted")
community_size_2019 <- sizes(fc_2019)
in_mid_community_2019 <- unlist(fc_2019[community_size_2019 > 50 & community_size_2019 < 90])
retweet_subgraph_2019 <- induced.subgraph(g_2019, in_mid_community_2019)

plot(retweet_subgraph_2019, vertex.label = NA,
     edge.arrow.width = 0.8, edge.arrow.size = 0.2,
     coords = layout_with_fr(retweet_subgraph_2019),
     margin = 0, vertex.size = 3)

#2020
fc_2020<- cluster_louvain(g_2020)
V(g_2020)$color <- factor(membership(fc_2020))
is_crossing_2020 <- crossing(g_2020,communities = fc_2020)
E(g_2020)$lty <- ifelse(is_crossing_2020, "solid", "dotted")
community_size_2020 <- sizes(fc_2020)
in_mid_community_2020 <- unlist(fc_2020[community_size_2020 > 50 & community_size_2020 < 90])
retweet_subgraph_2020 <- induced.subgraph(g_2020, in_mid_community_2020)

plot(retweet_subgraph_2020, vertex.label = NA,
     edge.arrow.width = 0.8, edge.arrow.size = 0.2,
     coords = layout_with_fr(retweet_subgraph_2020),
     margin = 0, vertex.size = 3)
