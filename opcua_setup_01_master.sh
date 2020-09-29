#!/bin/bash
sudo apt-get install net-tools openssh-server make gcc libncurses5-dev bison flex libelf-dev irqbalance linuxptp daemonize libmbedtls-dev vlan libssl-dev cmake-curses-gui g++ gnuplot curl ethtool clang llvm -y
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nomodeset/' /etc/default/grub
sudo update-grub
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& isolcpus=1,2,3/' /etc/default/grub
sudo update-grub
sudo sed -i '/IRQBALANCE_BANNED_CPUS=/c\IRQBALANCE_BANNED_CPUS=e' /etc/default/irqbalance
git clone https://git.kernel.org/pub/scm/network/iproute2/iproute2.git
cd iproute2/
make all
sudo make install
cd ../
git clone https://github.com/richardcochran/linuxptp.git
cd linuxptp/
git checkout -f 059269d0cc50f8543b00c3c1f52f33a6c1aa5912
make
sudo make install
sudo cp configs/gPTP.cfg /etc/linuxptp/
cd ../
git clone https://github.com/open62541/open62541.git
CWD_SETUP=$(pwd)
cd /usr/local/src/
sudo git clone https://github.com/xdp-project/bpf-next.git
cd bpf-next/
sudo git checkout 84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d
sudo make defconfig
sudo make headers_install
cd samples/bpf
sudo make
sudo echo "8021q" >> /etc/modules
cd $CWD_SETUP
sudo rm /etc/netplan/01-network-manager-all.yaml
sudo cp 01-network-manager-all.yaml.master /etc/netplan/01-network-manager-all.yaml
sudo netplan generate
sudo netplan apply
sudo cp rc.local.master /etc/rc.local
sudo chmod +x /etc/rc.local
sudo reboot

