#import nessecary libraries
library (readr)
library(igraph)

#import dataset
urlfile = "https://raw.githubusercontent.com/mathbeveridge/asoiaf/master/data/asoiaf-all-edges.csv"
mydata <- read_csv(url(urlfile))
mydata <- as.data.frame(mydata) #transform dataset to dataframe


##########
##Task 1##
##########

#Take only the columns of interest from the original dataset
mydata2 <- mydata[c('Source', 'Target', 'weight')]
head(mydata2)

g <- graph_from_data_frame(mydata2, directed=F)
is.weighted(g)

##########
##Task 2##
##########

#Number of vertices
vcount(g)

#Number of edges
ecount(g)

#Diameter of the graph
diameter(g)

#Number of triangles
length(triangles(g))/3

#print the top-10 characters based on their degree
head(sort(degree(g), decreasing = T), 10)

#print the top-10 characters based on their weighted degree
head(sort(strength(g), decreasing = T), 10)


##########
##Task 3##
##########

#Entire Network
plot(g, vertex.label= NA, vertex.size = 2, main = "Character Network", 
     vertex.color = 'aquamarine3',  vertex.frame.color = "aquamarine4", 
     edge.color='azure3', edge.width=0.6)

edge_density(g, loops = FALSE)


#Subgraph
g2 <- induced_subgraph(g, vids = which(degree(g)>9))
plot(g2, vertex.label= NA, vertex.size = 4, main = "Character Network", 
     vertex.color = 'aquamarine3',  vertex.frame.color = "aquamarine4", 
     edge.color='azure3', edge.width=0.6)

edge_density(g2, loops = FALSE)

##########
##Task 4##
##########

#Closeness Centrality
#print the top-15 characters based on their closeness value
head(sort(closeness(g), decreasing = T), 15)
#Jon Snow is in the 10th place in closeness leaderboard.

#Betweenness Centrality
#print the top-15 characters based on their betweenness value
head(sort(betweenness(g), decreasing = T), 15)
#Here Jon Snow is in the 1st place. Which means that is the most important node in terms of information flow.

##########
##Task 5##
##########

g5 <- page_rank(g)
g5 <- as.data.frame(g5$vector)
g5

plot(g, vertex.label= NA, vertex.size = g5[,1]*320, main = "Character Network based on PageRank", 
     vertex.color = 'aquamarine3',  vertex.frame.color = "aquamarine4", 
     edge.color='azure3', edge.width=0.6)
