#!/bin/bash

set -e

POD_NAME=$(kubectl get pods -n ${VAULT_K8S_NAMESPACE} -l component=server -o name)
kubectl port-forward ${POD_NAME} -n ${VAULT_K8S_NAMESPACE} 8200:8200 &

echo "Vault is now exposed at http://localhost:8200, to stop the port-forward run the following command:"
echo ""
echo "pkill kubectl"
echo ""
echo "To interact with the Vault server, set the VAULT_TOKEN, and VAULT_ADDR environment variable,"
echo "using the following commands:"

echo "export VAULT_TOKEN=$(cat cluster-keys.json | jq -r '.root_token')"
echo "export VAULT_ADDR=http://localhost:8200"