
## Remove a full Kubernetes installation ##

# Check K8's connectivity
if ! kubectl get ns default >/dev/null 2>&1; then
  printf '\n\n#### Kubernetes not installed to  un-install ####\n\n' >&2
else
  printf 'kubernetes connectivity using kubectl...\n'
  kubectl get ns default

  echo "Proceeding with Kubernetes uninstall\n"

  yes | sudo kubeadm reset

  yes | sudo apt-get purge kubeadm 

  yes | sudo apt-get purge kubectl 

  yes | sudo apt-get purge kubelet

  yes | sudo apt-get purge kubernetes-cni

  yes | sudo rm -rf ~/.kube

  yes | sudo rm -rf /etc/cni/net.d

  yes | sudo ip link delete cni0

  yes | sudo ip link delete flannel.1

  sleep 1

  rm -rf kube-flannel.yml

  printf "\n#### Kubernetes Uninstalled successfully ####\n\n"
fi
