# airbyte-dbt-airflow-snowflake-metabase
Repositório para armazenar os artefatos do Pipeline utilizando Modern Data Stack com AirByte + DBT + Airflow + SnowFlake + Metabase

- Criar conta no SnowFlake

- Criar conta no DBT

- Sobe o ambiente do Pipeline
    $ ./setup.sh up

- Copia o conection id do airbyte no terminal pra terminar a instalacao do ambiente e criar a dag no airflow

- Entra no Airbyte na porta 8000
- Seta a conexao com a Google planilha usando as credenciais e o id da planilha
- Seta a conexao com o Big Query usando as credenciais e o id do projeto e o id do dataset
- Sync Manual e Overwrite dos dados 
- Configura ou altera a Transfomation apontando pro github do dbt (https://github.com/giu-ferreira-cientista/transformations)
- Volta no airflow e da start na dag trigger_airbyte_dbt_job
- Checa no Airbyte se ta rodando a Sync
- Checa no SnowFlake se subiu o dataset corretamente 

- Metabase sobe na porta 3000
- Airflow sobe na porta 8080


Arquivos Chave:

- docker-compose-airflow.yaml
- docker-compose-airbyte.yaml
- setup.sh
- dags/dag_airbyte_dbt.py