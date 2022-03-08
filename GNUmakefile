TEST?=$$(go list ./... |grep -v 'vendor'|grep -v 'examples')
TESTTIMEOUT=180m

.EXPORT_ALL_VARIABLES:
  TF_SCHEMA_PANIC_ON_ERROR=1

default: build

tools:
	@echo "==> installing required tooling..."
	@sh "$(CURDIR)/scripts/gogetcookie.sh"
	go install github.com/client9/misspell/cmd/misspell@latest
	go install github.com/katbyte/terrafmt@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install mvdan.cc/gofumpt@latest
	go install github.com/bflad/tfproviderlint/cmd/tfproviderlint@latest
	go install github.com/yngveh/sprig-cli@latest
	go install github.com/terraform-docs/terraform-docs@v0.16.0
	go install github.com/hairyhenderson/gomplate/v3/cmd/gomplate@latest
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $$(go env GOPATH || $$GOPATH)/bin v1.41.1
	curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

fmt:
	@echo "==> Fixing source code with gofmt..."
	# This logic should match the search logic in scripts/gofmtcheck.sh
	find . -name '*.go' | grep -v vendor | xargs gofmt -s -w

fumpt:
	@echo "==> Fixing source code with Gofumpt..."
	# This logic should match the search logic in scripts/gofmtcheck.sh
	find . -name '*.go' | grep -v vendor | xargs gofumpt -w

tffmt:
	@echo "==> Formatting terraform code..."
	terraform fmt -recursive

tffmtcheck:
	@sh "$(CURDIR)/scripts/terraform-fmt.sh"

tfvalidatecheck:
	@sh "$(CURDIR)/scripts/terraform-validate.sh"

terrafmtcheck:
	@sh "$(CURDIR)/scripts/terrafmt-check.sh"

# Currently required by tf-deploy compile, duplicated by linters
gofmtcheck:
	@sh "$(CURDIR)/scripts/gofmtcheck.sh"
	@sh "$(CURDIR)/scripts/fumptcheck.sh"

golint:
	./scripts/run-golangci-lint.sh

tflint:
	./scripts/run-tflint.sh

lint: golint tflint

checkovcheck:
	@echo "==> Checking Terraform code with BridgeCrew Checkov"
	checkov --skip-framework dockerfile --quiet -d ./

fmtcheck: tfvalidatecheck tffmtcheck gofmtcheck terrafmtcheck

pr-check: gencheck fmtcheck lint checkovcheck

e2e-test:
	./scripts/run-e2e-test.sh

version-upgrade-test:
	./scripts/version-upgrade-test.sh

terrafmt:
	@echo "==> Fixing test and document terraform blocks code with terrafmt..."
	@find . -name '*.md' -o -name "*.go" | grep -v -e '.github' -e '.terraform' -e 'vendor' | while read f; do terrafmt fmt -f $$f; done

goimports:
	@echo "==> Fixing imports code with goimports..."
	@find . -name '*.go' | grep -v vendor | while read f; do ./scripts/goimport-file.sh "$$f"; done


depscheck:
	@echo "==> Checking source code with go mod tidy..."
	@go mod tidy
	@git diff --exit-code -- go.mod go.sum || \
		(echo; echo "Unexpected difference in go.mod/go.sum files. Run 'go mod tidy' command or revert any go.mod/go.sum changes and commit."; exit 1)
	@echo "==> Checking source code with go mod vendor..."
	@go mod vendor
	@git diff --compact-summary --exit-code -- vendor || \
		(echo; echo "Unexpected difference in vendor/ directory. Run 'go mod vendor' command or revert any go.mod/go.sum/vendor changes and commit."; exit 1)

generate:
	@echo "--> Generating doc"
	@terraform-docs markdown table --output-file README.md --output-mode inject ./

gencheck:
	@echo "==> Generating..."
	@cp README.md README-generated.md
	@terraform-docs markdown table --output-file README-generated.md --output-mode inject ./
	@echo "==> Comparing generated code to committed code..."
	@diff -q README.md README-generated.md || \
    		(echo; echo "Unexpected difference in generated document. Run 'make generate' to update the generated document and commit."; exit 1)

whitespace:
	@echo "==> Fixing source code with whitespace linter..."
	golangci-lint run ./... --no-config --disable-all --enable=whitespace --fix

test: fmtcheck
	@TEST=$(TEST) ./scripts/run-gradually-deprecated.sh
	@TEST=$(TEST) ./scripts/run-test.sh

test-compile:
	@if [ "$(TEST)" = "./..." ]; then \
		echo "ERROR: Set TEST to a specific package. For example,"; \
		echo "  make test-compile TEST=./$(PKG_NAME)"; \
		exit 1; \
	fi
	go test -c $(TEST) $(TESTARGS)

testacc: fmtcheck
	TF_ACC=1 go test $(TEST) -v $(TESTARGS) -timeout $(TESTTIMEOUT) -ldflags="-X=github.com/hashicorp/terraform-provider-azurerm/version.ProviderVersion=acc"

acctests: fmtcheck
	TF_ACC=1 go test -v ./internal/services/$(SERVICE) $(TESTARGS) -timeout $(TESTTIMEOUT) -ldflags="-X=github.com/hashicorp/terraform-provider-azurerm/version.ProviderVersion=acc"

debugacc: fmtcheck
	TF_ACC=1 dlv test $(TEST) --headless --listen=:2345 --api-version=2 -- -test.v $(TESTARGS)

validate-examples:
	./scripts/validate-examples.sh


.PHONY: build test testacc vet fmt fmtcheck errcheck pr-check scaffold-website test-compile website website-test validate-examples
