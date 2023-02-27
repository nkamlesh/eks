#!/bin/bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
sleep 10
kubectl proxy --port=8080 --address=0.0.0.0 --disable-filter=true &

# Install jq
yum -y install jq gettext bash-completion moreutils

# Access at below URL
# /api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

# cat ~/.kube/config file and run aws eks get-token for that cluster name!!
