cores_dec = function(g, weighted){
# library(igraph)
# source("heapify.R")

# unweighted or weighted k-core decomposition of an undirected and (optionally) edge-weighted graph

# initialize list that will contain the core numbers
cores_g = 1:length(V(g)$name)*0
names(cores_g) = V(g)$name

if (weighted == TRUE){
  # k-core decomposition for weighted graphs (generalized k-cores)
  # based on Batagelj and Zaversnik's (2002) algorithm #4
  
  # initialize min heap of degrees
  
  gstr = strength(g, mode="all")
  
  heap_g = gstr
  heap_g  = heapify(heap_g ,min=TRUE)$heap
  
  while (length(heap_g)>0) {
    
    top = names(heap_g)[1]
    # find vertice index of heap top element
    index_top = which(V(g)$name==top)
    # save names of its neighbors
    neighbors_top = V(g)$name[setdiff(as.numeric(as.character(neighborhood(g, order=1, nodes=top)[[1]])),index_top)]
    
    # set core number of heap top element as its weighted degree
    cores_g[top] = gstr[top]
    # delete top vertice from graph
    g = delete_vertices(g, top)
    # update weighted degrees
    gstr = strength(g, mode="all")
    
    if (length(neighbors_top)>0){
      # iterate over neighbors of top element
      for (i in 1:length(neighbors_top)){
        name_n = neighbors_top[i]
        max_n = max(cores_g[top],gstr[name_n])
        gstr[name_n] = max_n
        
        # update heap
        heap_g = gstr
        heap_g  = heapify(heap_g ,min=TRUE)$heap
      }
    } else {
      # update heap
      heap_g = gstr
      heap_g  = heapify(heap_g ,min=TRUE)$heap
    }
    }
    } else {
      # k-core decomposition for unweighted graphs
      # based on Batagelj and Zaversnik's (2002) algorithm #1
      cores_g = graph.coreness(g)
    }

# sort vertices by decreasing core number
cores_g = sort(cores_g, decreasing = TRUE)
output = list(cores = cores_g)
}
