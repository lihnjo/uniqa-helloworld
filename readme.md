# JENKINS #
<br>

**Docker build image**
```bash
docker buildx build \
       -t uniqajenkins \
       --build-arg a_TZ="Europe/Sarajevo" \
       -f Dockerfile .
```
<br>

**List images**
```bash
# docker images
docker image ls | grep -E "REPOSITORY|uniqajenkins"
```
```
REPOSITORY                     TAG                   IMAGE ID       CREATED        SIZE
uniqajenkins                   latest                99ca564a39b9   6 days ago     2.16GB
```
<br>

**Create persistance directories**
```bash
# --1st time
mkdir -vp /opt/uniqa/jenkins/tmp
```
<br>


**Check syntax**
```bash
docker-compose -f docker-compose.yml config
```
<br>


**Check syntax**
```bash
docker-compose -f docker-compose.yml up
```
<br>

- [http://127.0.0.1:8080](http://127.0.0.1:8080)


---
<br>


**OPTIONAL: Restart commands**
```bash
# -- Restart
docker compose restart jenkins

-- Build and Restart
# docker-compose down; docker-compose up -d
```
<br>


---
<br>

