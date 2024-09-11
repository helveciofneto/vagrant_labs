#! /bin/bash

# Please note that this script is tweaked to run as part of a Vagrant deployment
# and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

# Install Elasticsearch and Kibana
# This assumes Docker is installed.
# Ref: https://github.com/elastic/elasticsearch?tab=readme-ov-file#run-elasticsearch-locally
echo "=============================="
echo "Starting Elasticsearch and Kibana Install..."
echo "=============================="
export ELASTIC_VERSION="${ELASTIC_VERSION:-"8.15.1"}"
export ELASTIC_LICENSE_TYPE="${ELASTIC_LICENSE_TYPE:-"basic"}"
export ELASTIC_LOCAL_PORT="${ELASTIC_LOCAL_PORT:-"9200"}"
export ELASTIC_PASSWORD="${ELASTIC_PASSWORD:-"elastic"}"

export KIBANA_VERSION="${KIBANA_VERSION:-"8.15.1"}"
export KIBANA_LICENSE_TYPE="${KIBANA_LICENSE_TYPE:-"basic"}"
export KIBANA_LOCAL_PORT="${KIBANA_LOCAL_PORT:-"5601"}"
export KIBANA_PASSWORD="${KIBANA_PASSWORD:-"elastic"}"


docker network create elastic-net

# Start Elasticsearch
docker run -p $ELASTIC_LOCAL_PORT:9200 --restart always \
  -d --name elasticsearch --network elastic-net \
  -e ELASTIC_PASSWORD=$ELASTIC_PASSWORD \
  -e "discovery.type=single-node" \
  -e "xpack.security.http.ssl.enabled=false" \
  -e "xpack.license.self_generated.type=$ELASTIC_LICENSE_TYPE" \
  docker.elastic.co/elasticsearch/elasticsearch:$ELASTIC_VERSION

# Add Kibana System Password to Elastic
current_try=0
max_tries=10
retry_interval=5
cmd_success=0
while test "${current_try}" -lt "${max_tries}" -a "${cmd_success}" -eq 0; do
  sleep "${retry_interval}"
  curl -s -u elastic:$ELASTIC_PASSWORD \
    -X POST http://localhost:$ELASTIC_LOCAL_PORT/_security/user/kibana_system/_password \
    -d '{"password":"'"$KIBANA_PASSWORD"'"}' \
    -H 'Content-Type: application/json' && cmd_success=1 || let current_try=current_try+1
done

if test "${cmd_success}" -eq 0; then
  echo "=============================="
  echo "Elastic and Kibana Install FAILED!"
  echo "Kibana system password config command has failed."
  echo "It is recommended to restart the deployment process."
  echo "=============================="
  exit 1
fi

# Start Kibana
docker run -p $KIBANA_LOCAL_PORT:5601 --restart always \
  -d --name kibana --network elastic-net \
  -e ELASTICSEARCH_URL=http://elasticsearch:$ELASTIC_LOCAL_PORT \
  -e ELASTICSEARCH_HOSTS=http://elasticsearch:$ELASTIC_LOCAL_PORT \
  -e ELASTICSEARCH_USERNAME=kibana_system \
  -e ELASTICSEARCH_PASSWORD=$KIBANA_PASSWORD \
  -e "xpack.security.enabled=false" \
  -e "xpack.license.self_generated.type=$KIBANA_LICENSE_TYPE" \
  docker.elastic.co/kibana/kibana:$KIBANA_VERSION

# Check installation status
if test "$(docker ps | grep -E '(elasticsearch|kibana)' | wc -l)" -eq 2; then
  echo "=============================="
  echo "Elasticsearch and Kibana Install SUCCESSFUL!"
  echo ""
  echo "Elasticsearch (version $ELASTIC_VERSION): http://$IP_ADDRESS:$ELASTIC_LOCAL_PORT"
  echo "Kibana URL (version $KIBANA_VERSION): http://$IP_ADDRESS:$KIBANA_LOCAL_PORT"
  echo ""
  echo "Username: elastic (for both Elastic and Kibana)"
  echo "Elasticsearch Password: $ELASTIC_PASSWORD"
  echo "Kibana Password: $KIBANA_PASSWORD"
  echo ""
  echo "It may take a few minutes for all components to be fully responsive."
  echo "=============================="
else
  echo "=============================="
  echo "Elasticsearch and Kibana Install FAILED!"
  echo "The expected elasticsearch and/or kibana containers could not be found."
  echo "It is recommended to restart the deployment process."
  echo "=============================="
  exit 1
fi
