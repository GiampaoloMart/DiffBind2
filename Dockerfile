# Usa l'immagine di base con DiffBind
FROM ghcr.io/giampaolomart/diffbind2:nightly

# Imposta la variabile per evitare richieste interattive
ENV DEBIAN_FRONTEND=noninteractive

# Esegui i comandi apt-get come utente root
USER root

# Scarica e installa libicu66 manualmente
RUN apt-get update && \
    apt-get install -y wget && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/i/icu/libicu66_66.1-2ubuntu2_amd64.deb && \
    dpkg -i libicu66_66.1-2ubuntu2_amd64.deb && \
    rm libicu66_66.1-2ubuntu2_amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Installa il pacchetto stringi tramite R
RUN R -e "install.packages('stringi', dependencies = TRUE)"

# Rimuovi la modalità root
USER rstudio_user
