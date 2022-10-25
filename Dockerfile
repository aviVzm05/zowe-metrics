FROM node:18

# Directory where Zowe CLI settings and plug-ins will be stored:
RUN mkdir /zowe
# WORKDIR /zowe
ENV ZOWE_CLI_HOME=/zowe

# Install requirements of Zowe CLI Secure Credential Store:
RUN DEBIAN_FRONTEND=noninteractive apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y libsecret-1-dev gnome-keyring dbus-x11

# Install Zowe CLI:
RUN npm install -g @zowe/cli@zowe-v2-lts

# Install Zowe CLI plug-ins:
# RUN zowe plugins install @broadcom/endevor-for-zowe-cli@next

# Enable daemon mode:
RUN zowe daemon enable
ENV PATH=/zowe/bin:${PATH}

# Use entry point that initialized dbus and gnome-keyring-daemon for Zowe secure credential store and starts Zowe CLI daemon:
COPY ./docker-entrypoint.sh /zowe/

# copy the configuaraion file details to ZOWE HOME folder.
COPY ./zowe.config.json /zowe/
COPY ./zowe.schema.json /zowe/

ENTRYPOINT [ "dbus-run-session", "--", "/zowe/docker-entrypoint.sh" ]
CMD ["zowe-init"]