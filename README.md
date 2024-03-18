# Setup

## Prerequisites

* Vault CLI (https://releases.hashicorp.com/vault/1.15.6+ent/vault_1.15.6+ent_linux_amd64.zip)
* Vault Enterprise Licence
* Kubectl

## Setting the licence

First you need to import your Vault Enterprise license into the Kubernetes secret
you referenced when deploying the marketplace item.

```shell
kubectl create secret generic license -n ${VAULT_NAMESPACE} --from-literal=license="${VAULT_LICENSE}"
```

## Initialize Vault

```shell
kubectl exec vaultent-0 -n vault -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json
```

Unseal Vault

```shell
kubectl exec vaultent-0 -n vault -- vault operator unseal $(jq -r ".unseal_keys_b64[]" cluster-keys.json)
```

## Expose Vault

## Set Vault token and test vault is working

```shell
kubectl exec vaultent-0 -n vault -- VAULT_TOKEN=$(jq -r ".unseal_keys_b64[]" cluster-keys.json) vault read sys/mounts 
```