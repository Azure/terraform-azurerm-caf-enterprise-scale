package utils

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// GetDefaultTerraformOptions returns the default Terraform options for the Terratest.
func GetDefaultTerraformOptions(t *testing.T) *terraform.Options {
	return &terraform.Options{
		Logger:       getLogger(),
		NoColor:      true,
		Parallelism:  20,
		PlanFilePath: "./tfplan",
		TerraformDir: "./",
		Vars:         make(map[string]interface{}),
	}
}

// getLogger returns the discard logger by default, unless TERRATEST_LOG env
// variable is set. In which case it returns the terratest logger, which
// shows the output of the Terraform commands.
func getLogger() *logger.Logger {
	if os.Getenv("TERRATEST_LOG") != "" {
		return logger.Terratest
	}
	return logger.Discard
}
