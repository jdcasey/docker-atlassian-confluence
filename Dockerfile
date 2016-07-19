FROM java:8

# Install Atlassian Confluence and hepler tools and setup initial home
# directory structure.
RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends libtcnative-1 xmlstarlet \
    && apt-get clean

# Expose default HTTP connector port.
EXPOSE 8090

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["/var/atlassian/lib", /var/atlassian/confluence", "/opt/atlassian/confluence/logs"]

# Set the default working directory as the Confluence home directory.
WORKDIR /var/atlassian/confluence

ADD downloads/jdk*.tar.gz /opt/jdk
ADD downloads/dumb-init /usr/local/bin/dumb-init
ADD downloads/confluence.tar.gz /opt/atlassian
ADD downloads/postgresql.jar /opt/atlassian/confluence/WEB-INF/lib/
ADD scripts/ /usr/local/bin/
ADD profile.d/* /etc/profile.d/

RUN chmod +x /usr/local/bin/* /etc/profile.d/* \
    && /usr/local/bin/confluence-dir-setup.sh

#    && chmod -R 700            "${CONF_INSTALL}/{conf,temp,logs,work}" \
#    && chown -R daemon:daemon  "${CONF_INSTALL}/{conf,temp,logs,work}" \
#    && echo -e                 "\nconfluence.home=$CONF_HOME" >> "${CONF_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties" \
#    && xmlstarlet              ed --inplace \
#        --delete               "Server/@debug" \
#        --delete               "Server/Service/Connector/@debug" \
#        --delete               "Server/Service/Connector/@useURIValidationHack" \
#        --delete               "Server/Service/Connector/@minProcessors" \
#        --delete               "Server/Service/Connector/@maxProcessors" \
#        --delete               "Server/Service/Engine/@debug" \
#        --delete               "Server/Service/Engine/Host/@debug" \
#        --delete               "Server/Service/Engine/Host/Context/@debug" \
#                               "${CONF_INSTALL}/conf/server.xml" \
#    && touch -d "@0"           "${CONF_INSTALL}/conf/server.xml"

#ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/local/bin/docker-entrypoint.sh"]

# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
USER daemon:daemon

