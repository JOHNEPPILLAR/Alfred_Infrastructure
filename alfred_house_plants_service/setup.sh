#!/bin/bash
clear

echo "Setup/run alfred house flowers service docker container"
echo "-------------------------------------------------------"
echo ""

echo "Loging into vault..."
vault login -address=$VAULT_URL $VAULT_TOKEN

ENVIRONMENT="$1"
if [ -z "$ENVIRONMENT" ]
then
    echo ""
    echo "Select an environment:"
    select ENVIRONMENT in "production" "development"; 
    do
        break
    done
fi

case $ENVIRONMENT in
    production )  export MOCK="false";;
    development ) export MOCK="true";;
    *) echo "Invalid enviroment, exit setup"; exit;;
esac
export ENVIRONMENT=$ENVIRONMENT
echo "Set ENVIRONMENT to: " $ENVIRONMENT

export PORT=3978
export TRACE_LEVEL="info"

SETUP_VAULT="$3"
if [ -z "$SETUP_VAULT" ]
then
    echo ""
    echo "Setup vault data for this service?"
    select SETUP_VAULT in "Yes" "No";
    do
        break
    done
fi

echo ""
case $SETUP_VAULT in
    Yes )   echo "Setup policies..."
            vault policy write -address=$VAULT_URL alfred_house_plants_service policy.hcl
            vault write -address=$VAULT_URL auth/approle/role/alfred_house_plants_service_role token_ttl=1m token_max_ttl=2m token_policies=alfred_house_plants_service
            ;;
    No )    echo "Skipping vault setup"
            ;;
esac

echo "Creating certs..."
mkcert alfred_house_plants_service
echo "Storing certs..."
vault write -address=$VAULT_URL secret/alfred_house_plants_service/ssl_key data=@alfred_house_plants_service-key.pem
vault write -address=$VAULT_URL secret/alfred_house_plants_service/ssl_cert data=@alfred_house_plants_service.pem
echo "Tidying up certs..."
rm *.pem

echo "Creating access token..."
VAULES=$(vault read -address=$VAULT_URL -format=json auth/approle/role/alfred_house_plants_service_role/role-id)
APP_ROLE_ID=$(echo $VAULES | jq .data.role_id)
export APP_ROLE_ID=${APP_ROLE_ID:1:${#APP_ROLE_ID}-2}
VAULES=$(vault write -f --format=json -address=$VAULT_URL auth/approle/role/alfred_house_plants_service_role/secret-id)
APP_TOKEN=$(echo $VAULES | jq .data.secret_id)
export APP_TOKEN=${APP_TOKEN:1:${#APP_TOKEN}-2}

echo "Runing the container..."
echo $DOCKER_REGISTERY_PASSWORD | docker login $DOCKER_REGISTERY_URL -u $DOCKER_REGISTERY_USERNAME --password-stdin 

docker-compose down
docker-compose pull
docker-compose up -d

docker logout

echo "Purge docker images..."
docker image prune -f

echo "Finished"
