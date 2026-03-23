#!/bin/bash
kind delete cluster
kind create cluster --config cluster2.yml
kubectl apply -f pvc.yaml
kubectl apply -f nginx1.yaml
kubectl apply -f nginx-service.yaml

kubectl apply -f nginx-update1.yaml

kubectl apply -f glpi-deploy.yaml

kubectl apply -f wordpress.yaml

#kubectl apply -f zabbix-deploy.yaml

#kubectl apply -f ocs.yaml -n ocs

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

kubectl apply -f dashboard-nodeport.yaml

kubectl create sa admin-user -n kubernetes-dashboard

kubectl create clusterrolebinding admin-user-binding --clusterrole=cluster-admin  --serviceaccount=kubernetes-dashboard:admin-user   ### Create admin-user account pour kubernetes-dashboard


kubectl -n kubernetes-dashboard apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: admin-user-token
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: "admin-user"
type: kubernetes.io/service-account-token
EOF



kubectl -n kubernetes-dashboard get secret admin-user-token -o jsonpath='{.data.token}' | base64 -d  ### Jeton Kubernetes-dashboard





#kubectl port-forward -n kubernetes-dashboard   service/kubernetes-dashboard 8443:443

#kubectl port-forward svc/nginx-svc 8080:80 &
