snap remove microk8s
curl -L "https://raw.githubusercontent.com/OpsDocker/pullk8s/main/pullk8s.sh" -o /usr/local/bin/pullk8s
chmod +x /usr/local/bin/pullk8s
snap install microk8s --classic --channel=1.21/stable
snap alias microk8s.kubectl kubectl
pullk8s pull k8s.gcr.io/pause:3.1 --microk8s
pullk8s pull k8s.gcr.io/metrics-server-amd64:v0.3.6 --microk8s
microk8s enable dashboard dns registry
