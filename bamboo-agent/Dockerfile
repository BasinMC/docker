FROM atlassian/bamboo-agent-base

ENV GRADLE_4_10_VERSION 4.10.3
ENV GRADLE_5_1_VERSION 5.1

USER root
RUN apt-get update && \
    apt-get install -y software-properties-common git git-lfs maven curl unzip && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y openjdk-11-jdk-headless && \
    update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java && \
    curl -Lo /tmp/gradle-5.1.zip https://services.gradle.org/distributions/gradle-${GRADLE_5_1_VERSION}-bin.zip && \
    curl -Lo /tmp/gradle-4.10.zip https://services.gradle.org/distributions/gradle-${GRADLE_4_10_VERSION}-bin.zip && \
    mkdir -p /opt/gradle && \
    unzip -d /opt/gradle /tmp/gradle-5.1.zip && \
    unzip -d /opt/gradle /tmp/gradle-4.10.zip && \
    apt-get remove -y curl unzip && \
    apt-get clean

COPY entrypoint.sh ${BAMBOO_USER_HOME}/entrypoint.sh

RUN chmod +x ${BAMBOO_USER_HOME}/entrypoint.sh && \
    chown -R ${BAMBOO_USER} ${BAMBOO_USER_HOME}

USER ${BAMBOO_USER}
RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.jdk.JDK 11" /usr/lib/jvm/java-11-openjdk-amd64
RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.builder.mvn3.Maven 3.5" /usr/share/maven
RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.builder.gradle.Gradle 4.10" /opt/gradle/gradle-${GRADLE_4_10_VERSION}/bin/gradle
RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.builder.gradle.Gradle 5.1" /opt/gradle/gradle-${GRADLE_5_1_VERSION}/bin/gradle
RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.git.executable" /usr/bin/git

ENTRYPOINT ["./entrypoint.sh"]
