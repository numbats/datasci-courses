

# Data Science Degrees

<!-- badges: start -->
![](https://img.shields.io/badge/ETC5543-PROJECT-green?style=for-the-badge)
<!-- badges: end -->

The aim of this project is to characterise what the so-called "data science" degrees are by collecting data on units associated with data science degrees. In particular, what are the core competencies of students graduating these data science degrees?

The data collection will focus (at least initially) on Australian universities and collect data on unit descriptions, learning objectives and how much of the teaching component appear to be on statistics, mathematics, computer science or other disciplines. 

### File Descriptions

Web scraping scripts for university data collection could be found from the `web_scraping folder`, collected data files are saved in `data folder`.

`text_analysis.qmd` and `text_analysis_outcomes.qmd` are the original version of text analysis, more detailed text analysis, tests and attempts on university data and employer data could be found in `analysis_summary` and `employer folder` respectively. Original data for employers job listing is also available in the `employer folder`.

`_targets folder`, `_targets.R` and `R folder` contains all codes and functions to build the LDA models through text2vec package. Note that the models take few hours to fit, and the output files for fitted models are too large to be pushed to the repo. Although the actual models and associated files are not available, they could be reproduced by running the codes in `_targets.R`.

Codes and required data to reproduce the presentation slides are available in the `presentation folder`.

**Full report describing this project and the analysis can be found at** https://github.com/numbats/ds-report