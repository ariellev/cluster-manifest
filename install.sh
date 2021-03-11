#!/bin/bash
kubectl create ns argocd || true
helm dep update argocd && helm upgrade my-argocd argocd -n argocd --install --set argo-cd.server.ingress.hosts[0]=argocd.${ingress_host}
kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n argocd --timeout=300s

helm template apps | kubectl apply -n argocd -f -

export environments=( dev staging production previews )
for e in "${environments[@]}" ; do
  kubectl create secret -n $e  \
  docker-registry jfrog \
  --docker-server=valerann.jfrog.io/docker \
  --docker-username=$docker_user \
  --docker-password=$docker_password ;
done
