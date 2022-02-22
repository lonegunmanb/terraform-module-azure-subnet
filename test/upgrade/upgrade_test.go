package upgrade

import (
	"context"
	"fmt"
	"os/exec"
	"testing"

	"github.com/ahmetb/go-linq/v3"
	"github.com/google/go-github/v42/github"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/hashicorp/go-getter"
	"github.com/stretchr/testify/assert"
	"golang.org/x/mod/semver"
	_ "golang.org/x/mod/semver"
)

func TestExamplesUpgrade(t *testing.T) {
	// t.Parallel()
	client := github.NewClient(nil)
	tags, _, err := client.Repositories.ListTags(context.TODO(), "lonegunmanb", "terraform-module-azure-subnet", nil)
	if err != nil {
		t.Error(err.Error())
	}
	if tags == nil {
		t.Error("Cannot find tags")
	}
	latestTag := linq.From(tags).Where(func(t interface{}) bool {
		if t == nil {
			return false
		}
		tag := t.(*github.RepositoryTag)
		v := tag.GetName()
		return semver.IsValid(v) //&& !strings.Contains(v, "rc")
	}).Sort(func(i, j interface{}) bool {
		it := i.(*github.RepositoryTag)
		jt := j.(*github.RepositoryTag)
		return semver.Compare(it.GetName(), jt.GetName()) > 0
	}).First().(*github.RepositoryTag).GetName()

	tagDir := fmt.Sprintf("/tmp/%s", latestTag)
	err = getter.Get(tagDir, fmt.Sprintf("github.com/lonegunmanb/terraform-module-azure-subnet?ref=%s", latestTag))
	if err != nil {
		t.Error("Cannot get module with tag")
	}
	rootFolder := tagDir
	terraformFolderRelativeToRoot := "examples/complete"
	terraformDir := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: terraformDir,
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"../../examples/complete/fixtures.us-east.tfvars"},
	}

	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors, then run `terraform
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	cmd := exec.Command("/bin/sh", "-c", fmt.Sprintf("MODULE_SOURCE=/src sprig-cli -tmpl %[1]s/override.tf.tplt > %[1]s/override.tf", terraformDir))
	_, err = cmd.Output()
	if err != nil {
		assert.Fail(t, err.Error())
	}
	fmt.Print("init and plan")
	code := terraform.InitAndPlanWithExitCode(t, terraformOptions)
	if code != 0 {
		assert.Fail(t, "terraform configuration not idempotent:%s", terraform.Plan(t, terraformOptions))
	}
}
