#!/usr/bin/bash
set -e

#
# Shell Script
# - Generate Azure Pipelines Strategy
#

echo "==> Generating Azure Pipelines Strategy Matrix..."

tf_url="https://api.github.com/repos/hashicorp/terraform/tags"
azurerm_url="https://registry.terraform.io/v1/providers/hashicorp/azurerm"

########################################
# Terraform Versions
# - Base Version: "0.13.2"
# - Latest Versions:
#     0.13.* (latest 1)
#     0.14.* (latest 3)
#     0.15.* (latest 1)
########################################

tf_vers=("0.13.2")
tf_vers+=($(curl -s $tf_url | jq -r '[.[].name | select(match("^v0.13"))] | .[0]' | tr -d v))
tf_vers+=($(curl -s $tf_url | jq -r '[.[].name | select(match("^v0.14"))] | .[2,1,0]' | tr -d v))
# Terraform v0.15.x currently causes validation errors. Needs further investigation.
# tf_vers+=($(curl -s $tf_url | jq -r '[.[].name | select(match("^v0.15"))] | .[0]' | tr -d v))

########################################
# Terraform AzureRM Provider Versions
# - Base Version: (2.34.0)
# - Latest Versions: (latest 1)
########################################

azurerm_ver_base="2.34.0"
azurerm_ver_latest="$(curl -s $azurerm_url | jq -r '.version')"

########################################
# Set a multi-job output variable to
# control strategy matrix for test jobs
########################################

# Need length of tf_vers array. This gives the number
# of items in the array.
tf_vers_len=${#tf_vers[@]}

# To generate a valid JSON object, we need to reduce
# tf_vers_len value by 1 to stop the copy loop before
# the last value is processed. This allows the final
# array value to be processsed without appending a
# comma to the end of the last entry (see below).
copy_len=$(($tf_vers_len-1))

# Generate an array containing the JSON object
# for the matrix configuration.
matrix=("{")
# The copy loop generates JSON entries in the
# matrix array for "n-1" tf_vers.
for (( i=0; i<$copy_len; i++ ))
do
    tf_ver=${tf_vers[$i]}
    job_id_1=$((($i*2)+1))
    job_id_2=$((($i*2)+2))
    matrix+=("\"$job_id_1. (TF: $tf_ver, AZ: $azurerm_ver_base)\": { \"TF_VERSION\": \"$tf_ver\", \"TF_AZ_VERSION\": \"$azurerm_ver_base\"},")
    matrix+=("\"$job_id_2. (TF: $tf_ver, AZ: $azurerm_ver_latest)\": { \"TF_VERSION\": \"$tf_ver\", \"TF_AZ_VERSION\": \"$azurerm_ver_latest\"},")
done
# For the "nth" entry in tf_vers, generate
# JSON entries outside the copy loop to ensure
# the "final loop" doesn't append a comma to
# the end of the last entry.
tf_ver=${tf_vers[$copy_len]}
job_id_1=$((($copy_len*2)+1))
job_id_2=$((($copy_len*2)+2))
matrix+=("\"$job_id_1. (TF: $tf_ver, AZ: $azurerm_ver_base)\": { \"TF_VERSION\": \"$tf_ver\", \"TF_AZ_VERSION\": \"$azurerm_ver_base\"},")
matrix+=("\"$job_id_2. (TF: $tf_ver, AZ: $azurerm_ver_latest)\": { \"TF_VERSION\": \"$tf_ver\", \"TF_AZ_VERSION\": \"$azurerm_ver_latest\"}")
matrix+=("}")

# Use "jq" to ensure matrix contains valid JSON.
matrix_json_output=$( echo ${matrix[*]} | jq -c . )

# Save the matrix value to an output variable
# for downstream consumption .
echo "##vso[task.setVariable variable=matrix_json;isOutput=true]$matrix_json_output"
