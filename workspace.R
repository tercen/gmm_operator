library(tercen)
library(dplyr)
library(mclust)
library(reshape2)

options("tercen.workflowId" = "2553cb89b6ec3bc593e238e0df047713")
options("tercen.stepId"     = "7f237d16-924d-4913-8ea5-ab44b3bed7fb")

data = (ctx = tercenCtx())  %>% 
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

data.frame(.ci = seq(from = 0, to = length(model$classification) - 1),
           cluster=paste0("cluster", model$classification)) %>%
  ctx$addNamespace() %>%
  ctx$save()
