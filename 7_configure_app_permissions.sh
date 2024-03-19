#!/bin/bash

set -e

# Create a policy named "pki_marketplace" that allows create capabilities on the "pki" secrets engine
vault policy write pki_marketplace - <<EOF
path "pki/issue/marketplace" {
  capabilities = ["create", "update"]
}
EOF

# Create a role named "app" that allows the app service account to authenticate
# with Vault and get a token to access the "default" and "pki_marketplace" policies
vault write auth/kubernetes/role/app \
    bound_service_account_names=app \
    bound_service_account_namespaces=default \
    policies=default,pki_marketplace \
    ttl=1h