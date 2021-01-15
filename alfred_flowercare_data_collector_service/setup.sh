#!/bin/bash
clear

echo "Setup/run alfred flower care service docker container"
echo "-----------------------------------------------------"
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

ENVIRONMENT="$2"
if [ -z "$ZONE" ]
then
    echo ""
    echo "Select an zone:"
    select ZONE in "kids bedroom" "office" "server" "living room"; 
    do
        break
    done
fi

case $ZONE in
    "kids bedroom" )  export PORT=3978
                      export ZONE="1,2"
                      export NO_SCHEDULE="true"
                      export NO_SCAN="false";;
    office )          export PORT=3981
                      export ZONE="3,4"
                      export NO_SCHEDULE="true"
                      export NO_SCAN="false";;
    server )          export PORT=3978
                      export ZONE="0"
                      export NO_SCHEDULE="false"
                      export NO_SCAN="true"
                      echo "Creating certs..."
                      mkcert alfred_flowercare_data_collector_service
                      echo "Storing certs..."
                      vault write -address=$VAULT_URL secret/alfred_flowercare_data_collector_service/ssl_key data=@alfred_flowercare_data_collector_service-key.pem
                      vault write -address=$VAULT_URL secret/alfred_flowercare_data_collector_service/ssl_cert data=@alfred_flowercare_data_collector_service.pem
                      echo "Tidying up certs..."
                      rm *.pem;;
    "living room" )   export PORT=3981
                      export ZONE="5"
                      export NO_SCHEDULE="true"
                      export NO_SCAN="false";;
    *) echo "Invalid zone, exit setup"; exit;;
esac

export ZONE=$ZONE
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
            vault policy write -address=$VAULT_URL alfred_flowercare_data_collector_service policy.hcl
            vault write -address=$VAULT_URL auth/approle/role/alfred_flowercare_data_collector_service_role token_ttl=1m token_max_ttl=2m token_policies=alfred_flowercare_data_collector_service  

            echo "Storing config..."
            read -p "Linktap username: " LinkTapUser
            vault write -address=$VAULT_URL secret/alfred_flowercare_data_collector_service/LinkTapUser data=$LinkTapUser
            read -p "Linktap key: " LinkTapKey
            vault write -address=$VAULT_URL secret/alfred_flowercare_data_collector_service/LinkTapKey data=$LinkTapKey
            read -p "Linktap gateway id: " LinkTapGatewayID
            vault write -address=$VAULT_URL secret/alfred_flowercare_data_collector_service/LinkTapGatewayID data=$LinkTapGatewayID
            read -p "Linktap zone 1 id: " LinkTapZone1ID
            vault write -address=$VAULT_URL secret/alfred_flowercare_data_collector_service/LinkTapZone1ID data=$LinkTapZone1ID
            read -p "Linktap zone 2 id: " LinkTapZone2ID
            vault write -address=$VAULT_URL secret/alfred_flowercare_data_collector_service/LinkTapZone2ID data=$LinkTapZone2ID
            ;;
    No )    echo "Skipping vault setup"
            ;;
esac

echo "Creating access token..."
VAULES=$(vault read -address=$VAULT_URL -format=json auth/approle/role/alfred_flowercare_data_collector_service_role/role-id)
APP_ROLE_ID=$(echo $VAULES | jq .data.role_id)
export APP_ROLE_ID=${APP_ROLE_ID:1:${#APP_ROLE_ID}-2}
VAULES=$(vault write -f --format=json -address=$VAULT_URL auth/approle/role/alfred_flowercare_data_collector_service_role/secret-id)
APP_TOKEN=$(echo $VAULES | jq .data.secret_id)
export APP_TOKEN=${APP_TOKEN:1:${#APP_TOKEN}-2}

echo "Runing the container..."
echo $DOCKER_REGISTERY_PASSWORD | docker login $DOCKER_REGISTERY_URL -u $DOCKER_REGISTERY_USERNAME --password-stdin 

case $ZONE in
    "kids bedroom" )    docker-compose -f docker-compose-ncu.yml down
                        docker-compose -f docker-compose-ncu.yml pull
                        docker-compose -f docker-compose-ncu.yml up -d;;
    office )            docker-compose -f docker-compose-rpi.yml down
                        docker-compose -f docker-compose-rpi.yml pull
                        docker-compose -f docker-compose-rpi.yml up -d;;
    server )            docker-compose -f docker-compose.yml down
                        docker-compose -f docker-compose.yml pull
                        docker-compose -f docker-compose.yml up -d;;
    "living room" )     docker-compose -f docker-compose-rpi.yml down
                        docker-compose -f docker-compose-rpi.yml pull
                        docker-compose -f docker-compose-rpi.yml up -d;;
    *) echo "Invalid zone, exit setup"; exit;;
esac

docker logout

echo "Purge docker images..."
docker image prune -f

echo "Finished"
