#!/usr/bin/env bash

# chw.sh
# --------------
# Very simple tool to wrap chrooting into a build environment

ALL_DIRS=$(cat <<EOF
proc
dev
dev/pts
sys
EOF
)

MY_CWD=`pwd`

TMP_DIR_FILE=`mktemp /tmp/dirchw-XXXXXX`

trace() {
    DATESTAMP=$(date +'%Y-%m-%d %H:%M:%S %Z')
    echo "${DATESTAMP} : ${*}"
}

trace "temp file ${TMP_DIR_FILE}"

mount_all() {
    touch ${TMP_DIR_FILE}
    for DIR in $ALL_DIRS
    do
        trace "binding /${DIR} ${1}/${DIR}"
        mount --bind /${DIR} ${1}/${DIR}
        echo "${DIR}" >> ${TMP_DIR_FILE}
    done
}

umount_all() {
    REV_DIRS=$(sort -r ${TMP_DIR_FILE})
    for DIR in $REV_DIRS
    do
        trace "unmounting /${DIR} ${1}/${DIR}"
        umount ${1}/${DIR}
    done
}

clean_bashrc() {
    local TMP_FILE=`mktemp /tmp/chw-XXXXXX`
    sed '/## CHR_BEGIN/,/## CHR_END/d' ${1}/root/.bashrc > ${TMP_FILE}
    cp -f ${TMP_FILE} ${1}/root/.bashrc
    rm -f ${TMP_FILE}
}

make_bashrc() {
    clean_bashrc "${1}"

    echo "## CHR_BEGIN" >> ${1}/root/.bashrc
    echo "PS1='\033[1;33m\](${MY_CWD}/${1})\033[0m\][\033[1;31m\]\u\033[0m\]@\033[1;31m\]\h\033[0m\] \033[1;31m\]\w\033[0m\]]\n\$ '" >> ${1}/root/.bashrc
    echo "export PS1" >> ${1}/root/.bashrc
    echo "## CHR_END" >> ${1}/root/.bashrc
}

# Must be run as root
if [ "$(id -u)" != "0" ]; then
    trace "This script must be run as root!"
    exit 1
fi

# Get our chroot path
if [ -n "$1" ]; then
    CHROOT_PATH=$1

    # Check on the chroot path
    if [ -d "$CHROOT_PATH" ]; then
            mount_all "$CHROOT_PATH"

            make_bashrc "${CHROOT_PATH}"

            chroot ${CHROOT_PATH}

            umount_all "$CHROOT_PATH"
            rm -f ${TMP_DIR_FILE}

            clean_bashrc "${CHROOT_PATH}"
    else
        trace "The chroot path '${CHROOT_PATH}' does not exist or is not a directory!"
        exit 1
    fi
fi

# vim:set ai et sts=4 sw=4 tw=80:
