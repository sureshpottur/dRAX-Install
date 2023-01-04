#Control Unit Installation
export DOCKER_USER=$(sed -n '/DOCKER_USER/ s/^.*=//p' "$(pwd -P)/params_drx")
export DOCKER_PASS=$(sed -n '/DOCKER_PASS/ s/^.*=//p' "$(pwd -P)/params_drx")
export DOCKER_EMAIL=$(sed -n '/DOCKER_EMAIL/ s/^.*=//p' "$(pwd -P)/params_drx")

# Prepare the config values file
export ip_rangae=$(sed -n '/ip_range/ s/^.*=//p' "$(pwd -P)/params_drx")
export kubeIp=$(sed -n '/kubeIp/ s/^.*=//p' "$(pwd -P)/params_drx")
export cucpinstance=$(sed -n '/cucpinstance/ s/^.*=//p' "$(pwd -P)/params_drx")
export cuupinstance=$(sed -n '/cuupinstance/ s/^.*=//p' "$(pwd -P)/params_drx")
export numOfAmfs=$(sed -n '/numOfAmfs/ s/^.*=//p' "$(pwd -P)/params_drx")
export numOfCuUps=$(sed -n '/numOfCuUps/ s/^.*=//p' "$(pwd -P)/params_drx")
export numOfDus=$(sed -n '/numOfDus/ s/^.*=//p' "$(pwd -P)/params_drx")
export numOfCells=$(sed -n '/numOfCells/ s/^.*=//p' "$(pwd -P)/params_drx")
export numOfUes=$(sed -n '/numOfUes/ s/^.*=//p' "$(pwd -P)/params_drx")
export natsUrl=$kubeIp
export redisHostname=$kubeIp

export cucp_nodePort=$(sed -n '/cucp_nodePort/ s/^.*=//p' "$(pwd -P)/params_drx")
export cuup_nodePort=$(sed -n '/cuup_nodePort/ s/^.*=//p' "$(pwd -P)/params_drx")

export sctp_f1_ip=$(sed -n '/sctp_f1_ip/ s/^.*=//p' "$(pwd -P)/params_drx")
export sctp_e1_ip=$(sed -n '/sctp_e1_ip/ s/^.*=//p' "$(pwd -P)/params_drx")

#versions
export cu_version=$(sed -n '/cu_version/ s/^.*=//p' "$(pwd -P)/params_drx")

helm version
if [ $? -eq 127 ]; then
    printf "\n No hem avilable to proceed further.. Exiting\n"
    exit
fi

#create accelleran-secret
kubectl create secret docker-registry accelleran-secret --docker-server=docker.io --docker-username=DOCKER_USER --docker-password=$DOCKER_PASS --docker-email=$DOCKER_EMAIL

#Helm repositories update with 5g-helm-charts
helm repo add acc-5g-helm https://accelleran.github.io/5g-helm-charts

printf "\n\n #### Helm repo added with 5g-helm-charts ####\n\n"

helm repo update
sleep 5

if [ ! -z "$check_ns" ] ;then
    echo "default name space already avilable"
else
    echo "creating default name space"
    kubectl create namespace $NS_DRAX
fi

#helm install fiveg-infrastructure acc-5g-helm/acc-5g-infrastructure --values acc-5g-infrastructure-values.yaml --namespace default

sleep 5

# 5G CU-CP Config

curl https://raw.githubusercontent.com/accelleran/5g-helm-charts/4/acc-5g-infrastructure/values.yaml > acc-5g-infrastructure-values.yaml
if [ -n "$ip_range" ]; then
    printf " configuring the Load Balancer IP pool  with => $ip_range\n"
    sed -i '/^metallb:/{n;n;n;n;n;n;n;n;n;n;n;s/:.*/          - $ip_range/;}' acc-5g-infrastructure-values.yaml
fi

helm install fiveg-infrastructure acc-5g-helm/acc-5g-infrastructure --version 3.0.0 --values acc-5g-infrastructure-values.yaml

sleep 10

# Prepare the config values file
if [ -n "$kubeIp" ]; then
    printf " configuring the kubeIp with => $kubeIp\n"
    sed -i '/^global:/{n;s/kubeIp:.*/kubeIp: '$kubeIp'/;}' acc-5g-cu-cp-values.yaml
    sed -i '/^global:/{n;s/kubeIp:.*/kubeIp: '$kubeIp'/;}' acc-5g-cu-up-values.yaml
fi
if [ -n "$cucp-instance" ]; then
    printf " configuring the cucp-instance with => ${cucpinstance}\n"
    printf " configuring the cuup-instance with => ${cuupinstance}\n"
    sed -i '/^global:/{n;n;s/instanceId:.*/instanceId: '$cucpinstance'/;}' acc-5g-cu-cp-values.yaml
    sed -i '/^global:/{n;n;s/instanceId:.*/instanceId: '$cuupinstance'/;}' acc-5g-cu-up-values.yaml
fi
if [ -n "$numOfAmfs" ]; then
    printf " configuring the numOfAmfs with => $numOfAmfs\n"
    sed -i '/^global:/{n;n;n;s/numOfAmfs:.*/numOfAmfs: '$numOfAmfs'/;}' acc-5g-cu-cp-values.yaml
fi
if [ -n "$numOfCuUps" ]; then
    printf " configuring the numOfCuUps with => $numOfCuUps\n"
    sed -i '/^global:/{n;n;n;n;s/numOfCuUps:.*/numOfCuUps: '$numOfCuUps'/;}' acc-5g-cu-cp-values.yaml
fi
if [ -n "$numOfDus" ]; then
    printf " configuring the numOfDus with => $numOfDus\n"
    sed -i '/^global:/{n;n;n;n;n;s/numOfDus:.*/numOfDus: '$numOfDus'/;}' acc-5g-cu-cp-values.yaml
fi
if [ -n "$numOfCells" ]; then
    printf " configuring the numOfCells with => $numOfCells\n"
    sed -i '/^global:/{n;n;n;n;n;n;s/numOfCells:.*/numOfCells: '$numOfCells'/;}' acc-5g-cu-cp-values.yaml
fi
if [ -n "$numOfUes" ]; then
    printf " configuring the numOfUes with => $numOfUes\n"
    sed -i '/^global:/{n;n;n;n;n;n;n;s/numOfUes:.*/numOfUes: '$numOfUes'/;}' acc-5g-cu-cp-values.yaml
fi
if [ -n "$natsUrl" ]; then
    printf " configuring the natsUrl with => $natsUrl\n"
    sed -i '/^global:/{n;n;n;n;n;n;n;n;n;s/natsUrl:.*/natsUrl: '$natsUrl'/;}' acc-5g-cu-cp-values.yaml
    sed -i '/^global:/{n;n;n;n;s/natsUrl:.*/natsUrl: '$natsUrl'/;}' acc-5g-cu-up-values.yaml
fi
if [ -n "$redisHostname" ]; then
    printf " configuring the redisHostname with => $redisHostname\n"
    sed -i '/^global:/{n;n;n;n;n;n;n;n;n;n;s/redisHostname:.*/redisHostname: '$redisHostname'/;}' acc-5g-cu-cp-values.yaml
    sed -i '/^global:/{n;n;n;n;n;s/redisHostname:.*/redisHostname: '$redisHostname'/;}' acc-5g-cu-up-values.yaml
fi
if [ -n "$nodePort" ]; then
    printf " configuring the netconf nodePort with => $nodePort\n"
    sed -i '/^netconf:/{n;n;s/nodePort:.*/nodePort: '$cucp_nodePort'/;}' acc-5g-cu-cp-values.yaml
    sed -i '/^netconf:/{n;n;s/nodePort:.*/nodePort: '$cuup_nodePort'/;}' acc-5g-cu-up-values.yaml
fi
if [ -n "$sctp_f1_ip" ]; then
    printf " configuring the sctp-f1 loadBalancerIP with => $sctp_f1_ip\n"
    sed -i '/^sctp-f1:/{n;n;s/loadBalancerIP:.*/loadBalancerIP: '$sctp_f1_ip'/;}' acc-5g-cu-cp-values.yaml
fi
if [ -n "$sctp_e1_ip" ]; then
    printf " configuring the sctp-e1 loadBalancerIP with => $sctp_e1_ip\n"
    sed -i '/^sctp-e1:/{n;n;s/loadBalancerIP:.*/loadBalancerIP: '$sctp_e1_ip'/;}' acc-5g-cu-cp-values.yaml
fi

# 5G CU-UP Config
#curl https://raw.githubusercontent.com/accelleran/5g-helm-charts/4/acc-5g-cu-cp/values.yaml > acc-5g-cu-cp-values.yaml
#curl https://raw.githubusercontent.com/accelleran/5g-helm-charts/4/acc-5g-cu-up/values.yaml > acc-5g-cu-up-values.yaml

#Install 5G CU Components
printf "\n\n proceeding with CU-CP installation \n\n"
helm install acc-5g-cu-cp acc-5g-helm/acc-5g-cu-cp --version $cu_version --values acc-5g-cu-cp-values.yaml

sleep 2
printf "\n\n proceeding with CU-UP installation \n\n"
helm install acc-5g-cu-up acc-5g-helm/acc-5g-cu-up --version $cu_version --values acc-5g-cu-up-values.yaml

sleep 10
kubectl get pods,svc
