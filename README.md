# Airflow on Kubernetes

This is a project to a airflow app on Kubernetes. More information [here](https://airflow.apache.org/kubernetes.html).

The application uses the airflow helm chart [here](https://github.com/helm/charts/tree/master/stable/airflow).



## Environment variables
The following variables are needed for the deployment 
```
FERTNET_KEY_DEV
FERTNET_KEY_PROD
SNOWFLAKE_USERNAME
SNOWFLAKE_PASSWORD
```


## Deploy dags

Following commands deploys dags in airflow.

The following command will deploy all the scripts in the dags directory 
```shell script
task airflow.dags.deploy
```

## deploy on EKS Kubernetes cluster
For the first time you need to deploy manually the service account and rolebindings:
```shell script
#First login into your k8s namespace
kubectl -n $NAMESPACE apply -f k8s/rolebinding.yaml
```
To deploy airflow 
```shell script
ENV=dev KUBE_CONTEXT=dev NAMESPACE=default task airflow.deploy
```

## Terraform

Terraform part must be adapted to the necessities of the user. It includes
the resource definition to be able to use [aws-smtp-relay](https://github.com/loopingz/aws-smtp-relay)