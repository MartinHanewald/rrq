FROM rocker/r-ver:3.6.1

RUN apt-get update && apt-get -y install \
        libhiredis-dev \
        libssl-dev

COPY docker/bin /usr/local/bin/
RUN sed  -i'' '/mran.microsoft.com/d' /usr/local/lib/R/etc/Rprofile.site && \
        Rscript -e 'install.packages("docopt")'

RUN install_packages --repo=https://mrc-ide.github.io/drat \
        R6 \
        docopt \
        ids \
        progress \
        redux

COPY . /src
RUN R CMD INSTALL /src && \
        Rscript -e 'rrq:::write_rrq_worker("/usr/local/bin")' && \
        rm -rf /src
