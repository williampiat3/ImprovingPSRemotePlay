#!/bin/sh

echo "======= Generating clients creds for bridge vpn ======="
echo "Please check that you are in super user mode"
echo "Do 'sudo su' before using this script"
echo 'close the process if it is not the case,'
read -p "press enter if you are in super user mode"
echo "======================================================="
echo " "
cd /etc/openvpn/easy-rsa

echo "   + Creation credentials for a client "
read -p "Enter a name for the first client to your vpn: "  username
read -p "vpn port (choose 1194 by default): " port
echo "Please enter your public IP adress (VPN side). I can be optained by searching on internet"
echo "What is my IP adress. Put all numbers and points without spaces"
read -p "Public IP: "  public_ip
echo "=========================================================="
echo "=== Please press entered with no entry after next step ==="
echo "=========================================================="
echo 'the Common Name will be set to '"$username"' by default'
./easyrsa gen-req $username nopass
echo "=========================================================="
echo "========= Enter yes (without quotes) as requested ========"
echo "=========================================================="
./easyrsa sign-req client $username

path='/home/pi/credentials/'"$username"'.conf'
echo 'client'> $path
echo 'dev tap0'>> $path
echo 'proto udp'>> $path
echo 'remote '"$public_ip"' '"$port'>> $path
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

cp $path /home/pi/credentials
path='/etc/openvpn/easy-rsa/pki/private/'"$username"'.key'
cp $path /home/pi/credentials
path='/etc/openvpn/easy-rsa/pki/issued/'"$username"'.crt'
cp $path /home/pi/credentials

echo "================================================="
echo "You can now plug a usb drive to get the directory credentials"
read -p "It will be at /home/pi, press enter to end process"
echo "================================================="
