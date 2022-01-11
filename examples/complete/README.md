
```powershell
docker run --rm -v ${pwd}/../../:/src -w="/src/examples/complete" -e ARM_CLIENT_ID=$env:ARM_CLIENT_ID -e ARM_CLIENT_SECRET=$env:ARM_CLIENT_SECRET -e ARM_TENANT_ID=$env:ARM_TENANT_ID -e ARM_SUBSCRIPTION_ID=$env:ARM_SUBSCRIPTION_ID tfmodule-testrunner terraform apply -auto-approve
```

```shell
docker run --rm -v $(pwd)/../../:/src -w="/src/examples/complete" -e ARM_CLIENT_ID=$ARM_CLIENT_ID -e ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET -e ARM_TENANT_ID=$ARM_TENANT_ID -e ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID tfmodule-testrunner terraform apply -auto-approve
```