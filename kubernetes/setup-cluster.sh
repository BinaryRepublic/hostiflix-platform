#!/usr/bin/env bash

gcloud container clusters get-credentials production --zone europe-west3-a --project project-cloud-231013

echo "If you are using cloudflare make sure to select the SSL plan 'flexible' during setup"
read -p "Press enter to continue"

kubectl apply -f serviceaccounts/tiller.yml
kubectl apply -f clusterrolebindings/tiller.yml

helm init --service-account tiller

sleep 20

helm repo update

helm install --name cert-manager --version v0.5.2 --namespace kube-system stable/cert-manager

kubectl apply -f clusterissuers/letsencrypt-staging.yml

helm install stable/nginx-ingress --name nginx-ingress --set rbac.create=true

sleep 60

LOAD_BALANCER_IP=
while [ -z "$LOAD_BALANCER_IP" ]; do
    LOAD_BALANCER_IP=$(kubectl get service nginx-ingress-controller -o=custom-columns=:.status.loadBalancer.ingress[*].ip)
    sleep 15
    echo "Waiting for load balancer..."
done

echo "Load balancer IP is $LOAD_BALANCER_IP"