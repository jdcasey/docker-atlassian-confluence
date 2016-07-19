#!/bin/bash

source /etc/profile.d/java
source /etc/profile.d/confluence

echo "Confluence Installation: '${CONF_INSTALL}'"
echo "Confluence Home: '${CONF_HOME}'"
echo "Java Home: '${JAVA_HOME}'"

exec "${CONF_INSTALL}/bin/catalina.sh" run
