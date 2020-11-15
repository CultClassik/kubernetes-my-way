#!/bin/bash
vagrant destroy --force
docker kill haproxy-k8s-api && docker rm haproxy-k8s-api
rm -rf ~/k8s-conf