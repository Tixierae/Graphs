import heapq
import igraph
import copy

__author__ = "antoine.tixier-1@colorado.edu"

def core_dec(g, weighted = True):
    # unweighted or weighted k-core decomposition of a graph
  
    # work on clone of g to preserve g 
    gg = copy.deepcopy(g)    
    
    # initialize dictionary that will contain the core numbers
    cores_g = dict(zip(gg.vs["name"],[0]*len(gg.vs["name"])))
    
    if weighted == True:
        # k-core decomposition for weighted graphs (generalized k-cores)
        # based on Batagelj and Zaversnik's (2002) algorithm #4
    
        # initialize min heap of degrees
        heap_g = zip(gg.vs["weight"],gg.vs["name"])
        heapq.heapify(heap_g)
        
        while len(heap_g)>0:
            
            top = heap_g[0][1]
            # find vertice index of heap top element
            index_top = gg.vs["name"].index(top)
            # save names of its neighbors
            neighbors_top = gg.vs[gg.neighbors(top)]["name"]
            # set core number of heap top element as its weighted degree
            cores_g[top] = gg.vs["weight"][index_top]
            # delete top vertice (weighted degrees are automatically updated)
            gg.delete_vertices(index_top)
            
            if len(neighbors_top)>0:
            # iterate over neighbors of top element
                for i, name_n in enumerate(neighbors_top):
                    index_n = gg.vs["name"].index(name_n)
                    max_n = max(cores_g[top],gg.strength(weights=gg.es["weight"])[index_n])
                    gg.vs[index_n]["weight"] = max_n
                    # update heap
                    heap_g = zip(gg.vs["weight"],gg.vs["name"])
                    heapq.heapify(heap_g)
            else:
                # update heap
                heap_g = zip(gg.vs["weight"],gg.vs["name"])
                heapq.heapify(heap_g)
                
    else:
        # k-core decomposition for unweighted graphs
        # based on Batagelj and Zaversnik's (2002) algorithm #1
    
        # compute vertice degrees and order vertices in increasing order of their degrees
        degrees_g = sorted(zip(gg.vs["name"],gg.strength()), key=operator.itemgetter(1))
        
        for i, degrees_g_temp in enumerate(degrees_g):
            vertice = degrees_g_temp[0]
            cores_g[vertice] =  degrees_g_temp[1]
            neighbors_vertice = gg.vs[gg.neighbors(vertice)]["name"]
            for j, neighbor in enumerate(neighbors_vertice):
                index_neighbor = [temp_tuple[0] for temp_tuple in degrees_g].index(neighbor)
                if degrees_g[index_neighbor][1] > degrees_g[i][1]:
                    degrees_g[index_neighbor] = (neighbor, degrees_g[index_neighbor][1] - 1)
                    # reorder vertices in increasing order of their degrees
                    degrees_g = sorted(degrees_g, key=operator.itemgetter(1))
    
    # sort vertices by decreasing core number
    sorted_cores_g = sorted(cores_g.items(), key=operator.itemgetter(1), reverse=True)
    
    return(sorted_cores_g)
