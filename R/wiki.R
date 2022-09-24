wiki_url <- "https://en.wikipedia.org"

get_wiki_articles <- function(url) {
  read_html(url) %>% 
    html_elements("a") %>% 
    html_attr("href") %>% 
    str_subset("^/wiki/") %>% 
    str_subset(".+[.]svg$", negate = TRUE) %>% 
    str_subset(":", negate = TRUE) %>% 
    str_subset("#", negate = TRUE) %>% 
    str_subset("Main_Page", negate = TRUE) %>% 
    str_replace("^/wiki/", "") %>% 
    unique()
}

clean_wiki_article <- function(x) {
  print(x)
  contents <- jsonlite::fromJSON(glue("{wiki_url}/w/api.php?action=query&titles=", x, "&prop=extracts&redirects=&format=json"))
  contents$query$pages[[1]]$extract %>% 
    read_html() %>% 
    html_text() %>% 
    str_replace_all("\\n", " ") %>% 
    str_replace_all('\\"', "") 
}

get_clean_combined_wikis <- function(x) {
  map(x, clean_wiki_article) %>% 
    paste(collapse = " ")
}


