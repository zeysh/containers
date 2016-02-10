#!/usr/bin/env bash
set -e
VERSION=${VERSION:-"jessie"}

if [ "$EUID" -ne 0 ]; then
  echo "This script uses functionality which requires root privileges"
  exit 1
fi

mkdir debian_$VERSION
cd debian_$VERSION
debootstrap --verbose --variant=minbase --include=iproute,iputils-ping --arch=amd64 $VERSION rootfs http://http.debian.net/debian/

trap "{ export EXT=$?; acbuild --debug end && exit $EXT; }" EXIT

acbuild begin $PWD/rootfs
acbuild set-name home.lan/debian
acbuild label add version "$VERSION"
acbuild set-exec -- /bin/date
acbuild write --overwrite ../debian_$VERSION.aci
