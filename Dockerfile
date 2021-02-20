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

# copy everything 
COPY / /


# Setup Docker entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]