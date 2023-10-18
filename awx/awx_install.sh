#! /bin/bash

# Please note that this script is tweaked to run as part of a Vagrant deployment
# and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

# AWX Install Steps
# ref: https://www.youtube.com/watch?v=Nvjo2A2cBxI

# Requirements:
# K3s and Kustomize install handled by shared/k3s_install.sh

# Build AWX Operator
su - vagrant -c 'kustomize build . | kubectl apply -f -'
while kubectl get pods -n awx 2>&1 | grep -i -e "0/" -e "No resources found" > /dev/null; do
  kubectl get pods -n awx
  echo "Waiting for AWX Operator build to complete..."
  sleep 10
done
kubectl get pods -n awx
echo "AWX Operator build complete!"

# Build AWX
# It is necessary to build awx-operator first, and only then uncomment awx.yaml from kustomization.yaml.
sed -i kustomization.yaml -e "s/# - awx.yaml/- awx.yaml/"
test -z "${NODE_PORT}" && NODE_PORT=30080
sed -i awx.yaml -e "s/nodeport_port: 30080/nodeport_port: ${NODE_PORT}/"
su - vagrant -c 'kustomize build . | kubectl apply -f -'
while test "$(kubectl get pods -n awx | grep -civ "0/")" != "5"; do
  kubectl get pods -n awx
  echo "Waiting for AWX build to complete..."
  sleep 10
done
kubectl get pods -n awx
echo "AWX build complete!"

# Final Status Report
test -z "${IP_ADDRESS}" && IP_ADDRESS="127.0.0.1"
echo ==============================
echo "AWX URL: http://${IP_ADDRESS}:${NODE_PORT}"
printf "AWX admin password: "
kubectl get secret -n awx awx-admin-password -o jsonpath="{.data.password}" | base64 --decode
printf "\n"
echo "Please note that it may still take up to 10 minutes for AWX to become responsive through the web browser."
echo ==============================
