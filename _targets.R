# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("tidyverse", "rvest", "glue", "text2vec", "SnowballC"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
future::plan(future.callr::callr)

# Load the R scripts with your custom functions:
lapply(list.files("R", full.names = TRUE, recursive = TRUE), source)
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(
  tar_target(wiki_stats, get_wiki_articles("https://en.wikipedia.org/wiki/List_of_statistics_articles")),
  tar_target(wiki_sociology, get_wiki_articles("https://en.wikipedia.org/wiki/Index_of_sociology_articles")),
  tar_target(wiki_computing, get_wiki_articles("https://en.wikipedia.org/wiki/Index_of_computing_articles")),
  tar_target(clean_wiki_stats, map(wiki_stats, clean_wiki_article), format = "rds", repository = "local"),
  tar_target(clean_wiki_sociology, map(wiki_sociology, clean_wiki_article), format = "rds", repository = "local"),
  tar_target(clean_wiki_computing, map(wiki_computing, clean_wiki_article), format = "rds", repository = "local"),
  tar_target(clean_stats, preprocess_text(clean_wiki_stats)),
  
  tar_target(clean_ssc, preprocess_text(c(clean_wiki_stats, clean_wiki_sociology, clean_wiki_computing))),
  # do pre-processing separately (since it doesn't seem to be doing right using `create_vocabularly`?)
  tar_target(itoken_ssc, itoken(clean_ssc, tokenizer = stem_tokenizer),
             cue = tar_cue(mode = "thorough")),
  # some how need cue to be explicitly stated as thorough, otherwise it seems to skip it!
  tar_target(vocab_ssc, create_vocabulary(itoken_ssc, ngram = c(1, 3), stopwords = stopwords::stopwords()),
             cue = tar_cue(mode = "thorough")),
  tar_target(vocab_ssc_prune, prune_vocab(vocab_ssc, n_min = 40),
             cue = tar_cue(mode = "thorough")),
  tar_target(dtm_ssc, create_dtm(itoken_ssc, vocab_vectorizer(vocab_ssc_prune)),
             cue = tar_cue(mode = "thorough")),
  tar_target(tcm_ssc, create_tcm(itoken_ssc, vocab_vectorizer(vocab_ssc_prune), 
                                 skip_grams_window = 5L),
             cue = tar_cue(mode = "thorough")),
  tar_target(word2vec_model_ssc, model_glove(vocab_ssc_prune, tcm_ssc),
             cue = tar_cue(mode = "thorough")),
  tar_target(word2vec_dist_ssc, dist2(t(word2vec_model_ssc$components), method = "cosine"),
             cue = tar_cue(mode = "thorough"), format = "rds", repository = "local"),
  tar_target(word2vec_res, find_close_words("statistics", word2vec_dist_ssc, 10),
             cue = tar_cue(mode = "thorough")),
  tar_target(lda_model03_ssc, model_lda(dtm_ssc, ntopics = 3),
             format = "rds", repository = "local"),
  tar_target(lda_model06_ssc, model_lda(dtm_ssc, ntopics = 6),
             format = "rds", repository = "local"), # the two lda models took about 5.5 hours to fit
  tar_target(lda_model10_ssc, model_lda(dtm_ssc, ntopics = 10),
             format = "rds", repository = "local"),
  tar_target(lda_model15_ssc, model_lda(dtm_ssc, ntopics = 15),
             format = "rds", repository = "local"),
  tar_target(lda_model20_ssc, model_lda(dtm_ssc, ntopics = 20),
             format = "rds", repository = "local"),
  tar_target(clean_comp, preprocess_text(clean_wiki_computing)),
  # do pre-processing separately (since it doesn't seem to be doing right using `create_vocabularly`?)
  tar_target(itoken_comp, itoken(clean_comp, tokenizer = stem_tokenizer),
             cue = tar_cue(mode = "thorough")),
  # some how need cue to be explicitly stated as thorough, otherwise it seems to skip it!
  tar_target(vocab_comp, create_vocabulary(itoken_comp, ngram = c(1, 3), stopwords = stopwords::stopwords()),
             cue = tar_cue(mode = "thorough")),
  tar_target(vocab_comp_prune, prune_vocab(vocab_ssc, n_min = 40),
             cue = tar_cue(mode = "thorough")),
  tar_target(dtm_comp, create_dtm(itoken_comp, vocab_vectorizer(vocab_comp_prune)),
             cue = tar_cue(mode = "thorough")),
  tar_target(tcm_comp, create_tcm(itoken_comp, vocab_vectorizer(vocab_comp_prune), 
                                 skip_grams_window = 5L),
             cue = tar_cue(mode = "thorough")),
  tar_target(word2vec_model_comp, model_glove(vocab_comp_prune, tcm_comp),
             cue = tar_cue(mode = "thorough")),
  tar_target(word2vec_dist_comp, dist2(t(word2vec_model_comp$components), method = "cosine"),
             cue = tar_cue(mode = "thorough"), format = "rds", repository = "local"),
  tar_target(lda_model03_comp, model_lda(dtm_comp, ntopics = 3),
             format = "rds", repository = "local"),
  tar_target(lda_model10_comp, model_lda(dtm_comp, ntopics = 10),
             format = "rds", repository = "local"),
  tar_target(lda_model15_comp, model_lda(dtm_comp, ntopics = 15),
             format = "rds", repository = "local"),
  # topicmodels::get_terms(targets::tar_read(lda_model20_ssc), k = 10)

  
  NULL
)
