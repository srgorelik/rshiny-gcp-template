# get shiny server plus tidyverse packages image
FROM rocker/shiny-verse:latest

# system libraries of general use
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    pandoc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev\
    ## clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# install R packages required (change it depending on the packages you need)
RUN R -e "install.packages(c('shiny', 'shinydashboard', 'shinydashboardPlus', 'shinythemes'), repos='http://cran.rstudio.com/')"

# clean up
RUN rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# copy configuration files into the Docker image
COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf

# copy shiny app into the Docker image
COPY app /srv/shiny-server/
RUN chown -R shiny:shiny /srv/shiny-server/
RUN rm /srv/shiny-server/index.html

# make the ShinyApp available by exposing a port
EXPOSE 8080

# copy shiny app execution file into the Docker image
COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN chmod +x /usr/bin/shiny-server.sh

# set user
USER shiny

CMD ["/usr/bin/shiny-server"]
