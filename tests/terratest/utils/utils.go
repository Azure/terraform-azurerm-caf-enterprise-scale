package utils

import (
	"os"
	"path/filepath"
	"runtime"
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// GetDefaultTerraformOptions returns the default Terraform options for the
// given directory.
func GetDefaultTerraformOptions(t *testing.T, dir string) *terraform.Options {
	if dir == "" {
		dir = "./"
	}
	pf := dir + "/tfplan"
	return &terraform.Options{
		Logger:       getLogger(),
		NoColor:      true,
		Parallelism:  20,
		PlanFilePath: pf,
		TerraformDir: dir,
		Vars:         make(map[string]interface{}),
	}
}

// // GetTestFileName returns the name of the test file.
// func GetTestFilename(t *testing.T) string {
// 	_, filename, _, _ := runtime.Caller(1)
// 	return filename
// }

// GetTestDir returns the directory of the test file.
func GetTestDir(t *testing.T) string {
	_, filename, _, _ := runtime.Caller(1)
	return filepath.Dir(filename)
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
