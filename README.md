# Raspberry Pi image with HashiCorp Packer

In this wiki I will show you how to create a custom Raspberry PI Images with HashiCorp Packer. The image will have SSH enabled ,Default jre,Node js,Redis server, Access point and wifi enabled and docker already installed when you boot up your Raspberry Pi. Everything is done in Ubuntu. (28.04.2020).

## Contents

- [Raspberry Pi image with HashiCorp Packer](#raspberry-pi-image-with-hashicorp-packer)
  - [Contents](#contents)
  - [Setup](#setup)
  - [Steps](#steps)
  - [Install HashiCorp Packer](#install-hashicorp-packer)
  - [Install GoLang](#install-golang)
  - [Install Packer ARM builder](#install-packer-arm-builder)
  - [Create the ARM image with Packer](#create-the-arm-image-with-packer)
  - [Conclusion](#conclusion)

## Setup

- Windows 10 with a clean Ubuntu 18.04.3 server installation.
- Raspberry Pi 4

## Steps

- Install [HashiCorp](https://www.packer.io/) Packer 1.3.5
- Install [Go](https://golang.org/) above version 1.11
- Install [Packer](https://github.com/solo-io/packer-builder-arm-image) ARM builder
- Build the image

## Install HashiCorp Packer

Download Packer from HashiCorp in Version 1.3.5. Do not install version 1.4.5. since it is not compatible with the ARM builder version we are going to use for Packer. Unzip the package in /usr/local/packer.

1. Update apt-get dependencies

    ```sh
    sudo apt-get update
    ```

1. Install unzip

    ```sh
    sudo apt-get install -y unzip
    ```

1. Download Packer from HashiCorp

    ```sh
    wget https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_linux_amd64.zip
    ```

1. Unpack Packer

    ```sh
    sudo unzip packer_1.3.5_linux_amd64.zip -d /usr/local/packer
    ```

1. Cleanup your workspace and delete the archive

    ```sh
    rm packer_1.3.5_linux_amd64.zip
    ```

1. Add it to the PATH

    ```sh
    sudo -i
    printf '#!/bin/bash \nexport PATH=$PATH:/usr/local/packer \n' > /etc/profile.d/packer.sh
    ```

1. Logout by pressing STRG+D

    ```sh
    source /etc/profile.d/packer.sh
    ```

1. Check if Packer works

    ```sh
    packer version
    ```

## Install GoLang

Install GoLang above version 1.11 since it adds module support.

1. Download Go from google

    ```sh
    wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
    ```

1. Unpack go

    ```sh
    tar xvf go1.13.4.linux-amd64.tar.gz
    ```

1. Change the owner

    ```sh
    sudo chown -R root:root ./go
    ```

1. move it

    ```sh
    sudo mv go /usr/local
    ```
 
1. Cleanup your workspace and delete the archive

    ```sh
    rm go1.13.4.linux-amd64.tar.gz
    ```

1. Add it to the PATH

    ```sh
    sudo -i
    printf '#!/bin/bash \nexport GOPATH=$HOME/work \nexport PATH=$PATH:/usr/local/go/bin:$GOPATH/bin \n' > /etc/profile.d/go.sh
    ```

1. Logout by pressing STRG+D

    ```sh
    source /etc/profile.d/go.sh
    ```

1. Check if Go works

    ```sh
    go version
    ```

## Install Packer ARM builder

1. Install dependencies for ARM builder

    ```sh
    sudo apt-get install -y kpartx qemu-user-static
    ```

1. Clone repository

    ```sh
    git clone https://github.com/solo-io/packer-builder-arm-image
    ```

1. Checkout the commit that worked for me

    ```sh
    cd packer-builder-arm-image
    git checkout b1c268e9d33105634c899e9095f0af097e1af432
    ```

1. Build the Packer ARM builder

    ```sh
    go mod download
    go build
    ```

1. Copy the finished build to Packer directory

    ```sh
    sudo cp packer-builder-arm-image /usr/local/packer/
    ```

1. Cleanup your workspace and delete the source

    ```sh
    cd ..
    sudo rm -r packer-builder-arm-image/
    ```

## Create the ARM image with Packer

Now it is time to build the image for the Raspberry PI. The image will have SSH enabled and docker already installed. It is necessary to be root user. Create a json file for packer.

```sh
sudo -i
nano raspberrypi-docker.json
```
[raspberrypi-docker.json](uploads/8db4eb5faa8348cf3ba0175a9748231b/raspberrypi-docker.json)

[apandwifi.sh](uploads/aaec69a8565b8f8f3e7841a9f1e1654a/apandwifi.sh)

[base.sh](uploads/c14f70d6b281f7ab039df3c8fc4ac808/base.sh)

[cleanup.sh](uploads/f9e72a638c4445bde8742ca17c315396/cleanup.sh)

[jre.sh](uploads/01b2714589c3c459fdbd3f185ccb8d57/jre.sh)

[node.sh](uploads/7dae618ff7f2dbf10adaf29fb514e1a0/node.sh)

[redis.sh](uploads/7f67d373deca5de2fdc6c874810bc649/redis.sh)

This configuration file tells packer to downloads the Raspbian OS image. Packer checks the checksum and starts the scrips commands. Now run packer to build the image (as root user):


keep the above files in Scripts folder.
```sh
packer build raspberrypi-docker.json
```

Ignore errors and warnings if the image was created…

```sh
Build 'arm-image' finished.
==> Builds finished. The artifacts of successful builds are:
--> arm-image: output-arm-image/image
```

The image is located under ./output-arm-image/image Copy it with WinSCP or any other tool to windows. Rename it to raspberry-pi-with-ssh-and-docker.bin
Now we can use “balenaEtcher” to write the image to the Raspberry Pi.

SSH is enabled and docker should work out of the box.

## Conclusion
Building an ARM Image with HashiCorp Packer isn’t that hard. With this example we get an Raspberry Pi image with enabled SSH enabled ,Default jre,Node js,Redis server, Access point and wifi enabled and docker already installed. Flashing it to the SD Card, plugging it in and everything works as expected.

Since the image is always the same, the network name will always be the same and has to be changed manually or with some script.
