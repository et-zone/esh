#!/bin/bash

Nspace="go-micro"
read -p "Please input your micro Namespace:<defaule='go-micro'>" Nspace

if $Nspace; then
	Nspace="go-micro"
fi
echo "NamseSpace = $Nspace"

cat >~/.k8sMicro/namespace.yaml <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $Nspace
  namespace: $Nspace
EOF

cat >~/.k8sMicro/pod-rbac.yaml <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: micro-registry
  namespace: $Nspace
rules:
  - apiGroups:
      - ""
    resources:
      - pods
    verbs:
      - get
      - list
      - patch
      - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: micro-registry
  namespace: $Nspace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: micro-registry
subjects:
  - kind: ServiceAccount
    name: micro-services
    namespace: $Nspace
---
apiVersion: v1
kind: ServiceAccount
metadata:
  namespace: $Nspace
  name: micro-service
EOF

cat >~/.k8sMicro/configmap-rbac.yaml <<EOF
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: micro-config
  namespace: $Nspace
  labels:
    app: go-micro-config
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "update", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: micro-config
  namespace: $Nspace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: micro-config
subjects:
  - kind: ServiceAccount
    name: micro-services
    namespace: $Nspace
---
apiVersion: v1
kind: ServiceAccount
metadata:
  namespace: $Nspace
  name: micro-services
EOF

# install NameSpace Rpc Pod

if test -d ~/.k8sMicro; then
	echo ""
else
	mkdir ~/.k8sMicro
fi

kubectl apply -f ~/.k8sMicro/namespace.yaml

while ((1)); do
	if kubectl get ns | grep $Nspace | grep Active; then
		echo ""
		break
	else
		echo "not Active, Waiting..."
		sleep 1
	fi

done

kubectl apply -f ~/.k8sMicro/configmap-rbac.yaml
kubectl apply -f ~/.k8sMicro/pod-rbac.yaml
