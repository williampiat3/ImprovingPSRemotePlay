# PS4 and PS5: Improving your PS remote play experience
## Table of contents
   * [PS4 and PS5, improving your PS remote play experience](#ps4-and-ps5-improving-your-ps-remote-play-experience)
      * [Introduction](#introduction)
      * [Explanation of the solution](#explanation-of-the-solution)
      * [Price](#price)
      * [Equipment needed:](#equipment-needed)
      * [First steps common to all solutions:](#first-steps-that-are-common-to-all-the-solutions)
      * [Requirements before going to the next steps](#requirements-before-going-to-the-next-steps)
   * [Quick and dirty solution](#quick-and-dirty-solution)
      * [Install a VPN server](#install-a-vpn-server)
      * [Connect to the PlayStation (try at least..)](#connect-to-the-playstation-try-at-least)
      * [Install Chiaki](#install-chiaki-)
      * [Why is this not working with the PS remote play app](#why-is-this-not-working-with-the-ps-remote-play-app)
   * [Longer and more complex solution](#longer-and-more-complex-solution)
      * [Install a layer 2 bridge VPN](#install-a-layer-2-vpn-server-and-set-up-the-client)
      * [Connect to your PlayStation locally remotely](#connect-to-your-playstation-locally-remotely)
      * [About this solution: what is this changing](#about-this-solution-what-is-this-changing)
      * [Testing the connection](#testing-the-connection)
   * [Conclusion](#conclusion)
   * [Other uses of this VPN](#other-uses-of-this-vpn)

## Introduction
This guide will allow you to improve your experience of PS remote play, reduce the load of Sony's servers and tap into the world of raspberry pi while sitting on your couch and playing your PS4 or 5 from anywhere. Hooked already? Well, here's how to do it:
As we were not able to find online the full explanation on how to solve this problem. My brother and I decided to note down the steps that allowed us to completely tackle some issues with the PS remote play.
PlayStation gives an amazing feature to all its users by enabling them to [play on their PlayStation from afar](https://remoteplay.dl.playstation.net/remoteplay/lang/en/index.html). My brother and I discovered this functionality during the quarantines in Europe for the Coronavirus. Thanks to it we were able to both play the PlayStation (not at the same time of course) while being physically separated. As we are both owners of the PS4 this is not in violation of the terms of use of the PS remote play.

To put it simple the remote play feature allows you to stream your PS4 on any device, your computer or phone for instance. As this is streaming, you don't need huge specs on the client devices ([here are the ones for windows](https://remoteplay.dl.playstation.net/remoteplay/lang/gb/ps4_win.html) as an example), just a solid connection (15 Mb/s according to Sony's website). You can test your speed by making a speed test.
Although this tool is incredible and useful, it has a few drawbacks:

When using it in your home network(ie same network as the PS4):
* There are no connectivity issues and it works very well, capped at 720p and 30fps per second for a regular ps4 and, 1080p and 60fps for a PS4 pro and PS5 and works with low latency as the connection passes through your local network only.

The problems arise when playing on a remote network:
* It requires a very high-speed internet on both sides
* Even if there are high-speed networks, you are dependent on the Sony server that allows you to communicate to the PlayStation.
* Sony's servers are a limited resource, the more users for remote play, the lesser the quality will be.
To give you an idea: although having very high speed on both sides, we were only able to run the PS4 remotely at 540p (which is sad really since most of PS4 games are made for 1080p) and 30fps.
Trying to go as high as 720p remotely, in our experience, was constantly disconnecting.
<p align="center">
 <img src="./images/without_vpn.JPG">
</p>

Using our solution, we were able to make the remote play running at 720p all the time from afar without any connectivity issues with a safe encrypted connection. It requires to buy some equipment but it is not very expensive and we found for you the cheapest one.

## Explanation of the solution:
Some of you might have guessed it from the beginning our goal here is to make the remote play locally even if you are located on another network, to bypass Sony's server (which they should be thankful as it reduces their load ;) ) and to connect your computer almost directly to the PS4 or 5.
To achieve so we have to connect securely the device you are streaming on to the network of the PlayStation, and we will achieve this building a VPN server.

Here is a drawing explaining the principle of the solution:
<p align="center">
 <img src="./images/with_vpn.JPG">
</p>

We will offer you 2 solutions depending on your usage: 
* A quick and dirty one that is very easy but that has some disadvantages (touchpad not working for windows users but perfect for linux clients) you only have this solution if the remote PC is running on Linux as the offical PS remote application is not supported on linux. It offers the best performance possible for linux users
* A more complex one that enables you to have the full experience of the PlayStation remote play but that is a bit trickier to set up. It offers the best compatibility with windows users

## Price

Our solution is cheap, and it works on raspberry pi zero, 3 and 4 (so if you have one of these it works), meaning no subscription is needed in order to operate it (apart for your electricity subscription of course). And an idle raspberry pi 3 [consumes 1.9 Watts](https://www.pidramble.com/wiki/benchmarks/power-consumption) which is less than a small lamp so it won't be much of an extra cost. The raspberry 3 and 4 can sustain multiple connexions on the VPN but come at a higher cost, on the other hand if there is only one person using the VPN then the pi zero solution is cheaper (half of the price approximatly) the configuration is a little bit trickier at the beginning as you need to ssh from the start on it but it is more efficient.



For the raspberry pi 3 and 4 you will need:
* A [raspberry pi 3 or 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/?resellerType=home) (2Gb of RAM are sufficient)
* A micro SD card of 16Gb (or more), 8Gb could be enough but we do not recommend it.
* A USB-C Power supply, ideally the [official one](https://www.raspberrypi.org/products/type-c-power-supply/?resellerType=home)
* A nice [case](https://www.raspberrypi.org/products/raspberry-pi-4-case/?resellerType=home), recommended to protect it

For the raspberry zero you will need:
* A [raspberry pi zero 1.3](https://www.raspberrypi.org/products/raspberry-pi-zero/)
* A micro SD card of 16Gb (or more), 8Gb could be enough if you are willing to try.
* A micro USB - ethernet dongle that can power the raspberry, [this one](https://www.amazon.com/Cable-Matters-Streaming-Including-Chromecast/dp/B07N2ZHFY9) for instance
* A nice [case](https://www.raspberrypi.org/products/raspberry-pi-zero-case/), recommended to protect it
* A USB power supply of 5V, 1.2 A. Your phone power supply can do the trick

If you are using the solution with the raspberry pi zero make sure to [enable ssh](https://www.raspberrypi.org/documentation/remote-access/ssh/) (check paragraph 3.) right after burning the OS as you can't plug a keyboard on the pi zero if the ethernet dongle is on it

To help you in your choice, here is a small table summing up all use case we thought of. We hope this might help you in selecting the right raspberry pi:

|       use cases      | Pi zero v1.3<br>OpenVPN & Tailscale|Pi zero v1.3<br>Wireguard | Pi 3 & 4<br> All VPN| Psremote app|
| ----------------------   |:-----------------:|:-------------------:| :-------------:| :--------------:|
| PS4 fat 540p low fps     | OK                |      OK             |     OK         |     OK          |
| PS4 fat 720p low fps     | OK                |      OK             |     OK         |  Not stable     |
| PS4 pro 720p low fps     | Not optimal       |      OK             |     OK         |  disconnecting  |
| PS4 fat 720p high fps    | Not optimal       |      OK             |     OK         |  disconnecting  |
| PS4 pro 1080p high fps   | Not working       |      OK             |     OK         |  disconnecting* |
| PS5 1080p high fps       | Not working*      |      OK             |     OK         |     OK*         |
| PS5 and PS4 pro          | Not working*      |      Not working*   |     OK*        |  Not possible*  |
| Steam remote play        | Not working       |      Not optimal    |     OK         |  -  |

\**Test not performed, theorical result within our limited testing and comprehension*

## Equipment needed:

You will need:
* An internet router with a solid connection (15 Mb/s according to Sony's website)
* A fully operational raspberry pi 4, 3 or zero, with its power supply and an SD card with the Raspberry Pi OS on it.

If you don't feel like burning the OS yourself on the SD card, you can buy SD cards with the OS preinstalled as described [here](https://www.raspberrypi.org/downloads/noobs/), no judgment here.
* A keyboard and a mouse (only for the installation not the usage)
* An ethernet cable to link the Raspberry to your router (Wifi is not an option as we want stability)
* A second ethernet cable (if you don't already have it) to wire your PlayStation to the router as well.
* A PC for configuring the raspberry and testing the VPN (a PC on a remote network and a PC on the local network is the best configuration but one PC is fine by switching the network when testing the VPN)

## First steps that are common to all the solutions
* [Get you raspberry pi up and running with the Raspberry pi OS](https://magpi.raspberrypi.org/articles/set-up-raspberry-pi-4) you can find a lot of tutorials on the web for this and we will not be covering this here. 
* Connect your raspberry pi to the same router as the PlayStation and turn the raspberry on, in order for it to get a local ip address.
* On the raspberry get the local IP by typing `hostname -I` note it, it will be referred afterward as **raspberry IP**
* If your password on the raspberry is the default one, it's time for you to change it: `passwd` default one is 'raspberry'
* [Enable SSH on your raspberry](https://www.raspberrypi.org/documentation/remote-access/ssh/) for being able to connect to it from your computer and run commands on it.
* From your computer (on the local network) ssh onto the raspberry: here are instructions on how to do it for [windows](https://www.raspberrypi.org/documentation/remote-access/ssh/windows10.md), for [macOS](https://www.raspberrypi.org/documentation/remote-access/ssh/unix.md), and [Linux](https://www.raspberrypi.org/documentation/remote-access/ssh/unix.md) (sorry Linux users, I know you know how to do it)
* Once you're connected to the raspberry run the following command: `ifconfig | grep inet`. The output of this command will give you the following information. First blue rectangle is giving your **raspberry IP** that you already have, second rectangle is the **netmask**, note it. The third is the **broadcast IP**, note it as well.

<p align="center">
 <img src="./images/ifconfig_output.png">
</p>

* Get your **router IP** and note it: it is most likely your **raspberry IP** but replacing the last set of numbers by one (for instance in the image the router IP is 192.168.1.1). Most routers have an admin server at http://**router IP**, check it out to verify your **router IP** is correct. Alternatively browsing 'my router IP "my internet provider"' will likely give you the answer
* Get your **public IP**, Google can do that for you if you just browse 'my IP address'. Get the [ipv4](https://en.wikipedia.org/wiki/IP_address#IPv4_addresses) address, not the [ipv6](https://en.wikipedia.org/wiki/IP_address#IPv6_addresses)
* Get your **PS IP** (your PlayStation has to be connected to the LAN for this), you can get it on the playstation once it is plugged on the router by going to your network settings, alternatively you can browse http://**router IP** and enter your admin credentials. (see your router manual for them) The router admin interface depends on your internet provider but the devices on the local net are often listed under a 'LAN' tab or 'my network'. Identify the one that is your PS4 and note down its IP. We will refer it as **PS IP**

## Requirements before going to the next steps.
So at the end of these steps you are able to ssh on your raspberry that is connected to your network, and you have your **raspberry IP**, **netmask**, **broadcast IP**, **router IP**, **public IP** and **PS IP**.
We will be supposing here that your public IP is not changing very often (in case you have a static IP, that's great). But in case for some reason your public IP changes regularly you'll have to subscribe to a DynDNS service to be able to connect every time to your home network. If it changes only when you reboot your router it's fine, you can go ahead and pretend you have a static IP (we will show you what to change if your public IP changed and it will just be changing one ip address in a configuration file)

# Quick and dirty solution

## Install a VPN server
This one is fast and might give you a taste of the improvement you can experience using the VPN but it doesn't completely support all the controller's keys on Windows, Linux users can enjoy full compatibility following this solution. We suggest 3 possible solutions:

You can follow our [detailed guide to install an OpenVPN server](quick_and_dirty.md) or [our guide to install a wireguard VPN server](multitreaded_vpn.md). They are straightforward and are both made using the piVPN script. The same behavior can be achieved [using Tailscale](tailscale_install.md) but requires also some level of configuration. 

In a nutshell: Wireguard is the most performant, Tailsale is the easiest to configure, OpenVPN is the most flexible.

 
We advise this quick and dirty solution just for testing the solution before implementing the second one since it lacks some of the features of the remote play. But if you really just care about having your VPN up and running with PS remote play app we suggest you to switch directly to the longer solution. However this way this connection works allowed us to understand how we could make our VPN work. This is why we left its conclusion here.

## Connect to the PlayStation (try at least..)
Using the VPN you can connect remotly to your home network, now you can try to fire the PS remote play application but...

It doesn't work...

Yes, it doesn't work...

But you can actually detect the PlayStation if you run this command (it works on windows, Linux and Mac OS) `ping **PS IP**` you will be receiving packets meaning the PlayStation is accessible but the app doesn't reach it! ([explanation here](#why-is-this-not-working-with-the-ps-remote-play-app)) But you know what does? Chiaki!

## Install Chiaki <img src="./images/chiaki_icon.png" width=10% height=10%>
[Chiaki](https://git.sr.ht/~thestr4ng3r/chiaki) is a free, open source, PS remote play client that you can download [here.](https://git.sr.ht/~thestr4ng3r/chiaki/refs)
You also need your **PSN account ID**, not your login, not your email... Look, you just don't have it yet ;). 

The Chiaki github is providing a python script for you to get it easily [here](https://git.sr.ht/~thestr4ng3r/chiaki/tree/master/item/scripts/psn-account-id.py), and if you don't know how to run a python script on your computer well you should! it really is an awesome language. If you really don't have and don't want python3 on your computer, the raspberry pi can run it for you :
just run `wget https://git.sr.ht/~thestr4ng3r/chiaki/tree/master/item/scripts/psn-account-id.py` to get the script and run `python3 psn-account-id.py`...
Some packages missing? `sudo pip3 install requests` .....
pip missing? `sudo apt-get install python3-pip`. 

Ok now you should be fine running the script. It will open up a web page for logging you, copy past the link you get in your terminal and that's it your **PSN account ID**, note it down. 
Run the Chiaki executable enter your **PSN account ID** the **PS IP** and then it will prompt for a PIN code
To register a PS4 with a PIN, it must be put into registration mode. To do this, on your PS4, simply go to: Settings -> Remote Play (ensure this is ticked) -> Add Device, it will give you a PIN code to enter on your PC and noooooooooooowwwwwwwww .... YOU ARE CONNECTED

Using Chiaki used to be constraining in many ways in it's version 1.3.0:
* not all the keys of the controller were supported the touchpad for instance (Windows and MacOS)
* Rumble and ... remote waking-up the PlayStation from Rest mode was not supported on Windows. 

Now in it's version 2.1.1 fully compatible with PS5, the only noticable drawbacks are:
* On linux, The touchpad become your second PC touchpad and it stop working if the stream windows isn't selected.
* The ps button on PS4 act a bit differently than usual
* On linux, sometimes the fullscreen mode revert to window mode (double tap on touchpad is equivalent to double clic)

However it have a lots of advantages : 
* PS4 and PS5 on local network are detected automatically (or in the case of bridge VPN)
* The DualShock 4 and DualSense can be mapped on your keyboard
* Many PlayStations can be mapped in Chiaki (instead of 1 account at the time in it's official counterpart)
* It is open source so you can edit the code to add new features (if you are willing to try ...) 
* You can use it through a TUN VPN ([OpenVPN](quick_and_dirty.md)  or [WireGuard](multitreaded_vpn.md)), Wireguard being the best performing VPN in terms of streaming quality

It is a great tool but the official application remains better if you are using a single PS and a DualShock (or DualSense) in my opinion.


## Why is this not working with the PS remote play app
Well, it might be obvious for people used to VPNs but it wasn't for us so we had to investigate a little bit.
Your LAN or local network is the network connecting all your machines to the web this is your router's job basically. The LAN cannot be seen from the outside. From anyone else on the internet, you are one device identified by your public IP that is the address of your router on the web. 

On your LAN every device has a local address: a local IP (the **PS IP** or **raspberry IP** or **router IP** are local IPs) that are not visible from the outside but you can access them from within your network or with the VPN we just did. 

How acts the VPN we just did? It creates a subnetwork in your network, meaning that the raspberry acts just like your web router: the raspberry gives to any device connected to the VPN access to your LAN and the web. That's why you can actually ping the PlayStation. However the PlayStation app can't reach it? Yes (and this was a conjuncture) the app looks for the PlayStation on the same network than the device running it meaning the subnetwork of the raspberry pi and not your LAN...

<p align="center">
 <img src="./images/quickAndDirty.png">
</p>

A solution could be to connect your PlayStation to the VPN but that is not feasible unless the connection of your PlayStation to the web is through a device that can use a VPN... And even though you will add an extra step of encryption, hence some extra lag, on your streaming experience that has already lag due to the fact that you are on remote.

So the other possibility is to have the VPN register you to the LAN and not create a subnetwork and this is called a Bridge VPN! However piVPN is not (for now) able to configure your raspberry to work in that mode so we will have to configure everything manually... Yes, this is the trickier and more complex operation but it is worth it!

# Longer and more complex solution
So as described in the conclusion of the previous section the solution is to build a bridge VPN that will assign the remote computer to the LAN itself, not a subnetwork. The VPN is a little bit more complicated to configure but we will guide you through it. 

## Install a layer 2 VPN server and set up the client

If you performed the Quick and dirty solution, you'll have to uninstall piVPN on the raspberry by running the command: `pivpn uninstall` and select to uninstall all the dependencies, remove the port forwarding rule on your router (you'll have to put it back afterwards),enable ssh on your raspberry pi to be able to run commands on it from your computer and reboot it.
As we performed the installation on raspberry pi 4 and zero we made two guides with very slight differences. However to make sure that you guys don't mix the two solution we made them in two different files.

* [Guide for pi 4 (and 3)](pifour.md)

* [Guide for pi zero](pi_zero.md)


## Connect to your PlayStation locally remotely

Now that your VPN is on, that your client is ready and that you can connect to the VPN server, all you need to do is to fire the PS remote play app!!! maybe you'll have a pairing to make: 
To do this, on your PS4, simply go to: Settings -> Remote Play (ensure this is ticked) -> Add Device, it will give you a PIN code to enter on your PC
And that's it folks a local remote play is on!!! With full compatibility with all keys, touchpad and so on. Chiaki has full compatibility on Ubuntu so if you have a linux machine you can also use this solution

Now you can increase the quality of your remote play as long as you connexion allows it. Feel free to test with and without the VPN: we saw drastic improvements

## About this solution: what is this changing
Now any device connected to the VPN can be spotted on the LAN, if you go to your router's admin page (that you can also access on the remote computer with the VPN now) and check the devices connected you will note that a new device has appeared whose IP belongs to the range you gave in the configuration file of openVPN whereas in the previous solution your device was not visible as it was on a subnetwork.

## Testing the connection

Once your setup is ready I advise you to use iperf3 to check the performance of your network through the VPN by using a remote wired network: the software is available on linux, windows and MacOS: therefore you can use it on all you machines to check the throuput:
* On linux (on the raspberry) install it by using `sudo apt-get install iperf3`, on windows and on MacOS download the [source files](https://iperf.fr/fr/iperf-download.php) and unzip them
* On the raspberry run the following command to run a test server `iperf3 -s`
* On the client computer if it is a windows go find the iperf3.exe file, open up a terminal in the same folder and run `iperf3.exe -c Raspberry_IP` and you should see the average throughput that you can get from the VPN: for a seamless connection it has to be above 10Mb/s which can be perfomed by the pi zero with the dongle.


<p align="center">
 <img src="./images/bridgeVPN.png">
</p>

On our networks we had the following throughput:
| VPN \ pi model    | Pi zero v1.3<br>+ usb dongle| Pi 3b<br> v1.2 |Pi 4 (64bits)|
| ------------------|:-----------:|:-------:|:--------:|
| local LAN         | 200 Mb/s    | 95 Mb/s  | 900 Mb/s|
| OpenVPN (Bridge)  | 11 Mb/s     | 61 Mb/s  | 80 Mb/s |
| Wireguard         | 25 Mb/s     | 80 Mb/s  | 86 Mb/s |
| Tailscale         | 10 Mb/s     |          | 86 Mb/s |



The VPN drastically reduces the throughput compared to local play but this is the only way you can safely connect remotely to your local network. WireGuard appeards to be more optimized than OpenVPN as the gains on a pi zero are significant. Regarding pi 4 performances, internet providers in our country limit the bandwith for VPN therefore even with OpenVPN set up as bridge, we max out at this limit.

Throughput is one thing however when you are playing video games there is another metric that is terribly important, the latency. Of course you'll be playing from far away on your console, this means that this will introduce some delay between the time your are typing your commands and the time you will see them executed on the screen, this is kind of the unsolvable problem of remote play as it depends of the distance and the internet providers you have. You'll feel the difference as your inputs will be less responsive and it will be more difficult to have quick reflexes on any game so of course this is not ideal if you want to play competitive. But it does provide a good experience for casual play.


# Conclusion

We don't believe that this solution harms Sony in any way: we give people the opportunity to play more on their consoles remotely and enabling friends to share a console where they might not have all the money to buy their own all of which is profitable to Sony. We made a huge ad of their remote play feature in this article and, you might have guessed it, we are definitely very fond of it.

In our minds this is a cheap solution to improve the quality and latency of your streaming feed, we wanted to enjoy ps4 games without having to buy a console both and this solution was a good answer to this problem, especially in quarantine times. It's also a good solution now: the PS5 being out and not everyone being able to afford it, you can share the price and the console with some of your friends and be coowners if you are ok with sharing the console.

At the time of the writing, we didn't test our solution on a PS5 but, as it involves the same protocols, we are confident that it can work (stay tuned!). Submit an issue if  you are encountering a problem with the solution we will gladly help. 

# Other uses of this VPN
This VPN can also be used for other purposes: for building a LAN for playing with friends on PC, giving yourself access to your local network if you have a machine at home. I personnaly use it when working on projects with my friends so that we can code on the same machine.

You can also stream more efficiently Steam to a remote computer: if you are using steam remote play over the internet the computer that is streaming has quite an heavy load ass it has to decode the streaming flux coming from steam server: even if you are using the VPN the computer running the game will be sending the video flux to steam servers and that will be redirected to the streaming computer, by putting steam in offline mode on the computer running the game you will force the video flux to pass through the VPN directly and decrease the decoding load on the computer streaming the game: good to know if you are streaming from a potatoe. 

