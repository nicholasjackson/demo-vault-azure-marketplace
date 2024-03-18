/bin/bash

set -e

# Fetch the CA
curl -s ${VAULT_ADDR}/v1/pki/ca_chain -o ca.pem
APP_NAME=$(kubectl get pods -l app=app -o name)

# Forward the port
kubectl port-forward ${APP_NAME} 1443:443 &

echo "App is now exposed at http://localhost:1443, to stop the port-forward run the following command:"
echo ""
echo "kill $(lsof -t -i:1443)"  

echo "Checking SSL cert"

openssl s_client -connect localhost:1443 -CAfile ./ca.pem <<< "Q"

echo "Curling URL"
curl --cacert ./ca.pem --resolve app.marketplace.demo:1443:127.0.0.1 https://app.marketplace.demo:1443