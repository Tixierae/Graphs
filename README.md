## consenus.final()
This function is passed a matrix named *data* where each column is an item and each row is a membership vector corresponding to a partition of the items according to a clustering method. The elements (numbers) composing each row have no meaning other than indicating membership and are recycled from row to row. The function returns the majority vote partition. When no consensus exists for a particular item, the partition given by the first row wins. Within the framework of graph mining, this allows the partition maximizing the modularity function to win if the partitions are ordered by decreasing values of modularity in the matrix.

## weight.community()
This function was created to make sure that nodes are laid out according to their community membership when a graph is plotted (with [igraph](http://igraph.org/r/)). The membership argument is the membership vector from the result of any community detection algorithm, given by `membership(comm)`. The weights arguments are two numbers *weight.within* and *weight.between*, and have to be tweaked for each graph to obtain optimal results (however, 10 and 1 are good starting values). The higher the values of the ratio `weight.within/weight.between`, the more tightly grouped the communities will be.

The user simply has to apply the function over the rows of the matrix of edges of the graph (given by `get.edgelist(g)`) to set the edge weights, and to use a layout algorithm that accepts edge weights such as the **fruchterman.reingold**:

`E(g)$weight=apply(get.edgelist(g),1,weight.community,membership,10,1)
g$layout=layout.fruchterman.reingold(g,weights=E(g)$weight)`

## Examples
This file contains examples for the abovelisted functions.
