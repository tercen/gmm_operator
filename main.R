library(tercen)
library(dplyr)
library(mclust)

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
