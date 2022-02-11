Windows:
```shell
docker run --rm -w /src/test/e2e -v ${pwd}/../../:/src -e TERRAFORM_AZURERM_VERSION -e ARM_SUBSCRIPTION_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET -e ARM_TENANT_ID  tfmodule-testrunner sh -c "./render_override.sh && go mod download -x && go test -timeout 1h -v ./..."
```

Linux && Mac:

```shell
docker run --rm -w /src/test/e2e -v $(pwd)/../../:/src -e TERRAFORM_AZURERM_VERSION -e ARM_SUBSCRIPTION_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET -e ARM_TENANT_ID  tfmodule-testrunner sh -c "./render_override.sh && go mod download -x && go test -timeout 1h -v ./..."
```

To test different plugin version, use env variable `TERRAFORM_AZURERM_VERSION`:

Windows:
```shell
docker run -it -w /src/test/e2e --rm -v ${pwd}/../../:/src -e TERRAFORM_AZURERM_VERSION="= 2.91.0" -e ARM_SUBSCRIPTION_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET -e ARM_TENANT_ID  tfmodule-testrunner sh -c "./render_override.sh && go mod download -x && go test -timeout 1h -v ./..."
```

Linux && Mac:

```shell
docker run -it -w /e2e/test/e2e --rm -v $(pwd)/../../:/e2e -e TERRAFORM_AZURERM_VERSION="= 2.91.0" -e ARM_SUBSCRIPTION_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET -e ARM_TENANT_ID  tfmodule-testrunner sh -c "./render_override.sh && go mod download -x && go test -timeout 1h -v ./..."
```