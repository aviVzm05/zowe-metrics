#!/bin/bash
set -e
echo "Called with: $@" > zowe-init.log
echo $HOST

if [[ "$1" == "zowe-init" || "$1" == "cat" ]]; then
    # Start the gnome keyring daemon when a bash session is initialized (requires passing `--privileged` or `--cap-add ipc_lock` when calling `docker run`):
    [ -z "$GNOME_KEYRING_CONTROL" ] && RND=$(openssl rand -base64 32) && eval $(echo "$RND" | gnome-keyring-daemon --unlock --components=secrets >> zowe-init.log | sed -e "s/^/export /g")
    # Calling Zowe CLI to initialize daemon mode:
    zowe --version
    zowe config set --secure profiles.base.properties.password $PASSWORD --gc
    zowe config set --secure profiles.base.properties.user $USERNAME --gc
    zowe config set profiles.base.properties.host $HOST --gc
    . /scripts/getlogs.sh
else
    exec "$@"
fi