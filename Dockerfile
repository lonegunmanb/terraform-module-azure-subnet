ARG GOLANG_IMAGE_TAG=1.17
FROM golang:${GOLANG_IMAGE_TAG}
ARG TERRAFORM_VERSION=1.1.0
ARG CONSUL_TEMPLATE_VERSION=0.27.2
ARG TFLINT_AZURERM_VERSION=0.14.0
WORKDIR /src
COPY GNUmakefile /src/GNUmakefile
COPY scripts /src/scripts

RUN apt update && \
    apt install -y zip && \
    make tools && \
    export ARCH=$(uname -m | sed 's/x86_64/amd64/g') && \
    curl '-#' -fL -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_$ARCH.zip && \
	unzip -q -d /bin/ /tmp/terraform.zip && \
	curl '-#' -fL -o /tmp/consul-template.zip https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_$ARCH.zip && \
	unzip -q -d /bin/ /tmp/consul-template.zip && \
	curl '-#' -fL -o /tmp/tflint-ruleset-azurerm.zip https://github.com/terraform-linters/tflint-ruleset-azurerm/releases/download/v${TFLINT_AZURERM_VERSION}/tflint-ruleset-azurerm_linux_$ARCH.zip && \
	mkdir -p ~/.tflint.d/plugins/github.com/terraform-linters/tflint-ruleset-azurerm/$TFLINT_AZURERM_VERSION && \
	unzip -q -d ~/.tflint.d/plugins/github.com/terraform-linters/tflint-ruleset-azurerm/$TFLINT_AZURERM_VERSION /tmp/tflint-ruleset-azurerm.zip && \
	rm -f /tmp/terraform.zip && \
	rm -f /tmp/consul-template.zip

