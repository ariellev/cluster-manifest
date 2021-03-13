# Cluster Manifests
A collection of Kubernetes applications to showcase [Argo CD](https://argoproj.github.io/).

### TL;DR
```
# comment2
> make toolchain-mac
> make create-cluster-kind

> export docker_user=...
> export docker_password=...
> export ingress_host=... # e.g. 192.168.5.90.xip.io
> make helm-repos install

# In a separate shell
> minikube tunnel

# Add DNS entries to `/etc/hosts`

> export environments=( dev staging production )
> for e in "${environments[@]}"; do                   \
    echo "127.0.0.1  demo.$e.com $e.com www.$e.com" | \
    sudo tee -a /etc/hosts ;                          \
  done
```
