#!/bin/bash
terraform init -upgrade
terraform apply --auto-approve
sleep 10
aws eks --profile dvettom  --region eu-west-1 update-kubeconfig --name eks-auto-demo
# aws eks --profile labs  --region eu-west-1 update-kubeconfig --name eks-auto-demo
