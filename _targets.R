# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("tidyverse", "rvest", "glue"), # packages that your targets need to run
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
  tar_target(clean_wiki_computing, map(wiki_computing, clean_wiki_article), format = "rds", repository = "local")
)
