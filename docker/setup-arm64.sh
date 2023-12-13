#!/bin/bash

set -eu

export DEBIAN_FRONTEND=noninteractive

apt-get update &&
  yes | unminimize

# include multiarch support
apt-get update &&
  apt-get -y install binfmt-support &&
  dpkg --add-architecture amd64 &&
  apt-get update &&
  apt-get -y upgrade

# set up default locale
apt-get update && apt-get -y install locales
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8

# install GCC-related packages
apt-get update && apt-get -y install build-essential binutils-doc cpp-doc gcc-doc g++ gdb gdb-doc glibc-doc libblas-dev liblapack-dev liblapack-doc libstdc++-10-doc make make-doc

# install programs used for system exploration
apt-get -y install blktrace linux-tools-generic strace tcpdump htop

apt-get install -y python3 \
  python3-pip \
  python3-dev \
  python3-setuptools \
  python3-venv

# install interactive programs (emacs, vim, nano, man, sudo, etc.)
apt-get -y install bc curl dc git git-doc man micro nano psmisc sudo wget screen tmux emacs-nox vim \
  jq

# Install golang
bash -c "mkdir /usr/local/go && wget -O - https://go.dev/dl/go1.21.0.linux-arm64.tar.gz | sudo tar -xvz -C /usr/local"

# set up libraries
apt-get -y install libreadline-dev wamerican libssl-dev protobuf-compiler libprotobuf-dev

# install programs used for networking
apt-get -y install dnsutils inetutils-ping iproute2 net-tools netcat telnet time pv traceroute iptables

# install GCC-related packages for amd64
apt-get -y install g++-9-x86-64-linux-gnu gdb-multiarch libc6:amd64 libstdc++6:amd64 libasan5:amd64 libtsan0:amd64 libubsan1:amd64 libreadline-dev:amd64 libblas-dev:amd64 liblapack-dev:amd64

for i in addr2line c++filt cpp-9 g++-9 gcc-9 gcov-9 gcov-dump-9 gcov-tool-9 size strings; do
  ln -s /usr/bin/x86_64-linux-gnu-$i /usr/x86_64-linux-gnu/bin/$i
done &&
  ln -s /usr/bin/x86_64-linux-gnu-cpp-9 /usr/x86_64-linux-gnu/bin/cpp &&
  ln -s /usr/bin/x86_64-linux-gnu-g++-9 /usr/x86_64-linux-gnu/bin/c++ &&
  ln -s /usr/bin/x86_64-linux-gnu-g++-9 /usr/x86_64-linux-gnu/bin/g++ &&
  ln -s /usr/bin/x86_64-linux-gnu-gcc-9 /usr/x86_64-linux-gnu/bin/gcc &&
  ln -s /usr/bin/x86_64-linux-gnu-gcc-9 /usr/x86_64-linux-gnu/bin/cc &&
  ln -s /usr/bin/gdb-multiarch /usr/x86_64-linux-gnu/bin/gdb

# set up default locale
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8

# Rust
export RUSTUP_HOME=/opt/rust
export CARGO_HOME=/opt/rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sudo -E sh -s -- -y

echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

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
