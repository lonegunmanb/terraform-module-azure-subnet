package e2e_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_helper "github.com/lonegunmanb/terraform-module-test-helper"
	"github.com/stretchr/testify/assert"
)

func TestExamplesComplete(t *testing.T) {
	test_helper.RunE2ETest(t, "../../", "examples/complete", terraform.Options{
		Upgrade: true,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		privateSubnetId, ok := output["private_subnet_id"].(string)
		assert.True(t, ok)
		assert.NotEqual(t, "", privateSubnetId)
	})
}

func TestExamplesComplete2(t *testing.T) {
	test_helper.RunE2ETest(t, "../../", "examples/complete2", terraform.Options{
		Upgrade: true,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		privateSubnetId, ok := output["private_subnet_id"].(string)
		assert.True(t, ok)
		assert.NotEqual(t, "", privateSubnetId)
	})
}
