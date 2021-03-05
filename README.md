# Cluster Manifests
A collection of kubernetes applications to showcase [Argo CD](https://argoproj.github.io/).

## Getting started
1. Install [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
2. Create a Kubernetes cluster for each staging environment
```
	environments=( dev staging production )

	# Create the clusters

	for e in "${environments[@]}"; do kind create cluster --config=kind.$e.yaml --name $e ; done

	# Delete the clusters
	for e in "${environments[@]}"; do kind delete --config=kind.$e.yaml --name $e ; done
```
3. Add DNS entries to `/etc/hosts`
```
	environments=( dev staging production )
	for e in "${environments[@]}"; do echo "127.0.0.1	$e.com www.$e.com" | sudo tee -a /etc/hosts ; done
```

4. Run a local reverse proxy
```
	export IP_ADDRESS=192.168.0.54
	sed "s/{{ IP_ADDRESS }}/$IP_ADDRESS/g" nginx.conf.template > nginx.conf
	docker run -v $(PWD)/nginx.conf:/etc/nginx/nginx.conf:ro --name rproxy -p 80:80 -d nginx
```
