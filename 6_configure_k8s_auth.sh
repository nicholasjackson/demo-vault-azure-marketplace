/bin/bash

set -e

# Enable the Kubernetes auth method
vault auth enable kubernetes

POD_NAME=$(kubectl get pods -n ${VAULT_K8S_NAMESPACE} -l component=server -o name)
K8S_API=$(kubectl exec ${POD_NAME} -n ${VAULT_K8S_NAMESPACE} -- sh -c 'echo $KUBERNETES_SERVICE_HOST')

# Configure the Kubernetes auth method, vault will use the server pods
# service account to authenticate with the Kubernetes API
vault write auth/kubernetes/config \
    kubernetes_host=https://${K8S_API}