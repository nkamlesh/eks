#!/bin/bash
kubectl version
sleep 10
aws eks list-clusters
sleep 10
echo "Enter the name of the cluster:"
read cluster_name
echo "Enter the region of the cluster:"
read region_name
aws eks update-kubeconfig --name $cluster_name --region $region_name
sleep 10
kubectl version
echo "You can cat ~/.kube/config now!"