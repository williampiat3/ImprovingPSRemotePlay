# Install Wireguard for a multithreaded VPN
As Wireguard can provide a multithreaded VPN interface it is a good solution in case you want more throughput via your VPN, we will cover here how to install a wireguard VPN server and the clients on Windows and Linux. Wireguard doesn't provide a layer 2 interface to your LAN therefore you won't be able to use it with the official remote play app but it can be used with Steam remote play or Chiaki

## Wireguard server
The installation is straight forward and has very little difference of the piVPN TUN server that we explored already. PiVPN provides an easy way to install wireguard and you can completly trust the installation script.
* Run `sudo apt-get update && sudo apt-get upgrade`
* Run `sudo apt-get install openssl`
* Run `curl -L https://install.pivpn.io | bash` or `curl -L -k https://install.pivpn.io | bash` if the first command fails
* Confirm static IP address
* Use your current network settings as static address
* pi is your local user for the VPN
* Select Wireguard
* Don't customize the default protocol, neither the search domain or modern features
* Choose port 51820 for wireguard port
* Select any DNS provider (if you have no idea pick OpenDNS or Google)
* Use public IP
* You want the security packages
* Yes you want to reboot

Make the credentials by running `pivpn add` and this will create the conf file that you will have to change later on.
The name entered here during the process of creating credentials is *psremote*.

## Open up the 51820 port on your router

**Before performing this last step I recommend disabling SSH on the raspberry pi just to be safe not to have any intrusion on your raspberry, if you are confident in your password and refuse to disable SSH, do it at your own risks.**
Connect to your router admin interface: http://**router IP** and look in the advanced configurations or firewall settings for a port forwarding option (the specific location of this option is dependent of your router and web provider) and add a new routing rule:
* protocol: UDP and TCP
* external port 51820
* internal port 51820
* destination: **Raspberry IP**
* external IP: Leave empty (except if you only want to authorize some specific IPs to connect to your VPN, which could be a good idea if the remote network whence you want to connect has a static IP... )


Now switch to your host machine and install WireGuard Client. We provide how-to for Linux and Windows:
## Linux Client:

### Install:
In linux or Ubuntu, WireGuard is not natively installed like OpenVPN was therefore it needs to be installed. 
* First, update your machine by opening a terminal and entering ```sudo apt-get update``` and then ```sudo apt-get upgrade``` 
* Install WireGuard by doing ```sudo apt install wireguard``` 
* Open the psremote.conf file to ensure the following:
```
[Interface]
PrivateKey = YourPrivateKey_DoNotChangeOrShareToInternet
Address = 10.6.0.N/24
DNS = 8.8.8.8, 8.8.4.4

[Peer]
PublicKey = YourPublicKey_DoNotChangeOrShareToInternet
PresharedKey = YourPresharedKey_DoNotChangeOrShareToInternet
Endpoint = "Public IP":51820
AllowedIPs = 10.0.6.0/24,"Router_IP  format"/24
```
**N** in Address is the number that will have your host computer on the network : the VPN is at the IP ```10.6.0.1```, therefore you need to give a different number of each machine connecting to the VPN. Here, you can put 2 instead of N therefore this machine will be hosted at the IP ```10.6.0.2```.
**Router_IP format** is a modified IP. Take your **Router IP** and change the last number to zero: ```192.168.X.ABC```=> ```192.168.X.0```

* Tranfert the psconf_file.conf file to WireGuard install file: ```cp psremote.conf /etc/wireguard/```
* Start the VPN by doing ```wg-quick up psremote```
* An error might pop up and WireGuard will not start: ```/usr/bin/wg-quick: line 31: resolvconf: command not found```, it an be fixed by doing ```ln -s /usr/bin/resolvectl /usr/local/bin/resolvconf``` and retry starting WireGuard.
Now you should be connected. Doing ```Hostname -I``` will give you both your IP on you local network and 10.6.0.N. 

### Bonus: latency and bandwidth
You can ping the VPN by doing ```ping 10.6.0.1``` 
This will give you a latency test. Keep in mind that remote playing will add more software overlay and delay even more your experience but these delays are constant regardless of you playing next door or half a planet appart from the VPN: **only the time it will take for your computer to communicate to the VPN will vary.**

Regarding bandwidth, install iperf3 by doing ```sudo apt-get install iperf3``` if you do not have it.
Then test the max bandwith by doing ```iperf3 -c Raspberry_IP``` on the remote PC and ```iperf3 -s``` on the raspberry PI
You may run it during 10 minutes to eliminate any Rasberry pi heating throttle (```iperf3 -c 600 -t Raspberry_IP```)

You can see what your VPN will allows you to do following this [reddit forum](https://www.reddit.com/r/remoteplay/comments/k0s3rr/megathread_tips_and_good_practices_for_remote_play/):

* 360p is about 2 Mbps (Peaks at 176KBps with less than 30fps)
* 540p is about 6 Mbps (Peaks at 640KBps with less than 30fps)
* 720p is about 10 Mbps (Peaks at 1.04MBps with less than 30fps)
* 1080p is about 15 Mbps (Peaks at 1.64MBps with less than 30fps)

I personnaly experienced, on a PS4 Fat 720p with max fps, 7.7Mbps on average with peaks up to 11 Mbps. 

Good news if you have a connection with more then 35 Mbps, you will be able to play at two at the same time through the VPN in 1080p, with one person been on the PS4 and another one been on the PS5.

## Windows Client:

### Install:
* On Windows, install [WireGuard](https://www.wireguard.com/install/).
* Open the psremote.conf file to ensure the following:
```
[Interface]
PrivateKey = YourPrivateKey_DoNotChangeOrShareToInternet
Address = 10.6.0.N/24
DNS = 8.8.8.8, 8.8.4.4

[Peer]
PublicKey = YourPublicKey_DoNotChangeOrShareToInternet
PresharedKey = YourPresharedKey_DoNotChangeOrShareToInternet
Endpoint = "Public IP":51820
AllowedIPs = 0.0.0.0/1, 128.0.0.0/1, ::/1, 8000::/1
```
**N** in Address is the number that will have your host computer on the network : the VPN is at the IP ```10.6.0.1```, therefore you need to give a different number of each machine connecting to the VPN. Here, you can put 2 instead of N therefore this machine will be hosted at the IP ```10.6.0.2```.
I am not sure why ```AllowedIPs``` needs to be changed to this extend but it appears to work this way ...
* Open WireGuard and import the psremote.conf file as a new tunnel and start the VPN


### Bonus: latency and bandwidth and steam remote play 
Just like in linux you can ping the VPN by doing ```ping 10.6.0.1``` and this will give you a broad idea of the latency just like precised in the Linux version of this test.
For iperf3, download the [source files](https://iperf.fr/fr/iperf-download.php) and unzip them
* On the raspberry run the following command to run a test server `iperf3 -s`
* On the remote computer go find the iperf3.exe file, open up a terminal in the same folder and run `iperf3.exe -c Raspberry_IP` or `iperf3.exe -c 600 -t Raspberry_IP` to test during 10 minutes.

Regarding Steam Remote Play, this VPN is multithreaded therefore it is optimised to maximise the throughput. if you are into 4K remote play and you are using a Raspberry pi 3b+ or 4 you can perform the following. Note that it works automatically with a bridge VPN but due to OpenVPN been not multithreaded and been the only solution so far, performance can be ... meh ?

[This forum](https://steamcommunity.com/groups/homestream/discussions/3/619574421223826076/) and [this guide](https://steamcommunity.com/sharedfiles/filedetails/?id=873543244) will provide you with all information needed:
* Plug the PC you wish to stream for on the same network as the VPN and find it's IP (called here **SteamHost IP**)
* Log on this pc on your Steam account and pass it on offline mode in Steam => Go Offline (note that letting it online might use Stream online streaming services)
* On the remote computer, left clic on Steam shortcut and clic on properties 
* Edit the target and change it from  ```"C:\Program Files (x86)\Steam\Steam.exe"``` to ```"C:\Program Files (x86)\Steam\Steam.exe" -console```
* Start your VPN with WireGuard
* Start Steam (or restart if you were loged in) on the remote computer and log on the same accound as the host PC
* Now you have a new tab call **Console** that appeared. Go into it and type ```connect_remote "SteamHost IP":27036```
for exemple, if your host PC is hosted on the IP 192.168.0.25, type ```connect_remote 192.168.0.25:27036```
You should have a popup of steam detecting a remote computer at the IP you provided







