#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Destroy
#

TF_WORKSPACE="$PIPELINE_WORKSPACE/s/$TEST_MODULE_PATH"

echo "==> Switching directories..."
cd "$TF_WORKSPACE"

echo "==> Destroying infrastructure..."
# shellcheck disable=SC2153 # Environment variables set by pipeline
terraform destroy \
    -var "root_id=$TF_ROOT_ID" \
    -var "root_name=ES-$TF_VERSION-$TF_AZ_VERSION" \
    -var "primary_location=$PRIMARY_LOCATION" \
    -var "secondary_location=$SECONDARY_LOCATION" \
    -auto-approve \
    -parallelism="$PARALLELISM"
status=$?

if [ $status -ne 0 ]; then

    IFS=$'\n'

    TF_ROOT_ID=("$TF_ROOT_ID")
    for x in "${TF_ROOT_ID[@]}"; do
        echo "==> Retrieving management group structure..."
        TMP_FILE="./data.json"
        az account management-group show -n "$x" -e -r >"$TMP_FILE"

        # Depth 0
        for i in $(jq -rc '.children[]?' "$TMP_FILE"); do
            # Depth 1
            for j in $(echo "$i" | jq -rc 'select(.children != null) | .children[]?'); do
                # Depth 2
                for k in $(echo "$j" | jq -rc 'select(.children != null) | .children[]?'); do
                    # Depth 3
                    for l in $(echo "$k" | jq -rc 'select(.children != null) | .children[]?'); do
                        # Depth 4
                        for m in $(echo "$l" | jq -rc 'select(.children != null) | .children[]?'); do
                            # Depth 5
                            for n in $(echo "$m" | jq -rc 'select(.children != null) | .children[]?'); do
                                # Depth 6
                                for o in $(echo "$n" | jq -rc 'select(.children != null) | .children[]?'); do
                                    mg_name=$(echo "$o" | jq -rc '.name?')
                                    echo "==> Deleting management group - $mg_name..."
                                    az account management-group delete -n "$mg_name"
                                done
                                # Depth 6
                                mg_name=$(echo "$n" | jq -rc '.name?')
                                echo "==> Deleting management group - $mg_name..."
                                az account management-group delete -n "$mg_name"
                            done
                            # Depth 5
                            mg_name=$(echo "$m" | jq -rc '.name?')
                            echo "==> Deleting management group - $mg_name..."
                            az account management-group delete -n "$mg_name"
                        done
                        # Depth 4
                        mg_name=$(echo "$l" | jq -rc '.name?')
                        echo "==> Deleting management group - $mg_name..."
                        az account management-group delete -n "$mg_name"
                    done
                    # Depth 3
                    mg_name=$(echo "$k" | jq -rc '.name?')
                    echo "==> Deleting management group - $mg_name..."
                    az account management-group delete -n "$mg_name"
                done
                # Depth 2
                mg_name=$(echo "$j" | jq -rc '.name?')
                echo "==> Deleting management group - $mg_name..."
                az account management-group delete -n "$mg_name"
            done
            # Depth 1
            mg_name=$(echo "$i" | jq -rc '.name?')
            echo "==> Deleting management group - $mg_name..."
            az account management-group delete -n "$mg_name"
        done
        # Depth 0
        echo "==> Deleting management group - $x..."
        az account management-group delete -n "$x"
    done

    unset IFS

else
    echo "==> Skipping manual management group deletion..."
fi
