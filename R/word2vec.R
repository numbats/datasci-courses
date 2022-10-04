


model_glove <- function(vocab, tcm, niter = 25) {
  set.seed(2022)
  model <- GloVe$new(rank = 4, # desired dimension for the latent vectors
                     x_max = 10 # maximum number of co-occurrences to use in the weighting function
                     )
                  
  model$fit_transform(tcm, n_iter = niter)
  model
  #model$get_word_vectors()
}

#' Find close words based on 
#' 
#' @param w A string describing a word. 
#' @param d Distance matrix for words
#' @param n The number of close words
find_close_words <- function(w, d, n) {
  words <- rownames(d)
  i <- which(words == paste(tolower(SnowballC::wordStem(w)), collapse = "_"))
  if (length(i) > 0) {
    res <- sort(d[i, ])[2:(n + 1)]
    data.frame(word = names(res), distance = unname(res))
  }
  else {
    NA
  }
}
