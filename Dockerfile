# Usa l'immagine di base con R e DiffBind
FROM ghcr.io/giampaolomart/diffbindv1:nightly

# Imposta la variabile per evitare richieste interattive
ENV DEBIAN_FRONTEND=noninteractive

# Esegui i comandi apt-get come utente root
USER root

# Aggiorna i pacchetti di sistema e installa libicu66
RUN apt-get update && \
    apt-get install -y \
    libicu66 \
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

# Installa BiocManager per gestire i pacchetti Bioconductor
RUN R -e "if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager')"

# Installa i pacchetti CRAN e Bioconductor richiesti
RUN R -e "install.packages(c('stringr', 'ggforce', 'Glimma'))" && \
    R -e "BiocManager::install(c('sva', 'org.Mm.eg.db', 'org.Hs.eg.db', 'GenomicFeatures', 'txdbmaker', 'TxDb.Hsapiens.UCSC.hg38.knownGene', 'TxDb.Mmusculus.UCSC.mm10.knownGene'))"

# Configura un utente per l'accesso a RStudio
RUN useradd -m -s /bin/bash rstudio_user && \
    echo "rstudio_user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Assegna la proprietà della directory all'utente rstudio_user
RUN chown -R rstudio_user:rstudio_user /home/rstudio_user

# Espone la porta 8787 per l'accesso a RStudio Server
EXPOSE 8787

# Esegui RStudio come utente rstudio_user
USER rstudio_user
