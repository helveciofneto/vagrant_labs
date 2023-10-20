#! /bin/bash

# Please note that this script is tweaked to run as part of a Vagrant deployment
# and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

# AWX Install Steps
# ref: https://www.youtube.com/watch?v=Nvjo2A2cBxI

# Requirements:
# K3s and Kustomize install handled by shared/k3s_install.sh

# 30 checks every 30 seconds = 15 minutes
max_checks=30
check_interval=30

# Build AWX Operator
su - vagrant -c 'kustomize build . | kubectl apply -f -'
current_check=0
while test "${current_check}" -lt "${max_checks}" && kubectl get pods -n awx 2>&1 | grep -i -e "0/" -e "No resources found" > /dev/null; do
  (( current_check = "${current_check}" + 1 ))
  echo "Waiting for AWX Operator build to complete (check ${current_check} of ${max_checks})..."
  sleep "${check_interval}"
done
if kubectl get pods -n awx 2>&1 | grep -i -e "0/" -e "No resources found" > /dev/null; then
  echo "=============================="
  echo "AWX Operator build TIMED OUT!"
  echo "It is highly recommended to restart the deployment process."
  echo "=============================="
  exit 1
else
  kubectl get pods -n awx
  echo "=============================="
  echo "AWX Operator build SUCCESSFUL!"
  echo "=============================="
fi

# Build AWX
# It is necessary to build awx-operator first, and only then uncomment awx.yaml from kustomization.yaml.
sed -i kustomization.yaml -e "s/# - awx.yaml/- awx.yaml/"
test -z "${NODE_PORT}" && NODE_PORT=30080
sed -i awx.yaml -e "s/nodeport_port: 30080/nodeport_port: ${NODE_PORT}/"
su - vagrant -c 'kustomize build . | kubectl apply -f -'
current_check=0
while test "${current_check}" -lt "${max_checks}" && test "$(kubectl get pods -n awx | grep -civ "0/")" != "5"; do
  (( current_check = "${current_check}" + 1 ))
  echo "Waiting for AWX Application build to complete (check ${current_check} of ${max_checks})..."
  sleep "${check_interval}"
done
if test "$(kubectl get pods -n awx | grep -civ "0/")" != "5"; then
  echo "=============================="
  echo "AWX Application build TIMED OUT!"
  echo "It is highly recommended to restart the deployment process."
  echo "=============================="
  exit 1
else
  kubectl get pods -n awx
  echo "=============================="
  echo "AWX Application build SUCCESSFUL!"
  echo "=============================="
fi

# Wait for Database Migration task to start.
current_check=0
while test "${current_check}" -lt "${max_checks}" -a "$(pgrep -cf "awx-manage migrate")" -eq 0; do
  (( current_check = "${current_check}" + 1 ))
  echo "Waiting for Database Migration task to start (check ${current_check} of ${max_checks})..."
  sleep "${check_interval}"
done
if test "$(pgrep -cf "awx-manage migrate")" -eq 0; then
  echo "=============================="
  echo "Database Migration FAILED to start!"
  echo "It is highly recommended to restart the deployment process."
  echo "=============================="
  exit 1
else
  echo "Database Migration task started."
fi

# Now wait for Database Migration task to complete
# AWX will only be accessible via browser after this step is complete.
current_check=0
while test "${current_check}" -lt "${max_checks}" -a "$(pgrep -cf "awx-manage migrate")" -gt 0; do
  (( current_check = "${current_check}" + 1 ))
  echo "Waiting for Database Migration task to complete (check ${current_check} of ${max_checks})..."
  sleep "${check_interval}"
done
if test "$(pgrep -cf "awx-manage migrate")" -gt 0; then
  echo "=============================="
  echo "Database Migration task TIMED OUT!"
  echo "It is highly recommended to restart the deployment process."
  echo "=============================="
  exit 1
else
  echo "Database Migration task SUCCESSFUL!"
fi

# Final Status Report
test -z "${IP_ADDRESS}" && IP_ADDRESS="127.0.0.1"
printf "\n\n==============================\n"
echo "AWX IS READY FOR USE!"
echo "AWX URL: http://${IP_ADDRESS}:${NODE_PORT}"
printf "AWX admin password: "
kubectl get secret -n awx awx-admin-password -o jsonpath="{.data.password}" | base64 --decode
print "\n\n"
echo "It may take a couple of minutes before AWX is responsive through the web browser."
printf "==============================\n"
