This folder contains sample podspec files for playing with a k8s cluster

```bash
# install istio
istioctl install

```

```bash
# install istio sample app
kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/platform/kube/bookinfo.yaml

kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"

kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/networking/bookinfo-gateway.yaml

istioctl analyze

```

* Add the IP addresses of the nodes to the istio ingress gateway service
    * https://kubernetes.io/docs/concepts/services-networking/service/#external-ips
* This allows HA Proxy to talk to Istio
