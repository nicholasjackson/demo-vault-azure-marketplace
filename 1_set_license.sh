#!/bin/bash

set -e

kubectl create secret generic license -n ${VAULT_K8S_NAMESPACE} --from-literal=license="${VAULT_LICENSE}"