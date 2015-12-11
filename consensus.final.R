consensus.final <-
function(data){

output=list()
for (i in 1:nrow(data)){
  row=as.numeric(data[i,])
  output.inner=list()
  for (j in 1:length(row)){
    group=character()
    group=c(group,colnames(data)[which(row==row[j])])
    output.inner[[j]]=group
  }
  output.inner=unique(output.inner)
  output[[i]]=output.inner
}

# gives the mode of the vector representing the number of groups found by each method
consensus.n.comm=as.numeric(names(sort(table(unlist(lapply(output,length))),decreasing=TRUE))[1])

# removes the elements of the list that do not correspond to this consensus solution
output=output[lapply(output,length)==consensus.n.comm]

# 1) find intersection 
# 2) use majority vote for elements of each vector that are not part of the intersection

group=list()

for (i in 1:consensus.n.comm){ 
  list.intersection=list()
  for (p in 1:length(output)){
    list.intersection[[p]]=unlist(output[[p]][i])
  }
  
  # candidate group i
  intersection=Reduce(intersect,list.intersection)
  group[[i]]=intersection
  
  # we need to reinforce that group
  for (p in 1:length(list.intersection)){
    vector=setdiff(list.intersection[[p]],intersection)
    if (length(vector)>0){
      for (j in 1:length(vector)){
        counter=vector(length=length(list.intersection))
        for (k in 1:length(list.intersection)){
          counter[k]=vector[j]%in%list.intersection[[k]]
        }
        if(length(which(counter==TRUE))>=ceiling((length(counter)/2)+0.001)){
          group[[i]]=c(group[[i]],vector[j])
        }
      }
    }
  }
}

group=lapply(group,unique)

# variables for which consensus has not been reached
unclassified=setdiff(colnames(data),unlist(group))

if (length(unclassified)>0){
  for (pp  in 1:length(unclassified)){
    temp=matrix(nrow=length(output),ncol=consensus.n.comm)
    for (i in 1:nrow(temp)){
      for (j in 1:ncol(temp)){
        temp[i,j]=unclassified[pp]%in%unlist(output[[i]][j])
      }
    }
    # use the partition of the first method when no majority exists (this allows ordering of partitions by decreasing modularity values for instance)
    index.best=which(temp[1,]==TRUE)
    group[[index.best]]=c(group[[index.best]],unclassified[pp])
  }
}
output=list(group=group,unclassified=unclassified)
}
