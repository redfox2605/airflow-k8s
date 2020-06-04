# -*- coding: utf-8 -*-
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
"""
This is an example dag for using the Kubernetes Executor.
"""
import os

import airflow
from airflow.models import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator
from airflow.operators.bash_operator import BashOperator

args = {
    'owner': 'Airflow',
    'start_date': airflow.utils.dates.days_ago(2)
}

with DAG(
    dag_id='schduler_log_clean',
    default_args=args,
    schedule_interval='0 0 * * *'
) as dag:

    tolerations = [{
        'key': 'dedicated',
        'operator': 'Equal',
        'value': 'airflow'
    }]

    def print_stuff():  # pylint: disable=missing-docstring
        print("hello world!")

    one_task = PythonOperator(
        task_id="one_task",
        python_callable=print_stuff
    )

    # Use the zip binary, which is only found in this special docker image
    two_task = BashOperator(
        task_id='two_task',
        bash_command='find /usr/local/airflow/logs -type f -mtime +2 -exec rm -f {} \;')

    [one_task, two_task]
