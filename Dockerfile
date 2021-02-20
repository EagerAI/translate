# start from the rocker/r-ver:4.0.0 image
FROM rocker/r-ver:4.0.0


# Curl
RUN apt-get update; apt-get install curl
RUN apt-get install libcurl4-openssl-dev

# Git
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

# run scripts
RUN R -e "install.packages(c('RCurl','jsonlite'))"
RUN R -e "install.packages(c('magrittr','glue'))"
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_github('rstudio/reticulate')"
RUN R -e "reticulate::install_miniconda()"
RUN R -e "reticulate::py_install('git+https://github.com/huggingface/transformers.git',pip = TRUE)"
RUN R -e "reticulate::py_install('sentencepiece',pip = TRUE)"

# copy everything 
COPY / /


# Setup Docker entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]