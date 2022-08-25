#!/bin/bash

# install snap ,check cmd is install
cmd1=`snap`

if [[$cmd1==snap:*]]; then
   #echo "not found"
   yum install epel-release
   yum install yum-plugin-copr
   yum copr enable ngompa/snapcore-el7
   yum -y install snapd
   systemctl enable --now snapd.socket
   ln -s /var/lib/snapd/snap /snap
   export PATH=$PATH:~/.jx/bin:/snap/bin
else
echo "snap already installed "
fi

# install timezone ,check cmd is install
cmd2=`ntpdate`  

if [[$cmd2==ntpdate:*]]; then
   #echo "not found"
   yum install ntpdate
   ntpdate ntp.sjtu.edu.cn
   timedatectl set-timezone Asia/Shanghai
else
echo "ntpdate already installed "
fi

cmd3=`pullk8s`

if [[$cmd3==pullk8s:*]]; then
   #echo "not found"
   curl -L "https://raw.githubusercontent.com/OpsDocker/pullk8s/main/pullk8s.sh" -o /usr/local/bin/pullk8s
   chmod +x /usr/local/bin/pullk8s
else
echo "pullk8s already installed "
fi

# install k8s
snap remove microk8s
snap install microk8s --classic --channel=1.21/stable
snap alias microk8s.kubectl kubectl
pullk8s pull k8s.gcr.io/pause:3.1 --microk8s
pullk8s pull k8s.gcr.io/metrics-server-amd64:v0.3.6 --microk8s
microk8s enable dashboard dns registry
