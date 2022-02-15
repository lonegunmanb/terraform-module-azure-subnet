package e2e_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	// t.Parallel()

	rootFolder := "../../"
	terraformFolderRelativeToRoot := "examples/complete"
	terraformDir := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: terraformDir,
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"../../examples/complete/fixtures.us-east.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors, then run `terraform
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	privateSubnetId := terraform.Output(t, terraformOptions, "private_subnet_id")
	assert.NotEqual(t, "", privateSubnetId)
}

func TestExamplesComplete2(t *testing.T) {
	// t.Parallel()

	rootFolder := "../../"
	terraformFolderRelativeToRoot := "examples/complete2"
	terraformDir := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: terraformDir,
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"../../examples/complete/fixtures.us-east.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors, then run `terraform
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	privateSubnetId := terraform.Output(t, terraformOptions, "private_subnet_id")
	assert.NotEqual(t, "", privateSubnetId)
}
