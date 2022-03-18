package e2e_test

import (
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesComplete(t *testing.T) {
	tmpDir := test_structure.CopyTerraformFolderToTemp(t, "../../", "test/e2e")
	option := terraform.Options{}
	option.TerraformDir = tmpDir
	defer terraform.Destroy(t, &option)
	terraform.InitAndApplyAndIdempotent(t, &option)
}
