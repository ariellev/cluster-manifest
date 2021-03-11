#!/bin/bash
# input: tag, repo, ingress_host
export pr_id=1

export repo=demo
export app_id=pr-$pr_id-$repo
export tag=production
export hostname=$app_id.$ingress_host

cat preview.template.yaml \
    | gomplate \
    | tee manifests/previews/templates/$app_id.yaml
