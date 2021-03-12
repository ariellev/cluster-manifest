#!/bin/bash
export charts=( argocd argo-events argo)
for c in "${charts[@]}" ; do
  kubectl create ns $c
  helm dep update $c && helm upgrade my-$c $c -n $c --install --set $c.server.ingress.hosts[0]=${c}.${ingress_host}
done

# helm dep update argo-cd && helm upgrade my-argo-cd argo-cd -n argocd --install --set argo-cd.server.ingress.hosts[0]=argocd.${ingress_host}
# helm dep update argo-events && helm upgrade my-argo-events argo-events -n argo-events --install

kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n argocd --timeout=300s

helm template apps | kubectl apply -n argocd -f -

export namespaces=( dev staging production previews )
namespaces+=( "${charts[@]}" )
for n in "${namespaces[@]}" ; do
  kubectl create secret -n $n  \
  docker-registry jfrog \
  --docker-server=valerann.jfrog.io/docker \
  --docker-username=$docker_user \
  --docker-password=$docker_password ;
done
