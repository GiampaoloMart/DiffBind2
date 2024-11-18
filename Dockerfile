# Usa l'immagine di base con DiffBind
FROM ghcr.io/giampaolomart/diffbind2:nightly

# Imposta la variabile per evitare richieste interattive
ENV DEBIAN_FRONTEND=noninteractive

# Esegui i comandi apt-get come utente root
USER root

# Aggiorna i pacchetti e installa libicu70 (o libicu66) per risolvere il problema della libreria mancante
RUN apt-get update && \
    apt-get install -y libicu70 && \
    ln -sf /usr/lib/x86_64-linux-gnu/libicui18n.so.70 /usr/lib/x86_64-linux-gnu/libicui18n.so.66 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Installa il pacchetto stringi tramite R
RUN R -e "install.packages('stringi', dependencies = TRUE)"

# Rimuovi la modalità root
USER rstudio_user
