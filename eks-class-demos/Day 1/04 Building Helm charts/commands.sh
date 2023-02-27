#!/bin/bash
echo "Cloning the service repositories"

echo "********************************************"
echo "Cloning frontend repository"
echo "********************************************"
git clone https://github.com/aws-containers/ecsdemo-frontend.git
sleep 2

echo "********************************************"
echo "Cloning backend nodejs repository"
echo "********************************************"
git clone https://github.com/aws-containers/ecsdemo-nodejs.git
sleep 2

echo "********************************************"
echo "Cloning backend crystal app repository"
echo "********************************************"
git clone https://github.com/aws-containers/ecsdemo-crystal.git
sleep 2


echo "********************************************"
echo "Creating new helm chart"
echo "********************************************"
helm create eksdemo
cd eksdemo

echo "********************************************"
echo "Cleaning up un-needed folders"
echo "********************************************"
rm -rf templates/
rm -rf Chart.yaml
rm -rf values.yaml

echo "********************************************"
echo "Creating a new helm chart"
echo "********************************************"
cat <<EoF > Chart.yaml
apiVersion: v2
name: eksdemo
description: A Helm chart for EKS Workshop Microservices application
version: 0.1.0
appVersion: 1.0
EoF

echo "********************************************"
echo "Create subfolders for each template type"
echo "********************************************"
mkdir -p templates/deployment
mkdir -p templates/service

echo "********************************************"
echo "Copy and rename frontend manifests"
echo "********************************************"
cp ../ecsdemo-frontend/kubernetes/deployment.yaml templates/deployment/frontend.yaml
cp ../ecsdemo-frontend/kubernetes/service.yaml templates/service/frontend.yaml

echo "********************************************"
echo "Copy and rename crystal manifests"
echo "********************************************"
cp ../ecsdemo-crystal/kubernetes/deployment.yaml templates/deployment/crystal.yaml
cp ../ecsdemo-crystal/kubernetes/service.yaml templates/service/crystal.yaml

echo "********************************************"
echo "Copy and rename nodejs manifests"
echo "********************************************"
cp ../ecsdemo-nodejs/kubernetes/deployment.yaml templates/deployment/nodejs.yaml
cp ../ecsdemo-nodejs/kubernetes/service.yaml templates/service/nodejs.yaml

echo "***************************************************"
echo "Replace hard-coded values with template directives"
echo "***************************************************"
sed -i 's/replicas: 1/replicas: {{ .Values.replicas }}/g' templates/deployment/frontend.yaml
sed -i 's/replicas: 1/replicas: {{ .Values.replicas }}/g' templates/deployment/crystal.yaml
sed -i 's/replicas: 1/replicas: {{ .Values.replicas }}/g' templates/deployment/nodejs.yaml

echo "********************************************"
echo "Creating the values.yaml file"
echo "********************************************"
cat <<EoF > values.yaml
# Default values for eksdemo.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

# Release-wide Values
replicas: 3
version: 'latest'

# Service Specific Values
nodejs:
  image: brentley/ecsdemo-nodejs
crystal:
  image: brentley/ecsdemo-crystal
frontend:
  image: brentley/ecsdemo-frontend
EoF

echo "********************************************"
echo "Check helm install and --dry-run"
echo "********************************************"
helm install --debug --dry-run workshop .

echo "********************************************"
echo "Installing helm"
echo "********************************************"
helm install workshop .

echo "********************************************"
echo "Test the service"
echo "********************************************"
kubectl get svc ecsdemo-frontend -o jsonpath="{.status.loadBalancer.ingress[*].hostname}"; echo