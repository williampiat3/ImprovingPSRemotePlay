#!/bin/sh

echo "======= Starting the Bridge VPN procedure ======="
echo "Please check that you are in super user mode"
echo "Do 'sudo su' before using this script"
echo 'close the process if it is not the case,'
read -p "press enter if you are in super user mode"
echo "================================================="
echo " "


echo "======= Update of PI ======="
apt-get update
apt-get upgrade
rm /etc/apt/sources.list.d/vscode.list
rm /etc/apt/trusted.gpg.d/microsoft.gpg
apt update

echo "   + Installing OpenVPN and bridge utils"
apt-get install openvpn easy-rsa bridge-utils
cp -r /usr/share/easy-rsa /etc/openvpn
echo " "

echo "   + Creating credentials"
cd /etc/openvpn/easy-rsa
./easyrsa init-pki
echo "==========================================================="
echo "== For Common Name, enter 'OpenVPN-CA' (without quotes) ==="
echo "==========================================================="
./easyrsa build-ca nopass
echo "=========================================================="
echo "=== Please press entered with no entry after next step ==="
echo "=========================================================="
echo "the Common Name will be set to openvpnserver by default"
./easyrsa gen-req openvpnserver nopass
echo "========================================================="
echo "======== Enter yes (without quotes) as requested ========"
echo "========================================================="
./easyrsa sign-req server openvpnserver

echo "   + Generation Diffie-Hellman parameters"
echo "     it may takes some times"
./easyrsa gen-dh

echo "   + Creation credentials for a client "
read -p "Enter a name for the first client to your vpn: "  username
echo "=========================================================="
echo "=== Please press entered with no entry after next step ==="
echo "=========================================================="
echo 'the Common Name will be set to '"$username"' by default'
./easyrsa gen-req $username nopass
echo "========================================================="
echo "======== Enter yes (without quotes) as requested ========"
echo "========================================================="
./easyrsa sign-req client $username

echo "   + Creation of he HMAC signature"
openvpn --genkey --secret /etc/openvpn/easy-rsa/pki/private/ta.key

echo " "
rasp_IP=$(ifconfig | grep -w inet |grep -v 127.0.0.1| awk '{print $2}' | cut -d ":" -f 2)
Broadcast_ip=$(ifconfig | grep -w inet |grep -v 127.0.0.1| awk '{print $6}' | cut -d ":" -f 2)
Netmask=$(ifconfig | grep -w inet |grep -v 127.0.0.1| awk '{print $4}' | cut -d ":" -f 2)
echo "Please enter your  public IP adress. I can be optained by searching on internet"
echo "What is my IP adress. Put all numbers and points without spaces"
read -p "Public IP: "  public_ip
echo " "
echo "Please enter your router IP adress. I can be optained by searching on internet"
echo "What is my router IP adress name_of_your_internet_provider"
echo "Put all numbers and points without spaces"
read -p "Router IP: "  router_ip
echo " "
echo " ===== Generating files for the VPN to work according to provided informations ======"

echo "#!/bin/sh" > /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge
echo "# Define Bridge Interface"  >> /etc/openvpn/openvpn-bridge
echo 'br="br0"'  >> /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge
echo "# Define list of TAP interfaces to be bridged," >> /etc/openvpn/openvpn-bridge
echo '# for example tap="tap0 tap1 tap2".' >> /etc/openvpn/openvpn-bridge
echo 'tap="tap0"' >> /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge

echo '# Define physical ethernet interface to be bridged' >> /etc/openvpn/openvpn-bridge
echo '# with TAP interface(s) above.' >> /etc/openvpn/openvpn-bridge
echo 'eth="eth0"' >> /etc/openvpn/openvpn-bridge
echo 'eth_ip_netmask="'"$rasp_IP"'/24"' >> /etc/openvpn/openvpn-bridge
echo 'eth_broadcast="'"$Broadcast_ip"'"' >> /etc/openvpn/openvpn-bridge
echo 'eth_gateway="'"$router_ip"'"' >> /etc/openvpn/openvpn-bridge

echo "" >> /etc/openvpn/openvpn-bridge
echo 'case "$1" in' >> /etc/openvpn/openvpn-bridge
echo 'start)' >> /etc/openvpn/openvpn-bridge
echo '   for t in $tap; do' >> /etc/openvpn/openvpn-bridge
echo '       openvpn --mktun --dev $t' >> /etc/openvpn/openvpn-bridge
echo '   done' >> /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge
echo '   brctl addbr $br' >> /etc/openvpn/openvpn-bridge
echo '   brctl addif $br $eth' >> /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge
echo '   for t in $tap; do' >> /etc/openvpn/openvpn-bridge
echo '       brctl addif $br $t' >> /etc/openvpn/openvpn-bridge
echo '   done' >> /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge
echo '   for t in $tap; do' >> /etc/openvpn/openvpn-bridge
echo '       ip addr flush dev $t' >> /etc/openvpn/openvpn-bridge
echo '       ip link set $t promisc on up' >> /etc/openvpn/openvpn-bridge
echo '   done' >> /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge
echo '   ip addr flush dev $eth' >> /etc/openvpn/openvpn-bridge
echo '   ip link set $eth promisc on up' >> /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge
echo '   ip addr add $eth_ip_netmask broadcast $eth_broadcast dev $br' >> /etc/openvpn/openvpn-bridge
echo '   ip link set $br up' >> /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge
echo '   ip route add default via $eth_gateway' >> /etc/openvpn/openvpn-bridge
echo '   ;;' >> /etc/openvpn/openvpn-bridge
echo 'stop)' >> /etc/openvpn/openvpn-bridge
echo '   ip link set $br down' >> /etc/openvpn/openvpn-bridge
echo '   brctl delbr $br' >> /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge
echo '   for t in $tap; do' >> /etc/openvpn/openvpn-bridge
echo '       openvpn --rmtun --dev $t' >> /etc/openvpn/openvpn-bridge
echo '   done' >> /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge
echo '   ip link set $eth promisc off up' >> /etc/openvpn/openvpn-bridge
echo '   ip addr add $eth_ip_netmask broadcast $eth_broadcast dev $eth' >> /etc/openvpn/openvpn-bridge
echo "" >> /etc/openvpn/openvpn-bridge
echo '   ip route add default via $eth_gateway' >> /etc/openvpn/openvpn-bridge
echo '   ;;' >> /etc/openvpn/openvpn-bridge
echo '*)' >> /etc/openvpn/openvpn-bridge
echo '   echo "Usage:  openvpn-bridge {start|stop}"' >> /etc/openvpn/openvpn-bridge
echo '   exit 1' >> /etc/openvpn/openvpn-bridge
echo '   ;;' >> /etc/openvpn/openvpn-bridge
echo 'esac' >> /etc/openvpn/openvpn-bridge
echo 'exit 0' >> /etc/openvpn/openvpn-bridge

echo " ===== File openvpn-bridge generated ======"
chmod 744 /etc/openvpn/openvpn-bridge

echo "Provide starting IP and ending IP for bridge"
read -p "Starting IP: "  starting_ip
read -p "Ending IP: "  ending_ip
read -p "vpn port (choose 1194 by default): " port

echo 'port '"$port"' > /etc/openvpn/server.conf
echo 'proto udp' >> /etc/openvpn/server.conf
echo 'dev tap0' >> /etc/openvpn/server.conf
echo 'ca /etc/openvpn/easy-rsa/pki/ca.crt' >> /etc/openvpn/server.conf
echo 'cert /etc/openvpn/easy-rsa/pki/issued/openvpnserver.crt' >> /etc/openvpn/server.conf
echo 'key /etc/openvpn/easy-rsa/pki/private/openvpnserver.key' >> /etc/openvpn/server.conf
echo 'dh /etc/openvpn/easy-rsa/pki/dh.pem' >> /etc/openvpn/server.conf
echo 'remote-cert-tls client' >> /etc/openvpn/server.conf

echo 'server-bridge '"$rasp_IP"' '"$Netmask"' '"$starting_ip"' '"$ending_ip" >> /etc/openvpn/server.conf

echo 'client-to-client' >> /etc/openvpn/server.conf
echo 'keepalive 10 120' >> /etc/openvpn/server.conf
echo 'tls-auth /etc/openvpn/easy-rsa/pki/private/ta.key 0' >> /etc/openvpn/server.conf
echo 'cipher AES-256-GCM' >> /etc/openvpn/server.conf
echo 'compress lz4-v2' >> /etc/openvpn/server.conf
echo 'push "compress lz4-v2"' >> /etc/openvpn/server.conf
echo 'push "redirect-gateway def1"' >> /etc/openvpn/server.conf
echo 'push "dhcp-option DNS 8.8.8.8"' >> /etc/openvpn/server.conf
echo 'persist-key' >> /etc/openvpn/server.conf
echo 'persist-tun' >> /etc/openvpn/server.conf
echo 'status /var/log/openvpn-status.log' >> /etc/openvpn/server.conf
echo 'log-append /var/log/openvpn.log' >> /etc/openvpn/server.conf
echo 'verb 3' >> /etc/openvpn/server.conf

echo " ===== File server.conf generated ======"

echo "   + Enable IPV4 forwarding"
sysctl -w net.ipv4.ip_forward=1

echo "   + Edition of openvpn@.service"
sed -i '/^Restart=.*/a ExecStartPre=/etc/openvpn/openvpn-bridge stop' /lib/systemd/system/openvpn@.service
sed -i '/^Restart=.*/a ExecStartPre=/etc/openvpn/openvpn-bridge start' /lib/systemd/system/openvpn@.service

path='/home/pi/credentials/'"$username"'.conf'
echo 'client'> $path
echo 'dev tap0'>> $path
echo 'proto udp'>> $path
echo 'remote '"$public_ip"' '"$port"'>> $path
echo 'persist-key'>> $path
echo 'persist-tun'>> $path
echo 'ca ca.crt'>> $path
echo 'cert '"$username"'.crt'>> $path
echo 'key '"$username"'.key'>> $path
echo 'remote-cert-tls server'>> $path
echo 'tls-auth ta.key 1'>> $path
echo 'cipher AES-256-GCM'>> $path
echo 'compress lz4-v2'>> $path
echo 'verb 3'>> $path


mkdir /home/pi/credentials
cp /etc/openvpn/easy-rsa/pki/ca.crt /etc/openvpn/easy-rsa/pki/private/ta.key /home/pi/credentials
cp $path /home/pi/credentials
path='/etc/openvpn/easy-rsa/pki/private/'"$username"'.key'
cp $path /home/pi/credentials
path='/etc/openvpn/easy-rsa/pki/issued/'"$username"'.crt'
cp $path /home/pi/credentials

chown pi /home/pi/credentials/*
echo "================================================="
echo "You can now plug a usb drive to get the directory credentials"
read -p "It will be at /home/pi, once you got them, press enter to reboot the pi"
echo "================================================="

reboot

