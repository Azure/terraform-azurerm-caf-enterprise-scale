#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Destroy
#

echo "==> Switching directories..."
cd $PIPELINE_WORKSPACE/s/tests/deployment

echo "==> Destroying infrastructure..."
terraform destroy \
    -var "root_id_1=$TF_ROOT_ID_1" \
    -var "root_id_2=$TF_ROOT_ID_2" \
    -var "root_id_3=$TF_ROOT_ID_3" \
    -var "root_name=ES-$TF_VERSION-$TF_AZ_VERSION" \
    -auto-approve \
    -parallelism=256 \
    -state="./terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate"
status=$?

if [ $status -ne 0 ]
then

    echo "==> Authenticating cli..."
    az login \
        --service-principal \
        --tenant $ARM_TENANT_ID \
        --username $ARM_CLIENT_ID \
        --password $ARM_CLIENT_SECRET

    IFS=$'\n'

    TF_ROOT_ID=("$TF_ROOT_ID_1" "$TF_ROOT_ID_2" "$TF_ROOT_ID_3")
    for x in "${TF_ROOT_ID[@]}"
    do
        echo "==> Retrieving management group structure..."
        az account management-group show -n "$x" -e -r > ./data.json

        # Depth 0
        for i in $(cat data.json | jq -rc '.children[]?')
        do
            # Depth 1
            for j in $(echo $i | jq -rc 'select(.children != null) | .children[]?')
            do
                # Depth 2
                for k in $(echo $j | jq -rc 'select(.children != null) | .children[]?')
                do
                    # Depth 3
                    for l in $(echo $k | jq -rc 'select(.children != null) | .children[]?')
                    do
                        # Depth 4
                        for m in $(echo $l | jq -rc 'select(.children != null) | .children[]?')
                        do
                            # Depth 5
                            for n in $(echo $m | jq -rc 'select(.children != null) | .children[]?')
                            do
                                # Depth 6
                                for o in $(echo $n | jq -rc 'select(.children != null) | .children[]?')
                                do
                                    echo "==> Deleting management group - $(echo $o | jq -rc '.name?')..."
                                    az account management-group delete -n "$(echo $o | jq -rc '.name?')"
                                done
                                # Depth 6
                                echo "==> Deleting management group - $(echo $n | jq -rc '.name?')..."
                                az account management-group delete -n "$(echo $n | jq -rc '.name?')"
                            done
                            # Depth 5
                            echo "==> Deleting management group - $(echo $m | jq -rc '.name?')..."
                            az account management-group delete -n "$(echo $m | jq -rc '.name?')"
                        done
                        # Depth 4
                        echo "==> Deleting management group - $(echo $l | jq -rc '.name?')..."
                        az account management-group delete -n "$(echo $l | jq -rc '.name?')"
                    done
                    # Depth 3
                    echo "==> Deleting management group - $(echo $k | jq -rc '.name?')..."
                    az account management-group delete -n "$(echo $k | jq -rc '.name?')"
                done
                # Depth 2
                echo "==> Deleting management group - $(echo $j | jq -rc '.name?')..."
                az account management-group delete -n "$(echo $j | jq -rc '.name?')"
            done
            # Depth 1
            echo "==> Deleting management group - $(echo $i | jq -rc '.name?')..."
            az account management-group delete -n "$(echo $i | jq -rc '.name?')"
        done
        # Depth 0

        az account management-group delete -n "$x"
    done

    unset IFS

else
    echo "==> Skipping manual management group deletion..."
fi
