# Simple & Scalable K3s Kubernetes Dev/Test/Lab-Cluster using RPi's
The idea of k3slab is to create a simple automated k3s distribution, with [nearly] no configuration needed to easily fire up a scalable development / play k3s server.

This repository contains everything to patch any gnu/systemd/linux raspberry-like image, with whatever files and stuff you need to get a k3s cluster on raspberry pi >= 3 up and running!

It's super simple:
 - You need an image to patch, like raspbian
   - Two partitions: 1st vfat "/boot" - 2nd ext4 "/" (default for rpi images i guess)
 - Patch it using the patch-script
 - Flash it to all your raspberries
 - Use /boot/k3s.config to configure your master or cluster settings
 - The k3s.service will automatically configure k3s server / agent(s)
   - The master needs to be resolvable as short-name "master" in your network, by default
   - Agents will generate a random hostname, like "agent-xY3z"

# TODO's
 - pre-built images
 - Dockerfile

# Requirements: 
## Software [in your linux image]
 - wget
 - bash
 - systemd [need to fix that]

## Hardware
 - 2 or more raspberry pi ~3 like soc's
 - one [micro] SD-card per soc, flashed with the patched image
 - ethernet cable network [or you build a custom image with wifi support - contributions welcome!]

## Network [!]
   - Random DHCP server
   - Dynamic DNS for all DHCP clients (like 'my-computer.lan', 'whatever.domain' or 'idk.fritzbox')
   - Internet connection, k3s will bootstrap from the official rancher k3s github repo / releases

# Configure / Modify K3slab image
Simple stuff can be configured by modifying `root/boot/k3s.config`. You can also change it later [even on window$], by inserting the flashed [micro] sd-card into your PC & editing `/boot/k3s.config`

# Contributions / Issues Welcome
