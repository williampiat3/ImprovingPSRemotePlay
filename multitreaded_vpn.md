# Remote play in multithreaded
Now switch to your host machine and install WireGuard Client. We provide how-to for Linux and Windows:
## Linux:

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
AllowedIPs = 10.0.6.0/24,"Router IP  format"/24
```
**N** in Address is the number that will have your host computer on the network : the VPN is at the IP ```10.6.0.1```, therefore you need to give a different number of each machine connecting to the VPN. Here, you can put 2 instead of N therefore this machine will be hosted at the IP ```10.6.0.2```.
**Router IP format** is a modified IP. Take your **Router IP** and change the last number to zero: ```192.168.X.ABC```=> ```192.168.X.0```

* Tranfert the psconf_file.conf file to WireGuard install file: ```cp psremote.conf /etc/wireguard/```
* Start the VPN by doing ```wg-quick up psconf_file```
* An error might pop up and WireGuard will not start: ```/usr/bin/wg-quick: line 31: resolvconf: command not found```, it an be fixed by doing ```ln -s /usr/bin/resolvectl /usr/local/bin/resolvconf``` and retry starting WireGuard.
Now you should be connected. Doing ```Hostname -I``` will give you both your IP on you local network and 10.6.0.N. 

### Bonus: latency and bandwidth
You can ping the VPN by doing ```ping 10.6.0.1``` 
This will give you a latency test. Keep in mind that remote playing will add more software overlay and delay even more your experience but these delays are constant regardless of you playing next door or half a planet appart from the VPN: **only the time it will take for your computer to communicate to the VPN will vary.**

Regarding bandwidth, install iperf3 by doing ```sudo apt-get install iperf3``` if you do not have it.
Then test the max bandwith by doing ```iperf3 -c Raspberry IP``` on the remote PC and ```iperf3 -s``` on the raspberry PI
You may run it during 10 minutes to eliminate any Rasberry pi heating throttle (```iperf3 -c 600 -t Raspberry IP```)

You can see what your VPN will allows you to do following this [reddit forum](https://www.reddit.com/r/remoteplay/comments/k0s3rr/megathread_tips_and_good_practices_for_remote_play/):

* 360p is about 2 Mbps (Peaks at 176KBps with less than 30fps)
* 540p is about 6 Mbps (Peaks at 640KBps with less than 30fps)
* 720p is about 10 Mbps (Peaks at 1.04MBps with less than 30fps)
* 1080p is about 15 Mbps (Peaks at 1.64MBps with less than 30fps)

I personnaly experienced, on a PS4 Fat 720p with max fps, 7.7Mbps on average with peaks up to 11 Mbps. 

Good news if you have a connection with more then 35 Mbps, you will be able to play at two at the same time througth the VPN in 1080p, with one person been on the PS4 and another one been on the PS5.

## Windows:

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


Regarding Steam Remote Play, this VPN  is multithreaded therefore it is optimised to maximise the bandwidth. if you are into 4K remote play and you are using a Raspberry pi 3b+ or 4 you can perform the following. Note that it works automatically with a bridge VPN but due to OpenVPN been not multithreaded and been the only solution so far, performanced can be ... meh ?

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







