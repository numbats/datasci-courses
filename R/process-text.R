preprocess_text <- function(x) {
  unlist(x) %>% 
    # lower case all
    tolower() %>% 
    # remove left over from HTML/LaTex?
    str_replace_all("(\\t|displaystyle|mathbf|\\n)", " ") %>% 
    # remove punctuations
    str_replace_all("[.,;]", "") %>% 
    # remove words with numbers only
    str_replace_all(" [0-9]+ ", " ") %>% 
    # remove white space
    str_squish()
}

stem_tokenizer <- function(x) {
  lapply(word_tokenizer(x), SnowballC::wordStem, language = "en")
}


prune_vocab <- function(v, n_min = 40) {
  res <- v %>% 
    filter(term_count >= n_min) %>% 
    # remove terms that have any number in it
    filter(!str_detect(term, "[0-9]")) %>% 
    # remove terms that have one letter or "__" (likely a reminent of latex)
    filter(!str_detect(term, "(__|^.$)"))
    
  print(res)
  
  res
  # filter(!str_detect(term, "(^[0-9]+$|[0-9]+_|_^[0-9]+_|_[0-9]+$)"))
  # you can also use, but missing ability to prune terms
  # prune_vocabulary(v, term_count_min = n_min)
}