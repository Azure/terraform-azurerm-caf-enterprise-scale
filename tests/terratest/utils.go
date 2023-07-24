package terratest

import (
	"fmt"
	"io"
	"os"
	"path/filepath"
	"text/template"

	"github.com/Azure/terratest-terraform-fluent/setuptest"
)

// RequiredProvidersData is the data struct for the Terraform required providers block.
// It should ordinarily be generated using utils.NewRequiredProvidersData().
type RequiredProvidersData struct {
	AzAPIVersion   string
	AzureRMVersion string
}

const (
	requiredProvidersContent = `
terraform {
	required_version = ">= 1.3.0"
	required_providers {
		azurerm = {
			source  = "hashicorp/azurerm"
			version = "{{ .AzureRMVersion }}"
		}
		azapi = {
			source  = "azure/azapi"
			version = "{{ .AzAPIVersion }}"
		}
	}
}`
)

// AzureRmAndRequiredProviders is a setuptest.SetupTestPrepFunc that will create
//
// - a required providers file in the given temporary directory (with version constraints from env vars)
// - a azurerm providers file in the given temporary directory
var AzureRmAndRequiredProviders setuptest.PrepFunc = func(resp setuptest.Response) error {
	if err := createAzureRmProvidersFile(resp.TmpDir); err != nil {
		return err
	}
	return generateRequiredProvidersFile(newRequiredProvidersData(), filepath.Clean(resp.TmpDir+"/terraform.tf"))
}

var AzureRm setuptest.PrepFunc = func(resp setuptest.Response) error {
	return createAzureRmProvidersFile(resp.TmpDir)
}

// RequiredProviders is a setuptest.SetupTestPrepFunc that will create a required providers file in the given temporary directory.
var RequiredProviders setuptest.PrepFunc = func(resp setuptest.Response) error {
	return generateRequiredProvidersFile(newRequiredProvidersData(), filepath.Clean(resp.TmpDir+"/terraform.tf"))
}

func generateRequiredProviders(data RequiredProvidersData, w io.Writer) error {
	tmpl := template.Must(template.New("terraformtf").Parse(requiredProvidersContent))
	return tmpl.Execute(w, data)
}

// generateRequiredProvidersFile generates a required providers file in the given path.
// The file path should be "terraform.tf".
func generateRequiredProvidersFile(data RequiredProvidersData, path string) error {
	f, err := os.OpenFile(path, os.O_RDWR|os.O_TRUNC, 0644)
	if err != nil {
		return err
	}
	defer f.Close()
	return generateRequiredProviders(data, f)
}

// newRequiredProvidersData generated a new version of the required providers data struct.
// It will use environment variables "AZAPI_VERSION" and "AZURERM_VERSION" to generate the data.
// If the environment variables are not set or the value is "latest", it will use the default values.
func newRequiredProvidersData() RequiredProvidersData {
	var rpd RequiredProvidersData
	azapiver := ">= 1.4.0"
	azurermver := ">= 3.7.0"

	if val := os.Getenv("AZAPI_VERSION"); val != "" && val != "latest" {
		azapiver = "= " + val
	}
	if val := os.Getenv("AZURERM_VERSION"); val != "" && val != "latest" {
		azurermver = "= " + val
	}
	rpd.AzAPIVersion = azapiver
	rpd.AzureRMVersion = azurermver
	return rpd
}

// createAzureRmProvidersFile creates an azurerm terraform providers file in the supplied directory.
func createAzureRmProvidersFile(dir string) error {
	dir = filepath.Clean(dir)
	f, err := os.Create(filepath.Join(dir, "_providers.azurerm.tf"))
	if err != nil {
		return fmt.Errorf("error creating providers.tf: %v", err)
	}
	defer f.Close()
	providerstf := `provider "azurerm" {
		features {}
	}

	provider "azurerm" {
		alias = "connectivity"
		features {}
	}

	provider "azurerm" {
		alias = "management"
		features {}
	}`
	_, err = f.WriteString(providerstf)
	if err != nil {
		return fmt.Errorf("error writing providers.tf: %v", err)
	}
	return nil
}
