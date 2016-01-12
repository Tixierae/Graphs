cores_dec = function(g, weighted){
  # This function performs unweighted or weighted k-core decomposition of a graph of terms.
  # The graph should be undirected and (optionally) edge-weighted
  # The function returns an ordered list of 2-tuples where each term is associated with its core number
  
  # With respect to keyword extraction:
  # - select unweighted k-core when recall is more important than precision (larger main core)
  # - select weighted k-core when precision is more important than recall (smaller but stronger main core)
  # - note that overall (in terms of F1 score), weighted k-core performs better
  
  # initialize list that will contain the core numbers
  cores_g = 1:length(V(g)$name)*0
  names(cores_g) = V(g)$name
  
  if (weighted == TRUE){
    # k-core decomposition for weighted graphs (generalized k-cores)
    # based on Batagelj and Zaversnik's (2002) algorithm #4
    
    # create and heapify list of initial weighted degrees (nodes are alphabetically ordered for consistency with Python)
    V(g)$weight = strength(g, mode="all")
    heap_g = V(g)$weight
    names(heap_g) = V(g)$name
    heap_g=heap_g[order(names(heap_g))]
    heap_g=heapify(heap_g, min=TRUE)$heap
    
    while (length(heap_g)>0) {
      
      top = heap_g[1]
      name_top = names(top)
      # save hop-1 neighborhood of heap top element (vertice of minimum weighted degree)
      neighbors_top = setdiff(names(neighborhood(g, order=1, nodes=name_top)[[1]]), name_top)
      # order neighbors by alphabetical order (for consistency with Python)
      neighbors_top = sort(neighbors_top)
      
      # set core number of heap top element as its value (weighted degree)
      cores_g[name_top] = V(g)$weight[which(V(g)$name==name_top)]
      # delete top vertice from graph
      g = delete_vertices(g, name_top)
      
      gstr = strength(g, mode="all")
      
      if (length(neighbors_top)>0){
        # iterate over neighbors of top element
        for (i in 1:length(neighbors_top)){
          name_n = neighbors_top[i]
          max_n = max(cores_g[name_top], gstr[name_n])
          V(g)$weight[which(V(g)$name==name_n)] = max_n
         
          # update heap
          heap_g = V(g)$weight
          names(heap_g) = V(g)$name
          heap_g=heap_g[order(names(heap_g))]
          heap_g=heapify(heap_g, min=TRUE)$heap

        }
      } else {
        # update heap
        heap_g = V(g)$weight
        names(heap_g) = V(g)$name
        heap_g=heap_g[order(names(heap_g))]
        heap_g=heapify(heap_g, min=TRUE)$heap
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
