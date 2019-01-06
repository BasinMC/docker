FROM atlassian/bamboo-agent-base

USER root
RUN apt-get update && \
    apt-get install -y software-properties-common git git-lfs maven && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y openjdk-11-jdk-headless && \
    update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java && \
    apt-get clean

COPY entrypoint.sh ${BAMBOO_USER_HOME}/entrypoint.sh

RUN chmod +x ${BAMBOO_USER_HOME}/entrypoint.sh && \
    chown -R ${BAMBOO_USER} ${BAMBOO_USER_HOME}

USER ${BAMBOO_USER}
RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.jdk.JDK 11" /usr/lib/jvm/java-11-openjdk-amd64
RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.builder.mvn3.Maven 3.5" /usr/share/maven
RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.git.executable" /usr/bin/git

ENTRYPOINT ["./entrypoint.sh"]
