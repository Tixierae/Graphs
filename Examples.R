# examples for consensus.final()

data=cbind(c(1,1,2,1,1,3),c(1,1,2,1,1,1),c(2,2,1,2,1,2))
colnames(data)=paste("item",1:3)
rownames(data)=paste("method",1:6)
data
consensus.final(data)$group

data=cbind(c(1,1,1,1,1,3),c(1,1,1,1,1,1),c(1,1,1,2,1,2)) 
colnames(data)=paste("item",1:3) 
rownames(data)=paste("method",1:6)
data
consensus.final(data)$group

data=cbind(c(1,3,2,1),c(2,2,3,3),c(3,1,1,2))
colnames(data)=paste("item",1:3)
rownames(data)=paste("method",1:4)
data
consensus.final(data)$group
