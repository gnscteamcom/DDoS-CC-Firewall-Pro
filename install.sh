#!/bin/bash
# DDOS & CC Firewall Pro installation wrapper
# modify by HKLCF

#
# Currently Supported Operating Systems:
#
#   RHEL 5, RHEL 6
#   CentOS 5, CentOS 6, CentOS 7
#   Debian 7
#

SCRIPT_SERVER=https://raw.githubusercontent.com/hklcf/DDoS-CC-Firewall-Pro/master

# Check OS type
if [ -e '/etc/redhat-release' ]; then
    type="rhel"
fi
if [ -z "$type" ]; then
    os=$(head -n1 /etc/issue | cut -f 1 -d ' ')
    if [ "$os" == 'Debian' ]; then
        type="debian"
    fi
fi
# Check type
if [ -z "$type" ]; then
    echo 'Error: only RHEL,CentOS,Debian 7 is supported'
    exit 1
fi
# Check wget
if [ -e '/usr/bin/wget' ]; then
    wget $SCRIPT_SERVER/install-rhel.sh
    chmod 0700 install-rhel.sh
    if [ "$?" -eq '0' ]; then
        bash install-rhel.sh $*
        exit
    else
        echo "Error: install-rhel.sh download failed."
        exit 1
    fi
fi
# Let's try to install wget automaticaly
if [ "$type" = 'rhel' ]; then
    ./install-rhel.sh
    if [ $? -ne 0 ]; then
        echo "Error: can't install wget"
        exit 1
    fi
fi
# OK, last try
if [ -e '/usr/bin/wget' ]; then
    wget $SCRIPT_SERVER/install-rhel.sh
    if [ "$?" -eq '0' ]; then
        bash install-rhel.sh $*
        exit
    else
        echo "Error: install-rhel.sh download failed."
        exit 1
    fi
else
    echo "Error: /usr/bin/wget not found"
    exit 1
fi
exit
