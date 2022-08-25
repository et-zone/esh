### 快速安装k8s
- root用户登录
- `curl -L https://raw.githubusercontent.com/et-zone/esh/master/k8s/microK8sInstall.sh -o microK8sInstall.sh && sh microK8sInstall.sh`
- 安装完成后将 snap 环境变量配置永久： `vi ~/.bashrc`
  - 修改环境变量 `export PATH=$PATH:~/.jx/bin:/snap/bin`
  - 即时生效    `source ~/.bashrc` 
