if(!require("pvclust")){install.packages("pvclust")} # install the package if not installed
library(pvclust) # load the package


set.seed(26) # for reproducibility
data = read.csv("data_aggregated.csv", check.names = FALSE) # read data
data = data[data$Pos == 'FW',] # filter only for forwards
cl_data = data.frame(scale(data[,8:120]), check.names = FALSE) # scale data


# r: sample size of bootstrap resamplings
p = pvclust(cl_data, method.dist= "correlation", 
            method.hclust= "complete", 
            use.cor="pairwise.complete.obs", 
            r=seq(.5,1.5,by=.1), iseed = 26,
            nboot= 10000, parallel=TRUE) # run pvclust

plot(p) # plot pvclust result
pvrect(p, alpha=0.95) # add rectangles to the plot

seplot(p) # plot seplot