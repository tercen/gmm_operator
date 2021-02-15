library(tercen)
library(dplyr)
library(mclust)
library(reshape2)

options("tercen.workflowId" = "2553cb89b6ec3bc593e238e0df047713")
options("tercen.stepId"     = "7f237d16-924d-4913-8ea5-ab44b3bed7fb")

data = (ctx = tercenCtx())  %>% 
  select(.ci, .ri, .y) %>% 
  reshape2::acast(.ci ~ .ri, value.var='.y', fill=NaN, fun.aggregate=mean) 

do.bic <- mclustBIC(data)
model <- Mclust(data, x = do.bic)

data.frame(.ci = seq(from = 0, to = length(model$classification) - 1),
           cluster=paste0("cluster", model$classification)) %>%
  ctx$addNamespace() %>%
  ctx$save()
