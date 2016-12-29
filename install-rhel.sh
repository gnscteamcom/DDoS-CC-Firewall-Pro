#!/bin/sh
SCRIPT_SERVER=https://raw.githubusercontent.com/hklcf/DDoS-CC-Firewall-Pro/master
echo 'Install DDOS & CC Firewall Pro v1.0.5:'
read -p 'Do you want to proceed? [y/n]): ' answer
if [ "$answer" != 'y' ] && [ "$answer" != 'Y'  ]; then
    echo 'Goodbye'
    exit 1
fi
read -p 'Please enter valid email address [E.g. "test@mydomain.com"]: ' email
read -p 'Please enter No of Connections [Recommended 350]: ' noofconnections
read -p 'Please enter BAN PERIOD [Recommended 500]: ' banperiod
echo '########################################################'
echo 'Add IP whitelist, default add 5 IPs：'
read -p 'White ip 1 [Must 127.0.0.1]: ' wip1
read -p 'White ip 2 [Optional]: ' wip2
read -p 'White ip 3 [Optional]: ' wip3
read -p 'White ip 4 [Optional]: ' wip4
read -p 'White ip 5 [Optional]: ' wip5

if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DDOS & CC Firewall Pro v1.0.5'; echo
echo; echo -n 'Downloading files...'
wget -q -O /usr/local/ddos/ddos.conf $SCRIPT_SERVER/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE $SCRIPT_SERVER/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list $SCRIPT_SERVER/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh $SCRIPT_SERVER/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo -e 'PROGDIR="/usr/local/ddos"' '\nPROG="/usr/local/ddos/ddos.sh"' '\nIGNORE_IP_LIST="/usr/local/ddos/ignore.ip.list"' '\nCRON="/etc/cron.d/ddos.cron"' '\nAPF="/etc/apf/apf"' '\nIPT="/sbin/iptables"' '\nFREQ=1' '\nNO_OF_CONNECTIONS='$noofconnections '\nAPF_BAN=0' '\nKILL=1' '\nEMAIL_TO='$email '\nBAN_PERIOD='$banperiod > /usr/local/ddos/ddos.conf
echo -e $wip1 '\n'$wip2 '\n'$wip3 '\n'$wip4 '\n'$wip5 > /usr/local/ddos/ignore.ip.list
echo '...done'

echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
yum install iptables
service iptables start
chkconfig --level 345 iptables on
echo 'Please send in your comments and/or suggestions to support@vpshouse.pro'
echo
cat /usr/local/ddos/LICENSE | less
