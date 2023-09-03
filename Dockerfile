# Verwenden Sie das offizielle rust-alpine-Image als Basis für den Builder
FROM rust:latest as builder

# Setzen Sie das Arbeitsverzeichnis in Docker
WORKDIR /usr/src/lili-gif

# Kopieren Sie die Dateien in das Container-Verzeichnis
COPY . .

# Installieren Sie notwendige Pakete und Kompilieren Sie die Rust-Anwendung
RUN apk add --no-cache build-base && \
    cargo build --release

# Nutzen Sie das Alpine-Image für die Ausführungszeit
FROM alpine:latest

# Erstellen Sie das Verzeichnis für die Anwendung
RUN mkdir -p /app

# Installieren Sie libgcc und libstdc++ (sie könnten für dynamische Bindung benötigt werden)
RUN apk add --no-cache libgcc libstdc++

# Kopieren Sie die kompilierte Anwendung aus dem Builder-Container
COPY --from=builder /usr/src/myrustapp/target/release/myrustapp /app/

# Setzen Sie das Arbeitsverzeichnis
WORKDIR /app

# Starten Sie die Anwendung
CMD ["./lili-gif"]
