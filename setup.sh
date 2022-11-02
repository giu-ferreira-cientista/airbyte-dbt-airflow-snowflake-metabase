#!/usr/bin/env bash
up() {
  echo "Starting Airbyte..."
  docker-compose -f docker-compose-airbyte.yaml down -v
  docker-compose -f docker-compose-airbyte.yaml up -d

  echo "Starting Airflow..."
  docker-compose -f docker-compose-airflow.yaml down -v
  mkdir -p ./dags ./logs ./plugins
  echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" >> .env
  docker-compose -f docker-compose-airflow.yaml up airflow-init
  docker-compose -f docker-compose-airflow.yaml up -d
    
  echo "Starting Metabase..."
  cd metabase
  docker pull metabase/metabase:latest
  docker run -d -p 3000:3000 --name metabase metabase/metabase
  cd ..
  echo "Access Metabase at http://localhost:3000 and set up a connection with Snowflake."

  echo "Access Airbyte at http://localhost:8000 and set up the connections."
  
  echo "Access Airflow at http://localhost:8080 to kick off your Airbyte sync DAG."  
}

config() {
  echo "Connecting Airflow with Airbyte..."
  echo "Enter your Airbyte Epidemiology connection ID: "
  read epidemiology_connection_id

  echo "Enter your Airbyte Economy connection ID: "
  read economy_connection_id

  echo "Enter your Airbyte Demographics connection ID: "
  read demographics_connection_id

  echo "Enter your Airbyte Index connection ID: "
  read index_connection_id

  # Set connection IDs for DAG.
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_EPIDEMIOLOGY_CONNECTION_ID' "$epidemiology_connection_id"
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_ECONOMY_CONNECTION_ID' "$economy_connection_id"
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_DEMOGRAPHICS_CONNECTION_ID' "$demographics_connection_id"
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_INDEX_CONNECTION_ID' "$index_connection_id"

  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow connections add 'airbyte_example' --conn-uri 'airbyte://host.docker.internal:8000'

}


down() {
  echo "Stopping Airbyte..."
  docker-compose -f docker-compose-airbyte.yaml down -v
  echo "Stopping Airflow..."
  docker-compose -f docker-compose-airflow.yaml down -v
  echo "Stopping Metabase..."
  docker stop metabase
}

case $1 in
  up)
    up
    ;;
  down)
    down
    ;;
  *)
    echo "Usage: $0 {up|down}"
    ;;
esac
