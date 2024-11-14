# Usa l'immagine di base con R e DiffBind
FROM ghcr.io/giampaolomart/diffbindv1:nightly

# Imposta la variabile per evitare richieste interattive
ENV DEBIAN_FRONTEND=noninteractive

# Esegui i comandi apt-get come utente root
USER root

# Aggiorna i pacchetti di sistema e installa le librerie di sistema, inclusa libicu-dev
RUN apt-get update && \
    apt-get install -y \
    libicu-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libcairo2-dev \
    libxt-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    libpq-dev \
    libfontconfig1-dev \
    git \
    patch && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# Creazione di un symlink per la libreria `libicui18n.so.66` se necessario
RUN if [ -f /usr/lib/x86_64-linux-gnu/libicui18n.so.70 ]; then \
        ln -s /usr/lib/x86_64-linux-gnu/libicui18n.so.70 /usr/lib/x86_64-linux-gnu/libicui18n.so.66; \
    fi

# Installa BiocManager per gestire i pacchetti Bioconductor
RUN R -e "if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager')"

# Installa i pacchetti CRAN e Bioconductor richiesti
RUN R -e "install.packages(c('stringr', 'ggforce'))" && \
    R -e "BiocManager::install(c('Glimma','sva', 'org.Mm.eg.db', 'org.Hs.eg.db', 'GenomicFeatures', 'txdbmaker', 'TxDb.Hsapiens.UCSC.hg38.knownGene', 'TxDb.Mmusculus.UCSC.mm10.knownGene'))"

# Imposta i permessi per rstudio_user
RUN echo "rstudio_user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Espone la porta 8787 per l'accesso a RStudio Server
EXPOSE 8787

# Esegui RStudio come utente rstudio_user
USER rstudio_user
