#!/bin/bash

set -eu

export DEBIAN_FRONTEND=noninteractive

apt-get update &&
  yes | unminimize

# install GCC-related packages
apt-get update && apt-get -y install build-essential binutils-doc cpp-doc gcc-doc g++ g++-multilib gdb gdb-doc glibc-doc libblas-dev liblapack-dev liblapack-doc libstdc++-11-doc make make-doc locales

# set up default locale
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8

# install programs used for system exploration
apt-get -y install blktrace linux-tools-generic strace tcpdump htop

apt-get install -y python3 \
  python3-pip \
  python3-dev \
  python3-setuptools \
  python3-venv

# install interactive programs (emacs, vim, nano, man, sudo, etc.)
apt-get -y install bc curl dc git git-doc man micro nano psmisc sudo wget screen tmux emacs-nox vim jq

# Install golang
bash -c "mkdir /usr/local/go && wget -O - https://go.dev/dl/go1.21.0.linux-amd64.tar.gz | sudo tar -xvz -C /usr/local"

# set up libraries
apt-get -y install libreadline-dev locales wamerican libssl-dev protobuf-compiler libprotobuf-dev

# install programs used for networking
apt-get -y install dnsutils inetutils-ping iproute2 net-tools netcat telnet time pv traceroute iptables

# set up default locale
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8

echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

# Rust
export RUSTUP_HOME=/opt/rust
export CARGO_HOME=/opt/rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sudo -E sh -s -- -y

# ###### Graphical setup ######
# Install a demo programs (replace with necessary software, like wireshark)
apt-get -y install xterm wireshark

# Install xpra (used for backup display method if X11 forwarding doesn't work)
UBUNTU_VERSION=$(cat /etc/os-release | grep UBUNTU_CODENAME | sed 's/UBUNTU_CODENAME=//') &&
  curl http://xpra.org/gpg.asc | apt-key add - &&
  echo "deb http://xpra.org/ $UBUNTU_VERSION main" >>/etc/apt/sources.list.d/xpra.list &&
  apt-get update &&
  apt-get install -y --no-install-recommends xpra xpra-html5 xpra-x11

# #############################

# set up passwordless sudo for user cs1680-user
useradd -m -s /bin/bash cs1680-user
echo "cs1680-user ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/cs1680-init

# Add user to the wireshark group
#groupadd wireshark
usermod -a -G wireshark cs1680-user

# create binary reporting version of dockerfile
(
  echo '#\!/bin/sh'
  echo 'echo 1'
) >/usr/bin/cs1680-docker-version
chmod ugo+rx,u+w,go-w /usr/bin/cs1680-docker-version

# set up permission for /opt/rust
chmod -R 777 /opt/rust
