# kubectl #
<br>

## Install kubectl - binary ##
<br>

**How to install**
- Url: https://kubernetes.io/docs/tasks/tools/

**Install**
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv -v kubectl /usr/local/bin/

/usr/local/bin/kubectl version
```
```
Client Version: v1.31.1
Kustomize Version: v5.4.2
Server Version: v1.30.3-gke.1639000
```
<br>

**Kubectl Completion**
- Url: https://kubernetes.io/docs/reference/kubectl/generated/kubectl_completion/
<br>


## Install kubectl - docker ##
<br>

**Docker image**
- Url: https://hub.docker.com/r/bitnami/kubectl

**Run**
```bash
docker run --rm --name kubectl bitnami/kubectl:latest version
```
```
Client Version: v1.31.1
Kustomize Version: v5.4.2
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```
<br>


**Run with mount**
```bash
id
docker run \
  --rm \
  --name kubectl \
  --user 1000:1000 \
  --network=host \
  -v /home/ehus/.kube/config:/.kube/config \
  bitnami/kubectl:latest \
  version
```
<br>
<br>

# Login to AKS #
<br>

**Get-credentials**
```bash
# -- Backup current config
mv -v   ~/.kube/config ~/.kube/config_2

# -- Get-credentials from AKS
az aks get-credentials --resource-group uniqa-rg --name uniqa-aks
```
```
Merged "uniqa-aks" as current context in /home/ehus/.kube/config
```
<br>

**Test #1 | get pods via kubectl command**
```bash
kubectl get pods -A
```
<br>

**Test #2 | get pods via docker kubectl image**
```bash
docker run \
  --rm \
  --name kubectl \
  --user 1000:1000 \
  --network=host \
  -v /home/ehus/.kube/config:/.kube/config \
  bitnami/kubectl:latest \
  get pods -A
```
<br>

**~/.kube/config**
```bash
cat ~/.kube/config
```
<br>
