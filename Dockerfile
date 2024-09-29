# -- Latest versions -----------------------------------------------------------
# DockerHub: https://hub.docker.com/_/rockylinux

# Jenkins latest version: https://get.jenkins.io/war-stable/


# -- Storage ------------------------------------------------------------------
# sudo mkdir -vp           /opt/uniqa/jenkins
# sudo chown -v  1000:1000 /opt/uniqa/jenkins

# -----------------------------------------------------------------------------


# ---Build --------------------------------------
# docker buildx build --no-cache -t uniqajenkins --build-arg a_TZ="Europe/Sarajevo" -f Dockerfile .
# docker buildx build            -t uniqajenkins --build-arg a_TZ="Europe/Sarajevo" -f Dockerfile .

# --- List Docker Images ------------------------
# docker images
# docker image ls

# --- Docker images prune -----------------------
# docker image prune -f


# --- Delete "Exited" containers ----------------
# docker rm -v $(docker ps -a -q --filter "status=exited")


# --- Recreate container -------------------------
# docker-compose down
# docker-compose up -d 

# --- Exec as root ------------------------------
# docker exec -it --user root uniqajenkins /bin/bash

# --- Logs --------------------------------------
# docker-compose logs -f <service_name>
# docker logs <container_name>



FROM docker.io/rockylinux:9-minimal

# == ARG =============================================================================================================
# ----- Configuration --------------------------------------------------------------
# Jenkins latest version: https://get.jenkins.io/war-stable/
ARG a_jenkins_version="2.462.2"

# -- Group/User 
ARG a_user_name="jenkins"
ARG a_user_UID="1000"
ARG a_group_name="${a_user_name}"
ARG a_group_GID="${a_user_UID}"
ARG a_group_docker_GID="138"

# -- Time-Zone
ARG a_TZ=Europe/Sarajevo

# -- Default Java
ARG a_JAVA_HOME='/usr/lib/jvm/java-21'
# ==================================================================================================================

# == ENV =============================================================================================================
ENV   TERM=xterm                                     \
      TZ=${a_TZ}                                     \
# --- JAVA
      JAVA_HOME=${a_JAVA_HOME}                       \
# --- Jenkins
      JENKINS_HOME="/home/jenkins"                                                \
      JENKINS_UC="https://updates.jenkins.io"                                     \
      JENKINS_UC_EXPERIMENTAL="https://updates.jenkins.io/experimental"           \
      JENKINS_INCREMENTALS_REPO_MIRROR="https://repo.jenkins-ci.org/incrementals" \
# --- $PATH
      PATH="$PATH:/usr/libexec/docker/cli-plugins"  \
      Z_ENV=""
# ====================================================================================================================

# == LABEL ===========================================================================================================
LABEL maintainer="Edin Husejnefendic<lihnjo@gmail.com>"   \
      a_maintainer="Edin Husejnefendic<lihnjo@gmail.com>" \
      a_tz="${a_TZ}"                                      \
      a_os="Rocky"                                        \
      a_os_version_major="9"                              \
      a_app_jenkins="jenkins ${a_jenkins_version_LTS}"

# ====================================================================================================================

# == LINUX ===========================================================================================================
RUN  groupadd -g ${a_group_GID}         ${a_group_name}  \
  && useradd -c "Jenkins" --system -s /bin/bash -u ${a_user_UID} -g ${a_user_name} --home-dir /home/jenkins ${a_group_name} \
  && usermod -p '$6$6WZfZAbApbb631IL$1w2Bs1rdK8yUVnolN551eMvHhHU5aUZotZy7HCEgXSQfLCpLsQ0YM6MfT5sM34jN/TwZbyO2WTrULj6Yw5HMB.' root    \
  && usermod -p '$6$6WZfZAbApbb631IL$1w2Bs1rdK8yUVnolN551eMvHhHU5aUZotZy7HCEgXSQfLCpLsQ0YM6MfT5sM34jN/TwZbyO2WTrULj6Yw5HMB.' ${a_group_name} \
# --- dnf installation dependencies -----------------------
# && microdnf update -y  \
  && microdnf install -y \
       bash              \
       bash-completion   \
       bzip2             \
       ca-certificates   \
       createrepo        \
       curl              \
       dnf               \
       dnf-plugins-core  \
       git               \
       git-lfs           \
       iputils           \
       jq                \
       nmap-ncat         \
       procps-ng         \
       pbzip2            \
       rpm-build         \
       rsync             \
       openssh-clients   \
       sudo              \
       tree              \
       tzdata            \
       unzip             \
       zip               \
       wget              \
  && ln -fs /usr/share/zoneinfo/${a_TZ} /etc/localtime \
  && echo ""              >> /etc/environment \
  && echo "# -- UNIQA ------------------------------------------------------------------" >> /etc/environment \
  && echo "TZ=${a_TZ}"   >> /etc/environment

# ====================================================================================================================

# == Docker ==========================================================================================================
RUN  groupadd -g ${a_group_docker_GID} docker \
  && usermod -G docker -a ${a_user_name}                \
  && usermod -a -G ${a_group_docker_GID} ${a_user_name} \
  && dnf config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
  && dnf install        -y docker-ce             \
                           docker-ce-cli         \
                           docker-buildx-plugin  \
                           docker-compose-plugin \
                           docker-scan-plugin    \
                           containerd.io         \
                           iptables-utils        \
  && wget https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -O /etc/bash_completion.d/docker \
  && echo "jenkins ALL=(ALL:ALL) NOPASSWD: /usr/bin/dockerd" > /etc/sudoers.d/jenkins_dockerd \
  && chmod -v 400 /etc/sudoers.d/jenkins_dockerd \
  && echo 'export PATH=$PATH:/usr/libexec/docker/cli-plugins' >> /etc/profile.d/docker.sh
# ====================================================================================================================


# == JAVA ============================================================================================================
RUN  dnf install -y             \
       java-1.8.0-openjdk       \
       java-1.8.0-openjdk-devel \
       java-11-openjdk          \
       java-11-openjdk-devel    \
       java-17-openjdk          \
       java-17-openjdk-devel    \
       java-21-openjdk          \
       java-21-openjdk-devel    \
#  && dnf install -y https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.rpm \
  && alternatives --set java  java-21-openjdk.x86_64 \
  && alternatives --set javac java-21-openjdk.x86_64 \
  && echo "export JAVA_HOME=${a_JAVA_HOME}"   > /etc/profile.d/java.sh  \
  && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile.d/java.sh
# ====================================================================================================================

# == Jenkins =========================================================================================================
RUN  mkdir -vp /opt/uniqa/jenkins/tmp \
  && wget "https://get.jenkins.io/war-stable/${a_jenkins_version}/jenkins.war" -O    /opt/uniqa/jenkins/jenkins.war         \
  && echo "Jenkins v${a_jenkins_version_LTS}"                                      > /opt/uniqa/jenkins/jenkins_version.txt \
  && chown -vR ${a_user_name}:${a_group_name}   /opt/uniqa/jenkins/                                                         \
  && echo 'export JENKINS_HOME="/home/jenkins"'                                                 > /etc/profile.d/jenkins.sh \
  && echo 'export JENKINS_UC="https://updates.jenkins.io"'                                     >> /etc/profile.d/jenkins.sh \
  && echo 'export JENKINS_UC_EXPERIMENTAL="https://updates.jenkins.io/experimental"'           >> /etc/profile.d/jenkins.sh \
  && echo 'export JENKINS_INCREMENTALS_REPO_MIRROR="https://repo.jenkins-ci.org/incrementals"' >> /etc/profile.d/jenkins.sh
# ====================================================================================================================


# == Security updates & Clean UP =====================================================================================
RUN  dnf check-update --security --bugfix || true;  \
     dnf update -y    --security --bugfix           \
  && dnf -y clean all                               \
  && rm -rf /var/cache/yum/*                        \
  && rm -rf /var/cache/dnf/*                        \
  && rm -rf /tmp/*
# ====================================================================================================================

USER       jenkins
EXPOSE     8080
WORKDIR    /home/jenkins

#CMD ["tail", "-f", "/dev/null"]
ENTRYPOINT ["bash", "-c", "newgrp docker; /usr/bin/nohup /usr/bin/sudo /usr/bin/dockerd & java -Djava.io.tmpdir=${JENKINS_HOME}/tmp -Duser.timezone=${TZ}o -jar /opt/uniqa/jenkins/jenkins.war --prefix=/ "]
