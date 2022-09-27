
model_lda <- function(dtm, ntopics) {
  topicmodels::LDA(dtm, 
                   ntopics,
                   method = "Gibbs", 
                   control = list(nstart = 5, 
                                  seed =  list(88, 86, 25, 36, 79), 
                                  best = TRUE, 
                                  burnin = 4000, 
                                  iter = 2000, 
                                  thin = 500))
}
