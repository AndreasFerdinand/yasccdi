## DISCLAIMER
# Use at your own risk!
# If you use this file you accept the SAP DEVELOPER LICENSE AGREEMENT. See https://tools.hana.ondemand.com/#cloud for details

FROM centos:7

# Example: additional/sapjvm-8.1.096-linux-x64.rpm
ARG JAVA_DOWNLOAD_FILE

# Example: additional/sapcc-2.16.1-linux-x64.zip
ARG CC_DOWNLOAD_FILE


LABEL build_version="1.0"
LABEL maintainer="AndreasFerdinand"

VOLUME /opt/sap/scc/log

# lsof needed by cloudconnector
RUN \
    echo "*** installing runtime packages ***" && \
    yum -y install \
        unzip \
        curl \
        lsof && \
    yum clean all && \
    echo "*** determining external packages ***" && \
    if [ -z ${JAVA_DOWNLOAD_FILE+x} ]; then \
        JAVA_DOWNLOAD_FILE=$(curl -s https://tools.hana.ondemand.com/index.html | grep -oP -e '\"additional\/sapjvm-[0-9.]*-linux-x64.rpm\"' | tail -c +2 | head -c -2); \
    fi && \
    if [ -z ${CC_DOWNLOAD_FILE+x} ]; then \
        CC_DOWNLOAD_FILE=$(curl -s https://tools.hana.ondemand.com/index.html | grep -oP -e '\"additional\/sapcc-[0-9.]*-linux-x64.zip\"' | tail -c +2 | head -c -2); \
    fi && \
    echo "    Java: ${JAVA_DOWNLOAD_FILE}" && \
    echo "    CC: ${CC_DOWNLOAD_FILE}" && \
    echo "*** downloading external packages ***" && \
    JAVA_PACKAGE_FILE_NAME="/tmp/sapjava.rpm" && \
    CC_PACKAGE_FILE_NAME="/tmp/cloudconnector.zip" && \
    curl -s -o ${JAVA_PACKAGE_FILE_NAME} -H "Cookie: eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt; path=/;" "https://tools.hana.ondemand.com/${JAVA_DOWNLOAD_FILE}" && \
    curl -s -o ${CC_PACKAGE_FILE_NAME} -H "Cookie: eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt; path=/;" "https://tools.hana.ondemand.com/${CC_DOWNLOAD_FILE}" && \
    echo "*** installing external packages ***" && \
    rm -rf /tmp/cc && \
    mkdir -p /tmp/cc && \
    unzip -qq ${CC_PACKAGE_FILE_NAME} -d /tmp/cc && \
    CC_RPM_FILE_NAME=$(find /tmp/cc/ -name "com.sap.scc*.rpm") && \
    rpm -i ${JAVA_PACKAGE_FILE_NAME} && \
    rpm -i ${CC_RPM_FILE_NAME} && \
    rm -rf /tmp/*

ENV JAVA_HOME=/opt/sapjvm_8/

EXPOSE 8443/tcp
USER sccadmin
WORKDIR /opt/sap/scc

# see: https://help.sap.com/docs/connectivity/sap-btp-connectivity-cf/monitoring-apis#loiof6e7a7bc6af345d2a334c2427a31d294__Health
HEALTHCHECK CMD curl --fail --insecure https://localhost:8443/exposed?action=ping || exit 1

ENTRYPOINT ["/opt/sap/scc/go.sh"]
