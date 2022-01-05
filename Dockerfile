ARG GOLANG_IMAGE_TAG=1.17
FROM golang:${GOLANG_IMAGE_TAG}
ARG TERRAFORM_VERSION=1.1.0
WORKDIR /src
COPY GNUmakefile /src/GNUmakefile
COPY scripts /src/scripts

RUN apt update && \
    apt install -y zip && \
    make tools && \
    export ARCH=$(uname -m | sed 's/x86_64/amd64/g') && \
    echo $ARCH && \
    echo $TERRAFORM_VERSION && \
    echo https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_$ARCH.zip && \
    curl '-#' -fL -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_$ARCH.zip && \
	unzip -q -d /tmp/ /tmp/terraform.zip && \
	mv /tmp/terraform /usr/local/bin/terraform && \
	rm -f /tmp/terraform.zip

