#!/bin/bash

source /etc/profile.d/confluence

echo "Confluence Installation: '${CONF_INSTALL}'"
echo "Confluence Home: '${CONF_HOME}'"

chmod -R 700            "${CONF_HOME}" ${CONF_INSTALL}/{conf,temp,logs,work}
chown -R daemon:daemon  "${CONF_HOME}" ${CONF_INSTALL}/{conf,temp,logs,work}
mkdir -p                "${CONF_INSTALL}/conf"

echo -e                 "confluence.home=$CONF_HOME" > "${CONF_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties"

xmlstarlet              ed --inplace \
        --delete               "Server/@debug" \
        --delete               "Server/Service/Connector/@debug" \
        --delete               "Server/Service/Connector/@useURIValidationHack" \
        --delete               "Server/Service/Connector/@minProcessors" \
        --delete               "Server/Service/Connector/@maxProcessors" \
        --delete               "Server/Service/Engine/@debug" \
        --delete               "Server/Service/Engine/Host/@debug" \
        --delete               "Server/Service/Engine/Host/Context/@debug" \
                               "${CONF_INSTALL}/conf/server.xml"

touch -d "@0"           "${CONF_INSTALL}/conf/server.xml"

