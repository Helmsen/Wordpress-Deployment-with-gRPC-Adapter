FROM ubuntu:14.04

MAINTAINER Wilhelm Stephan, Leon Graser, Dominik Bäßler

# Install packages
# ---------------
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    apt-get install -y python-software-properties && \
    apt-get install -y curl && \
    apt-get clean

# Folder structure
# ----------------
RUN mkdir -p /fapra

# Files
# -----
COPY graphQlClient.sh /fapra/graphQlClient.sh
RUN chmod +x /fapra/graphQlClient.sh

# Environment variables
# ----------------------
ENV GRAPHQL_SERVER_HOST=CHANGE
ENV GRAPHQL_SERVER_PORT=CHANGE
ENV FTP_USER=CHANGE
ENV FTP_PW=CHANGE
ENV FTP_HOST=CHANGE
ENV FTP_PORT=CHANGE
ENV FTP_PATH=CHANGE
ENV KEY_PAIR_NAME=CHANGE
ENV KEY_ID=CHANGE
ENV KEY_SECRET=CHANGE
ENV SECURITY_GROUP_NAME

CMD ["/fapra/graphQlClient.sh", "ADAPTER_HOST", "ADAPTER_PORT"]
