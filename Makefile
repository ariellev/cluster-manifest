.PHONY: ssh toolchain-mac create-cluster-kind destroy-cluster-kind create-cluster-minikube destroy-cluster-minikube helm-repos install get-argocd-password

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

toolchain-mac:
	@brew install kind kubectx helm minikube gomplate argocd argo

create-cluster-kind:
	@kind create cluster --name ${name} --config=kind.yaml
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
	sleep 10
	kubectl wait --namespace ingress-nginx \
	  --for=condition=ready pod \
	  --selector=app.kubernetes.io/component=controller \
	  --timeout=90s

destroy-cluster-kind:
	@kind delete cluster --name ${name}

create-cluster-minikube:
	@minikube start --vm=true --addons=ingress
	@minikube addons enable ingress
	kubectl --namespace kube-system wait \
	    --for=condition=ready pod \
	    --selector=app.kubernetes.io/component=controller \
	    --timeout=120s

destroy-cluster-minikube:
	@minikube delete

helm-repos:
	@helm repo add argo https://argoproj.github.io/argo-helm
	@helm repo add hashicorp https://helm.releases.hashicorp.com

install:
	@./install.sh

get-argocd-password:
	@kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

proxy-argocd-ui:
	kubectl port-forward svc/argocd-server -n argocd 8080:80

proxy-vault:
	kubectl port-forward svc/admin-root-vault -n admin 8200:8200

ssh:
	kubectl exec --stdin --tty ${pod} -n ${ns} -- /bin/bash

argo-log:
	argo -n argo logs @latest

argo-get:
	argo -n argo get @latest

proxy-argo-event-source:
	kubectl -n argo-events port-forward service/webhook-eventsource-svc 12000:12000	
