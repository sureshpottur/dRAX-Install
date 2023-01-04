## Install Kubernetes in a VM ##

if [ -x "$(command -v docker)" ]; then
    continue
else
    printf "\n#### Please install docker before proceeding with Kubernetes ####\n\n"
    exit 1
fi

export POD_NETWORK='10.244.0.0/16'
export NODE_IP='10.0.120.6'
printf "\033[0;31m Before proceeding check the entered POD_NETWORK=${POD_NETWORK} and NODE_IP=${NODE_IP} are correct \033[0;37m (y/n)? "
read answer

## Create a sample Busy box pod
pod_busy_box()
{
    cat<< EOF >> /tmp/busybox.yaml
    apiVersion: v1
    kind: Pod
    metadata:
     name: busybox
     namespace: default
    spec:
     containers:
     - name: busybox
       image: busybox:1.28
       command:
         - sleep
         - "3600"
       imagePullPolicy: IfNotPresent
     restartPolicy: Always
EOF
kubectl --kubeconfig $HOME/.kube/config create -f /tmp/busybox.yaml
sleep 10
kubectl --kubeconfig $HOME/.kube/config get pods
}
#Checks if package is in the repo's by performing a dry run. Then checks the  error code is 100 (failed due to package not found) and invoking a cache search if so else it just installs the package.
perform_apt_update() {
  sudo apt-get -qq --dry-run install $1
  if [ $? == 100 ]; then
    sudo apt-cache search $1
  else
    sudo apt-get install $1
  fi
}
# Check Node Id and Pod Network info
if [ "$answer" != "${answer#[Nn]}" ] ;then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
    printf "\033[0;35m User selected No : Before re-run the script please correct POD_NETWORK and NODE_IP values \033[0;37m"
else
    echo "\nUser selected Yes\n"
    if ! kubectl get ns default >/dev/null 2>&1; then
       printf '\n\n#### Proceeding with Kubernetes Installation ####\n\n' >&2

      # Add the Kubernetes APT repository
      sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
      echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
      perform_apt_update     
      sleep 1

      #Accelleran dRAX currently supports Kubernetes up to version 1.20
      sudo apt install -y kubelet=1.20.0-00 kubeadm=1.20.0-00 kubectl=1.20.0-00 --allow-change-held-packages
      sudo apt-mark hold kubelet kubeadm kubectl


      ## Configure Kubernetes ##
      #nitialize the cluster on this node
      sudo kubeadm init --pod-network-cidr=$POD_NETWORK --apiserver-advertise-address=$NODE_IP
      sleep 1


      #To make kubectl work for our non-root user
      mkdir -p "$HOME/.kube"
      sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"

      ## Install Flannel ##

      #Prepare the Manifest file:
      curl -sSOJ https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
      sed -i '/net-conf.json/,/}/{ s"$POD_NETWORK"; }' kube-flannel.yml

      sleep 1
      #Apply the Manifest file:
      kubectl apply -f kube-flannel.yml

      #Enable Pod Scheduling
      kubectl taint nodes --all node-role.kubernetes.io/master-

      sleep 12
    
      pod_busy_box
      sleep 10
      kubectl --kubeconfig $HOME/.kube/config get pods

      printf "\n\n#### Kubernetes Installed successfully ####\n"
    else
      printf "\n\n#### Kubernetes already connected ####\n"
      kubectl get ns default
    fi
fi

#End
