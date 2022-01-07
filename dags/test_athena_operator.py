from airflow import DAG
from datetime import datetime, timedelta
from airflow.contrib.operators.aws_athena_operator import AWSAthenaOperator

# CONFS
conf = {
    "dev": {
        "AWS_IAM_ARN": "AWS ROLE"
    }
}

env_vars = {
    "APP": "athena-test",
    ##add specific variables
    **conf['dev'],
}

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime.now() - timedelta(minutes=10),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    "annotations": {"iam.amazonaws.com/role": env_vars["AWS_IAM_ARN"]}
}

dag = DAG(
    'test_athena',
    default_args=default_args,
    schedule_interval=timedelta(minutes=10),
    catchup=False)

run_query = AWSAthenaOperator(
    task_id='run_query',
    query='My Awesome query',
    aws_conn_id='aws_connection',
    output_location='S3 path output location',
    database='myDatabase',
    workgroup='myworkgroup',
    retries=4,
    retry_delay=timedelta(seconds=10),
    dag=dag
)
