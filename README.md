# Cluster Manifests
A collection of Kubernetes applications to showcase [Argo CD](https://argoproj.github.io/).

### TL;DR
```
> make toolchain-mac
> minikube start
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
