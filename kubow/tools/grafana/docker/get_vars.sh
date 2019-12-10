#!/bin/sh

. read_yaml.sh

eval $(read_yaml docker-compose.yml "yaml_")

site=$yaml_services_grafana_environment_GF_SERVER_ROOT_URL
password=$yaml_services_grafana_environment_GF_SECURITY_ADMIN_PASSWORD

echo "Open $site:3000"
echo "Username: admin"
echo "Password: $password"