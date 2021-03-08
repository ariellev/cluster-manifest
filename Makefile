.PHONY: toolchain-mac create-cluster destroy-cluster helm-repos install get-argocd-password

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

toolchain-mac:
	@brew install kind kubectx helm minikube

create-cluster:
	@kind create cluster --name ${name} --config=kind.yaml

destroy-cluster:
	@kind delete cluster --name ${name}

helm-repos:
	@helm repo add argo https://argoproj.github.io/argo-helm

install:
	@./install.sh

get-argocd-password:
	@kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

proxy-argocd-ui:
	kubectl port-forward svc/argocd-server -n argocd 8080:80
