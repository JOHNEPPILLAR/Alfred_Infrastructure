#!/bin/bash
clear

echo "Setup/run alfred dyson data collector service docker container"
echo "--------------------------------------------------------------"
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

export PORT=3978
export TRACE_LEVEL="info"

SETUP_VAULT="$2"
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
            vault policy write -address=$VAULT_URL alfred_dyson_data_collector_service policy.hcl
            vault write -address=$VAULT_URL auth/approle/role/alfred_dyson_data_collector_service_role token_ttl=1m token_max_ttl=2m token_policies=alfred_dyson_data_collector_service
  
            echo "Storing config..."
            read -p "Dyson username: " DysonUserName
            vault write -address=$VAULT_URL secret/alfred_dyson_data_collector_service/DysonUserName data=$DysonUserName
            read -p "Dyson user password: " DysonPassword
            vault write -address=$VAULT_URL secret/alfred_dyson_data_collector_service/DysonPassword data=$DysonPassword
            read -p "Dyson office IP: " DysonOfficeIP
            vault write -address=$VAULT_URL secret/alfred_dyson_data_collector_service/PE9-UK-JMA0292A data=$DysonOfficeIP
            read -p "Dyson bedroom IP: " DysonBedroomIP
            vault write -address=$VAULT_URL secret/alfred_dyson_data_collector_service/VS7-UK-MEA3918A data=$DysonBedroomIP
            ;;
    No )    echo "Skipping vault setup"
            ;;
esac

echo "Creating certs..."
mkcert alfred_dyson_data_collector_service

echo "Storing certs..."
vault write -address=$VAULT_URL secret/alfred_dyson_data_collector_service/ssl_key data=@alfred_dyson_data_collector_service-key.pem
vault write -address=$VAULT_URL secret/alfred_dyson_data_collector_service/ssl_cert data=@alfred_dyson_data_collector_service.pem
echo "Tidying up certs..."
rm *.pem

echo "Creating access token..."
VAULES=$(vault read -address=$VAULT_URL -format=json auth/approle/role/alfred_dyson_data_collector_service_role/role-id)
APP_ROLE_ID=$(echo $VAULES | jq .data.role_id)
export APP_ROLE_ID=${APP_ROLE_ID:1:${#APP_ROLE_ID}-2}
VAULES=$(vault write -f --format=json -address=$VAULT_URL auth/approle/role/alfred_dyson_data_collector_service_role/secret-id)
APP_TOKEN=$(echo $VAULES | jq .data.secret_id)
export APP_TOKEN=${APP_TOKEN:1:${#APP_TOKEN}-2}

echo "Runing the container..."
echo $DOCKER_REGISTERY_PASSWORD | docker login $DOCKER_REGISTERY_URL -u $DOCKER_REGISTERY_USERNAME --password-stdin 
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml up -d --build
docker logout

echo "Purge docker images..."
docker image prune -f

echo "Finished"
