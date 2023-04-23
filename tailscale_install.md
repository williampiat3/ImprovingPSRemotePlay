# Tailscale 
Tailscale is a powerfull tool based on Wireguard. The installation process does not use piVPN but is similarly simple. Moreover as no port needs to be opened on your router, it can be used in replacement of OpenVpn and Wireguard on routers with locked settings. However in our limited testing, we concluded that Tailscale requires a bit more computational power that Wireguard, making it less usefull on pi zero hardware.

Similarly to Wireguard, the official application cannot be used through Tailscale, we recommand using Chiaki

This guide followed the official website guides : [set up Tailscale](https://tailscale.com/download/linux) and [configure as subnet router](https://tailscale.com/kb/1019/subnets/)



## Possible conflict in IP adresses
A problem will arise if IP adresses from your local network overlap your remote network. Exemple : 
* Router_IP: `192.168.1.1`
* PS_IP: `192.168.1.25`
* connected PC: `192.168.1.35`, `100.80.220.57`

In the case, the connected PC has IPs 100.80.220.57 (Tailscale) and 192.168.1.35 (local network adress before connecting to the VPN). As this adress is also on 192.168.1.n, attempting a ping to a remote PS4-5 will results in an error. **This can be solved by accessing admin settings in one of the router and changing it's IP to 192.168.m.1**, with m different from classical adresses (in most cases, picking `m=2` will work). 

You may not be able to change your IP on the network of the PC connecting remotely but this can be an solution too.

##  Tailscale Node
The installation is straight forward. Tailscale provides an easy way to install wireguard and you can completly trust the installation script.
* Run `sudo apt-get update && sudo apt-get upgrade`
* Reboot using `sudo reboot`
* Install Tailscale `curl -fsSL https://tailscale.com/install.sh | sh`
* Reboot once more `sudo reboot` (if you do not the next command does not work, the installation guide on tailscale website does not suggest it although mandatory)
* Connect your freshly installed Tailscale node to your account with `sudo tailscale up`
Tailscale is installed but you need to connect it to your account
* [Install Tailscale on the remote computer](https://tailscale.com/download) (MacOs, iOs, Windows, Linux and even Android)

At the end of the installation process, you will be linked to a login page for both devices. We recommend using github or a freshly made gmail adress to keep everything separated but it is up to your judgment. **Your login method need to be the same across all connected devices : raspberry pi and computer using remote play**

## Configure the raspberry pi as subnet router

The [official guide](https://tailscale.com/kb/1019/subnets/) is straightforward and we recommend using it. 

Additionnal note on the step 2 of the guide: we wish to access the Playstation network subnet therefore the command to enter is `sudo tailscale up --advertise-routes=192.168.1.0/24` if your router_IP is `192.168.1.1` or you could jsut broadcast the IP of the playstation for security reasons with `sudo tailscale up --advertise-routes=PLAYSTATION_IP/32`.


## On the client side
**Linux users, do not forget to accept all subnet routes once the raspberry pi is configured.** This step is automatic on other OSs.
* `sudo tailscale up --accept-routes`

