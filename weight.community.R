weight.community <-
function(row,membership,weigth.within,weight.between){
# author: Antoine Tixier
# last updated: 3.17.2015

if(as.numeric(membership[which(names(membership)==row[1])])==as.numeric(membership[which(names(membership)==row[2])])){
weight=weigth.within
}else{
weight=weight.between
}
return(weight)
}
