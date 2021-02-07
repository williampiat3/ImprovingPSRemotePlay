# TUN VPN and Chiaki installation

  * [On the raspberry pi, install piVPN](#on-the-raspberry-pi-install-pivpn)
  * [Open up the 1194 port on your router](#open-up-the-1194-port-on-your-router)
  * [Set up a VPN client on your remote PC](#set-up-a-vpn-client-on-your-remote-pc)
  * [Connect to the PlayStation (try at least..)](#connect-to-the-playstation-try-at-least)
  * [Install Chiaki](#install-chiaki-)

## On the raspberry pi, install [PiVPN](https://www.pivpn.io/)
PiVPN is great, it allows for a very fast and simple installation(compared to the second solution we will be suggesting) along with a lot of blogs that are offering guides to help you select the correct settings during your configuration ([This one for instance](https://www.seeedstudio.com/blog/2020/07/02/set-up-a-raspberry-pi-vpn-server-using-pivpn-and-browse-securely-on-public-networks-m/), go straight to the "Configuring PiVPN on Raspberry Pi" section). So to make it simple I will condense the information that you need to have your VPN ready, there are no special settings in our case but here it is:
* Run `sudo apt-get install openssl`
* Run `curl -L https://install.pivpn.io | bash` or `curl -L -k https://install.pivpn.io | bash` if the first command fails
* Confirm static IP address
* Use your current network settings as static address
* pi is your local user for the VPN
* Select OpenVPN
* Don't customize the default protocol, neither the search domain or modern features
* Choose port 1194 for openvpn port
* Select any DNS provider (if you have no idea pick OpenDNS or Google)
* Use public IP
* You want the security packages
* Yes you want to reboot
Once the raspberry reboots, run the following command: `pivpn add` , create username and password it will create an ovpn file in `/home/pi/ovpns` that you need to give to the computer that will be connecting to your VPN: **I don't recommend emailing it!!! this file is a key to your home network**

## Open up the 1194 port on your router

**Before performing this last step I recommend disabling SSH on the raspberry pi just to be safe not to have any intrusion on your raspberry, if you are confident in your password and refuse to disable SSH, do it at your own risks.**
Connect to your router admin interface: http://**router IP** and look in the advanced configurations or firewall settings for a port forwarding option (the specific location of this option is dependent of your router and web provider) and add a new routing rule:
* protocol: UDP and TCP
* port 1194
* destination: **Raspberry IP**
* external IP: Leave empty (except if you only want to authorize some specific IPs to connect to your VPN, which could be a good idea if the remote network whence you want to connect has a static IP... oh wait it most likely doesn't have one ;) )

## Set up a VPN client on your remote PC
On the computer on the remote network, you need to set a VPN client that will allow you to connect to the VPN server.
For [Windows](https://openvpn.net/client-connect-vpn-for-windows/), [Mac OS](https://openvpn.net/client-connect-vpn-for-mac-os/) or [Linux](https://doc.ubuntu-fr.org/client_openvpn)

The rest is rather straightforward:
* Install OpenVPN Client
* Start the Client once it is installed
* Import the ovpn file to link to the raspberry
* Enter the username and password defined during the install of pivpn
* Start the VPN
* Greet yourself with a beer (Optional)

To check if you are successful, you should see the overall data flow (uploads and downloads) on the GUI. Meanwhile browsing 'my IP address' will give you your ...**public IP** (See, you get used to all this)

## Connect to the PlayStation (try at least..)
Yeeeww ! You are connected remotely to your home network now try to connect to your PlayStation using the PS remote play application...

It doesn't work...

Yes, it doesn't work...

But you can actually detect the PlayStation if you run this command (that works on windows, Linux and Mac OS) `ping **PS IP**` you will be receiving packets meaning the PlayStation is accessible but the app doesn't reach it! ([explanation here](#why-is-this-not-working-with-the-ps-remote-play-app)) But you know what does? Chiaki!

## Install Chiaki <img src="./images/chiaki_icon.png" width=10% height=10%>
[Chiaki](https://git.sr.ht/~thestr4ng3r/chiaki) is a free, open source, PS remote play client that you can download [here.](https://git.sr.ht/~thestr4ng3r/chiaki/refs)
You also need your **PSN account ID**, not your login, not your email... Look, you just don't have it yet ;). 

The Chiaki github is providing a python script for you to get it easily [here](https://raw.githubusercontent.com/thestr4ng3r/chiaki/master/scripts/psn-account-id.py), and if you don't know how to run a python script on your computer well you should! it really is an awesome language. If you really don't have and don't want python3 on your computer, the raspberry pi can run it for you :
just run `wget https://raw.githubusercontent.com/thestr4ng3r/chiaki/master/scripts/psn-account-id.py` to get the script and run `python3 psn-account-id.py`...
Some packages missing? `sudo pip3 install requests` .....
pip missing? `sudo apt-get install python3-pip`. 

Ok now you should be fine running the script. It will open up a web page for logging you, copy past the link you get in your terminal and that's it your **PSN account ID**, note it down. 
Run the Chiaki executable enter your **PSN account ID** the **PS IP** and then it will prompt for a PIN code
To register a PS4 with a PIN, it must be put into registration mode. To do this, on your PS4, simply go to: Settings -> Remote Play (ensure this is ticked) -> Add Device, it will give you a PIN code to enter on your PC and noooooooooooowwwwwwwww .... YOU ARE CONNECTED

You can now run remote play at a higher resolution with less lag and more stable connection but ... BUT using Chiaki comes at some cost:
* not all the keys of the controller are supported the touchpad for instance (Windows and MacOS)
* Rumble and ... remote waking-up the PlayStation from Rest mode are not supported on Windows. 

It is great for a game that doesn't use them, for other games... well then the second solution remains.

These tests were performed on Chiaki 1.3.0, version 2.1.1 appears to have fixed those issues but we still haven't fully tested them.
