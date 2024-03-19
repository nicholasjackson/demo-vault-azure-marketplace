/bin/bash

set -e

# Get the Vault pod name
POD_NAME=$(kubectl get pods -n ${VAULT_K8S_NAMESPACE} -l component=server -o name)

# Initialize the Vault server and write the unseal keys and root token to a file
kubectl exec ${POD_NAME} -n ${VAULT_K8S_NAMESPACE} -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json

# Unseal the Vault server
VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r '.unseal_keys_b64[]')
kubectl exec ${POD_NAME} -n ${VAULT_K8S_NAMESPACE} -- vault operator unseal ${VAULT_UNSEAL_KEY}

echo "Vault has been initialized and unsealed. Unseal keys and root token have been written to cluster-keys.json"
echo ""
echo "You can set the VAULT_TOKEN environment variable to the root token to interact with the Vault server using the"
echo "following command:"
echo ""
echo "export VAULT_TOKEN=$(cat cluster-keys.json | jq -r '.root_token')"