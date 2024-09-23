# helm cli #
<br>

## Install helm - binary ##
<br>

**How to install**
- Url: https://helm.sh/docs/intro/install/
<br>

**Install**
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
rm get_helm.sh
```
<br>

**Check version**
```bash
/usr/local/bin/helm version
```
<br>

**Helm Completion**
- Url:  https://helm.sh/docs/helm/helm_completion/
<br>

```bash
vi ~/.bashrc
```

```
# -- HELM ---------------------------------------------------------------------
source <(helm completion bash)
# -----------------------------------------------------------------------------
```

```bash
source ~/.bashrc
```
<br>

**Test helm template by helm cli**
```bash
helm template helloworld helm_charts/helloworld -f helm_charts/helloworld/values.yaml
```
<br>

## Install helm - docker image ##
```bash
docker run -ti --rm \
           -u $(id -u):$(id -g)  \
           --pull always         \
           -v $(pwd):/apps       \
           -v ~/.kube/config:/.kube/config \
           -v ~/.helm:/.helm               \
           -v ~/.config/helm:/.config/helm \
           -v ~/.cache/helm/:/.cache/helm/ \
           -w /apps              \
           alpine/helm:latest    \
           version
```
<br>

**Test helm template by helm docker image**
```bash
docker run -ti --rm \
           -u $(id -u):$(id -g)  \
           --pull always         \
           -v $(pwd):/apps       \
           -v ~/.kube/config:/.kube/config \
           -v ~/.helm:/.helm               \
           -v ~/.config/helm:/.config/helm \
           -v ~/.cache/helm/:/.cache/helm/ \
           -w /apps              \
           alpine/helm:latest    \
           template helloworld helm_charts/helloworld -f helm_charts/helloworld/values.yaml
```
<br>
<br>

# Install helm charts - helloworld #
<br>

**Test helm template by helm cli**
```bash
helm template helloworld helm_charts/helloworld -f helm_charts/helloworld/values.yaml
```
<br>

**Test helm template by helm docker image**
```bash
docker run -ti --rm \
           -u $(id -u):$(id -g)  \
           --pull always         \
           -v $(pwd):/apps       \
           -v ~/.kube/config:/.kube/config \
           -v ~/.helm:/.helm               \
           -v ~/.config/helm:/.config/helm \
           -v ~/.cache/helm/:/.cache/helm/ \
           -w /apps              \
           alpine/helm:latest    \
           template helloworld helm_charts/helloworld -f helm_charts/helloworld/values.yaml
```
<br>


**Install/Upgrade helm chart by helm cli**
```bash
helm upgrade                \
  --install                 \
  --history-max 3           \
  --namespace uniqa-dev     \
  helloworld                \
  helm_charts/helloworld    \
  -f helm_charts/helloworld/values.yaml
```
<br>

**Install/Upgrade helm chart by docker image**
```bash
docker run -ti --rm \
           -u $(id -u):$(id -g)  \
           --pull always         \
           -v $(pwd):/apps       \
           -v ~/.kube/config:/.kube/config \
           -v ~/.helm:/.helm               \
           -v ~/.config/helm:/.config/helm \
           -v ~/.cache/helm/:/.cache/helm/ \
           -w /apps              \
           alpine/helm:latest    \
           upgrade                    \
            --install                 \
            --history-max 3           \
            --namespace uniqa-dev     \
            helloworld                \
            helm_charts/helloworld    \
            -f helm_charts/helloworld/values.yaml

```
<br>



# Install ingress haproxy #
<br>

**Add and update helm chart for haproxy**
```bash
helm repo add haproxytech https://haproxytech.github.io/helm-charts
helm repo update
```
<br>

**Create a namespace**
```bash
kubectl create ns haproxy
```
<br>

**Install haproxy ingress controller**
```bash
helm upgrade --install --namespace haproxy --history-max 3 --version 1.40.1 haproxy haproxytech/kubernetes-ingress -f helm_charts/haproxy/values.yaml
```
```
Release "haproxy" does not exist. Installing it now.
NAME: haproxy
LAST DEPLOYED: Sun Sep 22 21:43:01 2024
NAMESPACE: haproxy
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
HAProxy Kubernetes Ingress Controller has been successfully installed.

Controller image deployed is: "haproxytech/kubernetes-ingress:3.0.1".
Your controller is of a "Deployment" kind. Your controller service is running as a "LoadBalancer" type.
RBAC authorization is enabled.
Controller ingress.class is set to "haproxy" so make sure to use same annotation for
Ingress resource.

Service ports mapped are:
  - name: http
    containerPort: 8080
    protocol: TCP
  - name: https
    containerPort: 8443
    protocol: TCP
  - name: stat
    containerPort: 1024
    protocol: TCP
  - name: quic
    containerPort: 8443
    protocol: UDP

Node IP can be found with:
  $ kubectl --namespace haproxy get nodes -o jsonpath="{.items[0].status.addresses[1].address}"

The following ingress resource routes traffic to pods that match the following:
  * service name: web
  * client's Host header: webdemo.com
  * path begins with /

  ---
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: web-ingress
    namespace: default
    annotations:
      ingress.class: "haproxy"
  spec:
    rules:
    - host: webdemo.com
      http:
        paths:
        - path: /
          backend:
            serviceName: web
            servicePort: 80

In case that you are using multi-ingress controller environment, make sure to use ingress.class annotation and match it
with helm chart option controller.ingressClass.

For more examples and up to date documentation, please visit:
  * Helm chart documentation: https://github.com/haproxytech/helm-charts/tree/main/kubernetes-ingress
  * Controller documentation: https://www.haproxy.com/documentation/kubernetes/latest/
  * Annotation reference: https://github.com/haproxytech/kubernetes-ingress/tree/master/documentation
  * Image parameters reference: https://github.com/haproxytech/kubernetes-ingress/blob/master/documentation/controller.md
```
<br>

**Check**
```bash
kubectl -n haproxy get all
```
