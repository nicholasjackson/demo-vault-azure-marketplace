#!/bin/bash

set -e

# Enable the PKI secrets engine
vault secrets enable pki

# Tune the PKI secrets engine, set the default TTL to 1 year
vault secrets tune -max-lease-ttl=8760h pki

# Generate a self-signed root certificate
vault write pki/root/generate/internal \
    common_name=marketplace.demo \
    ttl=8760h

# Create a role named "marketplace" that allows certs 
# to be created for subdomains of "marketplace.demo"
vault write pki/roles/marketplace \
    allowed_domains=marketplace.demo \
    allow_subdomains=true \
    max_ttl=72h