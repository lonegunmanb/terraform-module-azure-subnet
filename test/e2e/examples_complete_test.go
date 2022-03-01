package e2e_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	test_helper "github.com/lonegunmanb/terraform-module-test-helper"
	"github.com/stretchr/testify/assert"
)

func TestExamplesComplete(t *testing.T) {
	output := test_helper.RunE2ETest(t, "../../", "examples/complete", terraform.Options{
		Upgrade: true,
	})

	privateSubnetId, ok := output["private_subnet_id"].(string)
	assert.True(t, ok)
	assert.NotEqual(t, "", privateSubnetId)
}

func TestExamplesComplete2(t *testing.T) {
	output := RunE2ETest(t, "../../", "examples/complete2", terraform.Options{
		Upgrade: true,
	})

	privateSubnetId, ok := output["private_subnet_id"].(string)
	assert.True(t, ok)
	assert.NotEqual(t, "", privateSubnetId)
}

type TerraformOutput = map[string]interface{}

func RunE2ETest(t *testing.T, rootFolder, moduleFolderRelativeToRoot string, option terraform.Options) TerraformOutput {
	terraformDir := test_structure.CopyTerraformFolderToTemp(t, rootFolder, moduleFolderRelativeToRoot)
	option.TerraformDir = terraformDir
	defer terraform.Destroy(t, &option)
	terraform.InitAndApplyAndIdempotent(t, &option)
	return terraform.OutputAll(t, &option)
}
