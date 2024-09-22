# helm #
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



