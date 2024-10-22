if(!require("maptree")){install.packages("maptree")} # install the package if not installed
library (maptree) # load the package

set.seed(26) # for reproducibility
data = read.csv("data_aggregated.csv",
                header = TRUE, check.names = FALSE) # read data
data = data[data$Pos == 'FW',] # filter only for FW
cl_data = data.frame(scale(data[,8:120]), check.names = FALSE) # scale data

C = cor(cl_data, method = 'pearson') # correlation matrix
dissimilarity = 1 - C # dissimilarity matrix
distance = as.dist(dissimilarity) # distance matrix
cl = hclust(distance, method = 'complete') # hierarchical cluster analysis

op_k = kgs(cl, distance, maxclus = 20) # search for optimal number of clusters
best_k = as.integer(names(op_k[which(op_k == min(op_k))])) # best number of clusters

k = best_k # number of clusters
cols = rainbow_hcl(k) # colors for clusters
dend = as.dendrogram(cl) # dendrogram
dend = color_branches(dend, k = k) # color branches

plot(dend, main = 'Hierarchical cluster analysis',
     yaxt='n') # plot dendrogram



Clus = data.frame(cutree(cl, k = best_k)) # cut the tree
Clus$var = rownames(Clus) # add variable names

C1 = Clus[Clus$cutree.cl..k...best_k. == 1,] # cluster 1
C2 = Clus[Clus$cutree.cl..k...best_k. == 2,] # cluster 2
C3 = Clus[Clus$cutree.cl..k...best_k. == 3,] # cluster 3
C4 = Clus[Clus$cutree.cl..k...best_k. == 4,] # cluster 4
C5 = Clus[Clus$cutree.cl..k...best_k. == 5,] # cluster 5

rm(C, cl, dissimilarity, best_k, distance, op_k, Clus, cl_data) # remove unnecessary objects
gc() # garbage collection

# Function to find leaders
find_leaders = function(x, Data = data){
  leader = c() # initialize leader
  while(nrow(x) > 1){ # while there are more than 1 variable
    v = data.frame(data[,c(x$var)], check.names = FALSE) # select variables
    C = data.frame(as.matrix(cor(v)), check.names = FALSE) # correlation matrix
    t = names(which.max(rowSums(C))) # find the variable with the highest correlation
    leader = c(leader, t) # add the variable to the leader
    C[,t] = NULL # remove the variable from the correlation matrix
    not_leader = c() # initialize not leader
    for (i in 1:ncol(C)){ # for each variable
      if (C[t,i] >= .7){ # if the correlation is greater than or equal to 0.7
        not_leader = c(not_leader, colnames(C)[i]) # add the variable to not leader
      }
    }
    x = x[x$var != t,] # remove the leader variable from the cluster analysis
    x = x[-which(x$var %in% not_leader),] # remove the non-leader variables from the cluster analysis
  }
  if (nrow(x) == 1){ # if there is only 1 variable left
    leader = c(leader, x$var) # add the variable to the leader
  }
  return(leader) # return the leader
}

find_leaders(C1) # find leaders for cluster 1

