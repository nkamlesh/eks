#!/bin/bash
curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version --short

# first, add the default repository, then update
helm repo add stable https://charts.helm.sh/stable
helm repo update

# configuring bash completion for helm
helm completion bash >> ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion
source <(helm completion bash)

# search helm repo for nginx
helm search repo nginx

# add a bitnami repo
helm repo add bitnami https://charts.bitnami.com/bitnami

# search inside the bitnami repo
helm search repo bitnami

# now search repo nginx
helm search repo nginx

# search inside bitnami repo for nginx
helm search repo bitnami/nginx

# install nginx using helm
helm install mywebserver bitnami/nginx

# get underlying serivces pods deployments
kubectl get svc,po,deploy

# You can inspect this Deployment object in more detail by running the following command:
kubectl describe deployment mywebserver

# To verify the Pod object was successfully deployed, we can run the following command:
kubectl get pods -l app.kubernetes.io/name=nginx

# To get the complete URL of this Service, run:
kubectl get service mywebserver-nginx -o wide


