# PS4 and PS5: Improving your PS remote play experience:
This guide will allow you to improve your experience of PS remote play, reduce the load of Sony's servers and tap into the world of raspberry pi while sitting on your couch and playing your PS4 or 5 from anywhere. Hooked already? Well, here's how to do it:
As I wasn't able to find online the full explanation on how to solve this problem. My brother and I decided to note down the steps that allowed us to completely tackle some issues with the PS remote play.
PlayStation gives an amazing feature to all its users by enabling them to [play on their PlayStation from afar](https://remoteplay.dl.playstation.net/remoteplay/lang/en/index.html). My brother and I discovered this functionality during the quarantines in Europe for the Coronavirus. Thanks to it we were able to both play the PlayStation (not at the same time of course) while being physically separated. 
To put it simple the feature allows you to stream your ps4 on any device, your computer for instance. As this is streaming, you don't need huge specs on the client devices ([here are the ones for windows](https://remoteplay.dl.playstation.net/remoteplay/lang/gb/ps4_win.html) as an example), just a solid connection (15 Mb/s according to Sony's website). You can test your speed by making a speed test.

Although this tool is incredible and useful, it has a few drawbacks:
When playing remotely locally (i.e., on the same network):
* There are no connectivity issues and it works very well, capped at 720p and 30fps per second for a regular ps4 and, 1080p and 60fps for a PS4 pro and PS5
The problems arise when playing on a remote network:
* It requires a very high-speed internet on both sides
* Even if there are high-speed networks, you are dependent on the Sony server that allows you to communicate to the PlayStation.
* Sony's servers are a limited resource, the more users for remote play, the lesser the quality will be.

To give you an idea: although having very high speed on both sides, we were only able to run the PS4 remotely at 540p (which is sad really since most of PS4 games are made for 1080p) and 30fps.
Trying to go as high as 720p remotely was constantly disconnecting (potentially due to Sony's servers saturating).
<p align="center">
	<img src="./images/without_vpn.JPG">
</p>

Using our solution, we were able to make the remote play running at 720p all the time from afar without any connectivity issues with a safe encrypted connection. It requires to buy some equipment but it is not very expensive and we found for you the cheapest one.

# Explanation of the solution:
Some of you might have guessed it from the beginning our goal here is to make the remote play locally even if you are located on another network, to bypass Sony's server (which they should be thankful as it reduces their load ;) ) and to connect your computer almost directly to the PS4 or 5.
To achieve so we have to connect securely the device you are streaming on to the network of the PlayStation, and we will achieve this building a VPN server here is a drawing explaining the principle of the solution.
<p align="center">
	<img src="./images/with_vpn.JPG">
</p>


We will offer you 2 solutions depending on your usage: 
* A quick and dirty one that is very easy but that has some disadvantages (touchpad not working... for now), you only have this solution if the remote PC is running on Linux.
* A more complex one that enables you to have the full experience of the PlayStation remote play but that is a bit trickier to set up.


# Equipment needed:
Of course you will need some extra devices, setting a VPN server requires a machine to run full time but we have one that is consuming the equivalent of a lamp, and some cables if you don't already have them.
You will need:
* An internet router with a solid connection (15 Mb/s according to Sony's website)
* A fully operational [raspberry pi 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/?resellerType=home)(4 Gb of RAM is enough, 2Gb of RAM might be as well), with its power supply and an SD card of 16Gb with the Raspberry Pi OS on it.
If you don't feel like burning the OS yourself on the SD card, you can buy SD cards with the OS preinstalled as described [here](https://www.raspberrypi.org/downloads/noobs/), no judgment here.
* A keyboard and a mouse (only for the installation not the usage)
* An ethernet cable to link the Raspberry to your router
* A second ethernet cable (if you don't already have it) to wire your PlayStation to the router as well.
* A PC for configuring the raspberry and testing the VPN (a PC on a remote network and a PC on the local network is the best configuration but one PC is fine)

# First steps that are common to all the solutions
* [Get you raspberry pi up and running with the Raspberry pi OS](https://magpi.raspberrypi.org/articles/set-up-raspberry-pi-4) you can find a lot of tutorials on the web for this and I will not be covering this here. 
* Connect your raspberry pi to the router and turn it on, in order for it to get a local ip address
* On the raspberry get the local IP by typing `hostname -I` note it, it will be refered afterward as **rapsberry IP**
* If your password on the raspberry is the default one, it's time for you to change it: `passwd` default one is 'raspberry'
* [Enable SSH on your raspberry](https://www.raspberrypi.org/documentation/remote-access/ssh/) for being able to connect to it from your computer and run commands on it
* From you computer (on the local network) ssh onto the raspberry: for [windows](https://www.raspberrypi.org/documentation/remote-access/ssh/windows10.md), for [macOS](https://www.raspberrypi.org/documentation/remote-access/ssh/unix.md), and [Linux](https://www.raspberrypi.org/documentation/remote-access/ssh/unix.md) (sorry linux users, I know you know how to do it)
* Once you're connected to the rapsberry run the following command: `ifconfig | grep inet`. THe output of this command will give you the following informations. first blue rectangle is the **rapsberry IP** that you already have, second rectangle is the **netmask**, note it. The third is the **broadcast IP**, note it as well.

<p align="center">
	<img src="./images/ifconfig_output.png">
</p>

* Get your **router IP** and note it: it is most likely your **rapsberry IP** but replacing the last set of number by one (for instance in the image the router IP is 192.168.1.1). Most router have an admin server at http://**router IP**, check it out to verify your **router IP** is correct. Alternatively browsing 'my router IP "my internet provider"' will likely give you the answer
* Get your **public IP**, Google can do that for you if you just browse 'my IP address'. get the [ipv4](https://en.wikipedia.org/wiki/IP_address#IPv4_addresses) address, not the [ipv6](https://en.wikipedia.org/wiki/IP_address#IPv6_addresses)
* Get your **PS IP** (your playstation has to be connected to the lan for this), by browsing the http://**router IP** and entering your admin credentials (see your router manual for them) the interface depends on your internet^provider but the devices on the local net are often listed under a 'LAN' tab or 'my network'. Identify the one that is your PS4 and note down its IP. We will refer it as **PS IP**
So at the end of these step you are able to ssh on you raspberry that is connected to your network, and you have your **raspberry IP**, **netmask**, **broadcast IP**,**router IP**,**public IP** and **PS IP**.


# Quick and dirty solution
This one is fast and might give you a taste of the improvement you can experience using the VPN but it doesn't completely support all the controller's keys, it is the only solution available with Linux users.
I will advise it just for testing the solution before implementing the second one.
