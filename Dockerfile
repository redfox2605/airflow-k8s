ARG AIRFLOW_VERSION=2.2.0
FROM apache/airflow:${AIRFLOW_VERSION}-python3.8

USER root
ARG AIRFLOW_USER_HOME=/opt/airflow
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}
#ENV GUNICORN_CMD_ARGS --log-level ERROR
ENV HELM_VERSION=3.3.4
ENV KUBECTL_VERSION v1.18.5

RUN apt-get update &&  apt-get install -y  procps \
netcat \
htop

RUN apt-get update -qq && apt-get -qqy install gcc libssl-dev git

# install Taskfile
RUN curl -sL https://taskfile.dev/install.sh | sh \
	&& mv bin/task /usr/local/bin/task

# install KUBECTL
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
	&& chmod +x ./kubectl \
	&& mv ./kubectl /usr/local/bin/kubectl

# install Helm v3
RUN curl -Lo helm-v${HELM_VERSION}-linux-amd64.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && sudo mv linux-amd64/helm /usr/local/bin/helm \
    && helm version

WORKDIR ${AIRFLOW_HOME}
RUN mkdir $AIRFLOW_HOME/.kube/


COPY scripts/health_check.py /tmp/health_check.py

COPY requirements.txt requirements.txt

RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install apache-airflow[kubernetes,aws,snowflake]==${AIRFLOW_VERSION}

COPY scripts/entrypoint.sh /entrypoint.sh
COPY dags $AIRFLOW_HOME/dags

ENTRYPOINT ["/entrypoint.sh"]
