package upgrade

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"

	test_helper "github.com/lonegunmanb/terraform-module-test-helper"
)

func TestExampleUpgrade(t *testing.T) {
	currentRoot, err := test_helper.GetCurrentModuleRootPath()
	if err != nil {
		t.FailNow()
	}
	test_helper.ModuleUpgradeTest(t, "lonegunmanb", "terraform-module-azure-subnet", "examples/complete", currentRoot, terraform.Options{
		Upgrade:  true,
		VarFiles: []string{fmt.Sprintf("%s/examples/complete/fixtures.us-east.auto.tfvars", currentRoot)},
	}, 0)
}
