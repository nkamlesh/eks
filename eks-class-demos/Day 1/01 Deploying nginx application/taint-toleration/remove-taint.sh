#!/bin/bash
echo  "Enter node name:"
read node_name
kubectl taint node $node_name nonginx=true:NoSchedule-
sleep 10
echo "Taint Removed"
echo "verify by running command:  kubectl get nodes -o json | jq '.items[].spec'"
