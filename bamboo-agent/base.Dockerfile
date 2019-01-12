FROM atlassian/bamboo-agent-base

ENV GRADLE_4_10_VERSION 4.10.3
ENV GRADLE_5_1_VERSION 5.1
ENV MAVEN_3_VERSION 3.6.0

USER root
RUN apt-get update && \
    apt-get install -y git git-lfs curl unzip zip && \
    curl -Lo /tmp/maven-3.zip https://www-eu.apache.org/dist/maven/maven-3/${MAVEN_3_VERSION}/binaries/apache-maven-${MAVEN_3_VERSION}-bin.zip && \
    curl -Lo /tmp/gradle-5.1.zip https://services.gradle.org/distributions/gradle-${GRADLE_5_1_VERSION}-bin.zip && \
    curl -Lo /tmp/gradle-4.10.zip https://services.gradle.org/distributions/gradle-${GRADLE_4_10_VERSION}-bin.zip && \
    curl -Lo /usr/bin/mc https://dl.minio.io/client/mc/release/linux-amd64/mc && \
    mkdir -p /opt/maven && \
    unzip -d /opt/maven /tmp/maven-3.zip && \
    mkdir -p /opt/gradle && \
    unzip -d /opt/gradle /tmp/gradle-5.1.zip && \
    unzip -d /opt/gradle /tmp/gradle-4.10.zip && \
    apt-get remove -y curl && \
    rm /tmp/maven-3.zip && \
    rm /tmp/gradle-5.1.zip && \
    rm /tmp/gradle-4.10.zip && \
    mkdir -p  ${BAMBOO_USER_HOME}/.gradle/init.d/ && \
    apt-get clean

COPY entrypoint.sh ${BAMBOO_USER_HOME}/entrypoint.sh
COPY gradle.properties ${BAMBOO_USER_HOME}/.gradle/gradle.properties
COPY init.gradle ${BAMBOO_USER_HOME}/.gradle/init.d/basin.gradle

RUN chmod +x ${BAMBOO_USER_HOME}/entrypoint.sh && \
    chown -R ${BAMBOO_USER} ${BAMBOO_USER_HOME}

USER ${BAMBOO_USER}
RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.builder.mvn3.Maven 3.x" /opt/maven/apache-maven-${MAVEN_3_VERSION} && \
    ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.builder.mvn3.Maven ${MAVEN_3_VERSION}" /opt/maven/apache-maven-${MAVEN_3_VERSION} && \
    ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.builder.gradle.Gradle 4.10" /opt/gradle/gradle-${GRADLE_4_10_VERSION}/bin/gradle && \
    ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.builder.gradle.Gradle 5.1" /opt/gradle/gradle-${GRADLE_5_1_VERSION}/bin/gradle && \
    ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.git.executable" /usr/bin/git && \
    ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.builder.command.Minio Client" /usr/bin/mc && \
    ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.builder.command.unzip" /usr/bin/unzip && \
    ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.builder.command.zip" /usr/bin/zip

ENTRYPOINT ["./entrypoint.sh"]
