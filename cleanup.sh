#!/bin/sh

set -e

echo 'Cleaning up after bootstrapping...'

# Remove Linux headers
yum -y remove gcc kernel-devel kernel-headers perl cpp
yum -y clean all

# Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# remove under tmp directory
rm -rf /tmp/*

cat /dev/null > ~/.bash_history

# remove interface persistent
rm -f /etc/udev/rules.d/70-persistent-net.rules

for ifcfg in $(ls /etc/sysconfig/network-scripts/ifcfg-*)
do
    if [ "$(basename ${ifcfg})" != "ifcfg-lo" ]
    then
        sed -i '/^UUID/d'   ${ifcfg}
        sed -i '/^HWADDR/d' ${ifcfg}
    fi
done

history -c

# dd if=/dev/zero of=/EMPTY bs=1M
# rm -rf /EMPTY


exit
