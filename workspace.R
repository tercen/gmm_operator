library(tercen)
library(dplyr)
library(mclust)

options("tercen.workflowId" = "2553cb89b6ec3bc593e238e0df047713")
options("tercen.stepId"     = "7f237d16-924d-4913-8ea5-ab44b3bed7fb")

clust.df <- function(df) {
  X <- df[, c(".x", ".y")]
  do.bic <- mclustBIC(X)
  model <- Mclust(X, x = do.bic)
  out <- data.frame(df, cluster = model$classification)
  return(out)
}

(ctx = tercenCtx()) %>% 
  select(.x, .y, .ci, .ri) %>%
  group_by(.ci, .ri) %>%
  do(clust.df(.)) %>%
  ctx$addNamespace() %>%
  ctx$save()
