ARG GOLANG_IMAGE_TAG=1.17
ARG GOLANG_IMAGE_ALPINE_TAG=1.17.8-alpine3.15
FROM golang:${GOLANG_IMAGE_TAG} as build
COPY GNUmakefile /src/GNUmakefile
COPY scripts /src/scripts
RUN cd /src && \
    apt update && \
    apt install -y zip  && \
    make tools

FROM golang:${GOLANG_IMAGE_ALPINE_TAG} as runner
ARG TERRAFORM_VERSION=1.1.6
ARG TFLINT_AZURERM_VERSION=0.14.0
ENV TFLINT_PLUGIN_DIR /tflint
COPY --from=build $GOPATH/bin $GOPATH/bin
COPY --from=build /usr/local/bin/tflint /bin/tflint

RUN apk add py3-pip bash zip coreutils curl py3-urllib3 git && \
    apk add -U --no-cache gcc build-base linux-headers ca-certificates python3-dev libffi-dev libressl-dev libxslt-dev && \
    pip3 install --upgrade pip && pip3 install --upgrade setuptools wheel urllib3 && \
    pip3 install checkov && \
    mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
    export ARCH=$(uname -m | sed 's/x86_64/amd64/g') && \
    curl '-#' -fL -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_$ARCH.zip && \
	unzip -q -d /bin/ /tmp/terraform.zip && \
	curl '-#' -fL -o /tmp/tflint-ruleset-azurerm.zip https://github.com/terraform-linters/tflint-ruleset-azurerm/releases/download/v${TFLINT_AZURERM_VERSION}/tflint-ruleset-azurerm_linux_$ARCH.zip && \
	mkdir -p $TFLINT_PLUGIN_DIR/github.com/terraform-linters/tflint-ruleset-azurerm/$TFLINT_AZURERM_VERSION && \
    unzip -q -d $TFLINT_PLUGIN_DIR/github.com/terraform-linters/tflint-ruleset-azurerm/$TFLINT_AZURERM_VERSION /tmp/tflint-ruleset-azurerm.zip && \
	rm -f /tmp/terraform.zip && \
    rm -f /tmp/tflint-ruleset-azurerm.zip && \
    apk del curl zip

