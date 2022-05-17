package e2e_test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_helper "github.com/lonegunmanb/terraform-module-test-helper"
)

func TestExamplesComplete(t *testing.T) {
	test_helper.RunE2ETest(t, "../../", "examples/complete", terraform.Options{
		Upgrade: true,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		os.Exit(1)
	})
}
