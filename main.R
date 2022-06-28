library(tercen)
library(dplyr)
library(mclust)
library(reshape2)

ctx <- tercenCtx()

data <- ctx %>% 
  select(.ci, .ri, .y) %>% 
  reshape2::acast(.ci ~ .ri, value.var='.y', fill=NaN, fun.aggregate=mean) 

n_clusters <- 0
if(!is.null(ctx$op.value("n_clusters"))) n_clusters <- as.numeric(ctx$op.value("n_clusters"))

if(n_clusters == 0) {
  do.bic <- mclustBIC(data)
  model <- Mclust(data, x = do.bic)
} else {
  model <- Mclust(data, G = n_clusters)
}

df_out<-data.frame(.ci = seq(from = 0, to = length(model$classification) - 1),
                   cluster=paste0("cluster", model$classification)) %>%
  ctx$addNamespace() 

df_out %>%  
  ctx$save()