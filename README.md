# PS4 and PS5: Improving your PS remote play experience:

This guide will allow you to improve your experience of PS remote play, reduce the load of sony's servers and tap into the world of raspberry pi while sitting on your couch and playing your PS4 or 5 from anywhere. Hooked already? well here's how to do it:

As I wasn't able to find online the full explanation on how to solve this problem. Me and my brother decided to note down the steps that allowed us to completely tackle some issues with the PS remote play.

Playstation gives an amazing feature to all its users by enabling them to [play on their playstation from afar](https://remoteplay.dl.playstation.net/remoteplay/lang/en/index.html). My brother and I discovered this functionnality during the quarantines in Europe for the Coronavirus. Thanks to it we were able to both play the playstation (not at the same time of course) while being physically separated. 
To put it simple the feature allows you to stream your ps4 on any device, your computer for instance. As this is streaming only you don't need huge specs on the client devices ([here are the ones for windows](https://remoteplay.dl.playstation.net/remoteplay/lang/gb/ps4_win.html) as an example), just a solid connection (15 Mb/s according to sony's website). You can test your speed by making a speed test

Although this tool is incredible and useful, it has a few drawbacks:

When playing remotly localy (ie on the same network):
* There are no connectivity issues and it works very well, capped at 720p and 30fps per second for a regular ps4 and, 1080p and 60fps for a PS4 pro and PS5

The problems arise when playing on a remote network:
* It requires a very high speed internet on both sides
* Even if there are high speed networks, you are depend on the sony server that allows you to communicate to the playstations
* Sony's server are a limited ressource, the more users for remote play, the lesser the quality will be

To give you an idea: although having very high speed on both side, we were only able to run the PS4 remotely at 540p (which is sad really since most of PS4 games are made for 1080p) and 30fps.
Trying to go as high as 720p remotly was constantly disconnecting (probably due to our internet connection not being that fast probably)


Using our solution we were able to make the remote play running at 720p all the time from afar without any connectivity issues with a safe encrypted connection. It requires to buy some equipment but it is not very expensive and we found for you the cheapest one.


# Explanation of the solution:
Some of you might have guessed it from the beginning our goal here is to make the remote play locally even if you are located on another network, to bypass sony's server (which they should be thankful as it reduces their load ;) ) and to connect almost directly your computer to the PS4 or 5.
To acheive so we have to connect securily the device you are streaming on to the network of the playstation, and we will acheive this building a VPN server here is a drawing explaining the principle of the solution



We will offer you 2 solutions depending on your usage: 
* A quick and dirty one that is very easy but that has some disavantages (touchpad not working... for now), you only have this solution if the remote pc is running on linux
* A more complex one that enables you to have the full experience of the playstation remote play but that is a bit trickier to set up




# Equipment needed:
Of course you will need some extra devices, setting a VPN server requires a machine to run full time but we have one that is consumming the equivalent of a lamp, and some cables if you don't already have them.
You will need:
* An internet router with a solid connection (15 Mb/s according to sony's website)
* A fully operationnal [raspberry pi 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/?resellerType=home)(4 Gb of RAM is enough, 2Gb of RAM might be as well), with its power supply and an SD card of 16Gb with the Raspberry Pi OS on it.
If you don't feel like burning the OS yourself on a the SD card, you can buy SD cards with the OS preinstalled as described [here](https://www.raspberrypi.org/downloads/noobs/), no judgement here.
* A keyboard and a mouse (only for the installation not the usage)
* An ethernet cable to link the Raspberry to your router
* A second ethernet cable (if you don't already have it) to wire your playsation to the router as well
* A PC on a remote network


# First steps that are common to all the solutions
* [Get you raspberry pi up and running the Raspberry pi OS](https://magpi.raspberrypi.org/articles/set-up-raspberry-pi-4) you can find a lot of tutorials on the web for this and I will not be covering this here 
* Open a port on your router for the VPN connection




# Quick and dirty solution
This one is fast and might give you a taste of the improvement you can experience using the VPN but it doesn't completely support all the controler's keys, it is the only solution availble with linux users.
I will advise it just for testing the solution before implementing the second one







