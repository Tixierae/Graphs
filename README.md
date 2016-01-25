# R
### consenus.final()
This function is passed a matrix named *data* where each column is an item and each row is a membership vector corresponding to a partition of the items according to a clustering method. The elements (numbers) composing each row have no meaning other than indicating membership and are recycled from row to row. The function returns the majority vote partition. When no consensus exists for a particular item, the partition given by the first row wins. Within the framework of graph mining, this allows the partition maximizing the modularity function to win if the partitions are ordered by decreasing values of modularity in the matrix. See examples [here](http://stackoverflow.com/questions/29301156/get-consensus-of-multiple-partitioning-methods-in-r/29319047#29319047).

### weight.community()
This function ensures that nodes are laid out according to their community membership when a graph is plotted (with [igraph](http://igraph.org/r/)). The *membership* argument is the membership vector from the result of any community detection algorithm, given by `membership(comm)`. The weights arguments are two numbers *weight.within* and *weight.between*, and have to be tweaked for each graph to obtain optimal results (however, 10 and 1 are good starting values). The higher the values of the ratio `weight.within/weight.between`, the more tightly grouped the communities will be.

The user simply has to apply the function over the rows of the matrix of edges of the graph (given by `get.edgelist(g)`) to set the edge weights, and to use a layout algorithm that accepts edge weights such as the **fruchterman.reingold**:

`E(g)$weight=apply(get.edgelist(g),1,weight.community,membership,10,1)
g$layout=layout.fruchterman.reingold(g,weights=E(g)$weight)`

See example [here](http://stackoverflow.com/questions/16390221/how-to-make-grouped-layout-in-igraph/29098951#29098951)

### cores_dec()
This function performs unweighted or weighted k-core decomposition of an undirected and (optionally) edge-weighted graph. The reference is [Batagelj and Zaveršnik (2002)](http://arxiv.org/pdf/cs/0202039.pdf).

### Examples
This file contains examples for the abovelisted functions.

# Python

### cores_dec()
This function performs unweighted or weighted k-core decomposition of an undirected and (optionally) edge-weighted graph. The reference is [Batagelj and Zaveršnik (2002)](http://arxiv.org/pdf/cs/0202039.pdf).
