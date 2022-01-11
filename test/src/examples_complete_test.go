package test

import (
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	// to use t.Parallel() with multiple tests in the same directory
	// you need to use test_structure.CopyTerraformFolderToTemp
	// but that leaves a copy of the whole repo lying around in /tmp
	// Does not apply here, because we only are running 2 tests,
	// each in its own directory.
	t.Parallel()

	rootFolder := "../../"
	terraformFolderRelativeToRoot := "examples/complete"

	vars := map[string]interface{}{
		"vnet_cidrs": []string{"10.0.0.0/16"},
	}

	testFolder := filepath.Join(rootFolder, terraformFolderRelativeToRoot)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: testFolder,
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		//VarFiles: varFiles,
		Vars: vars,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors, then run `terraform
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	// Verify we're getting back the VPC CIDR Block we expect
	privateSubnetId := terraform.Output(t, terraformOptions, "private_subnet_id")
	assert.NotEqual(t, "", privateSubnetId)
}
