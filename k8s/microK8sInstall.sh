#!/bin/bash

# install snap ,check cmd is install

#if test -f /usr/bin/snap;then
#echo "exit"
#fi

if test -f /usr/bin/snap; then
echo "snap already installed "
else
   #echo "not found"
   yum install epel-release
   yum install yum-plugin-copr
   yum copr enable ngompa/snapcore-el7
   yum -y install snapd
   systemctl enable --now snapd.socket
   ln -s /var/lib/snapd/snap /snap
   export PATH=$PATH:~/.jx/bin:/snap/bin
fi

# install timezone ,check cmd is install

if test -f /usr/sbin/ntpdate; then
echo "ntpdate already installed "
else
   #echo "not found"
   yum install ntpdate
   ntpdate ntp.sjtu.edu.cn
   timedatectl set-timezone Asia/Shanghai
fi


if grep "SNAPPATH=" ~/.bashrc;then
echo ""
else
echo -e 'SNAPPATH=~/.jx/bin:/snap/bin \nexport PATH=$PATH:SNAPPATH' >> ~/.bashrc
fi
source ~/.bashrc

# install k8s

if test -f /snap/bin/microk8s;then
snap remove microk8s
fi

snap install microk8s --classic --channel=1.21/stable
snap alias microk8s.kubectl kubectl

if test -f /usr/local/bin/pullk8s; then
echo "pullk8s already installed "
else
   #echo "not found"
   curl -L "https://raw.githubusercontent.com/OpsDocker/pullk8s/main/pullk8s.sh" -o /usr/local/bin/pullk8s
   chmod +x /usr/local/bin/pullk8s
fi


pullk8s pull k8s.gcr.io/pause:3.1 --microk8s
pullk8s pull k8s.gcr.io/metrics-server-amd64:v0.3.6 --microk8s
microk8s enable dashboard dns registry
