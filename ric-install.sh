# Drax Installation

NS_DRAX=default
RIC_VERSION=6.0.0
export NS_DRAX=$NS_DRAX
export RIC_VERSION=$RIC_VERSION
export check_ns=$(kubectl get ns | grep default)

if [ ! -z "$check_ns" ] ;then
    echo "default name space already avilable"
else
    echo "creating default name space"
    kubectl create namespace $NS_DRAX
fi

curl https://raw.githubusercontent.com/accelleran/helm-charts/${RIC_VERSION}/ric/simple-values/simple-values.yaml  > ric-values.yaml

# update the ric-values.yaml
#find ric-values.yaml -type f -exec sed -i 's/user/<NewUser>/g; s/welcome/<newPassword>/g' {} \;

#check helm is avilable to proceed ric installation
helm version
if [ $? -eq 127 ]; then
    echo "\n\n#### No Helm Avilable... Please install helm to proceed with ric installation  ####\n\n"
else
    #Helm repositories update with 5g-helm-charts
    helm repo add acc-5g-helm https://accelleran.github.io/5g-helm-charts
    printf "\n\n #### Helm repo added with 5g-helm-charts ####\n\n"
    helm repo update
    sleep 5

    # Check Ric Instalation 
    helm list --all | grep ric
    if [ $? -eq 0 ]; then
        printf "\n\n #### Ric already avilable ####\n\n"
    else
        sleep 5
	printf "\nupdate kube ip and pod network values in ric-values.yaml\n"
	sed -i '/^global:/{n;s/kubeIp:.*/kubeIp: "10.0.120.6"/;}' ric-values.yaml
	sed -i '/^global:/{n;n;s/enable4G:.*/enable4G: false/;}' ric-values.yaml
	sed -i '/^acc-5g-infrastructure:/{n;n;n;n;n;n;n;s/.*/            - 10.55.1.20-10.55.1.62/;}' ric-values.yaml
	sleep 2

	helm install ric acc-helm/ric --version $RIC_VERSION --values ric-values.yaml -n $NS_DRAX
        
	printf "\n Lets wait for RIC microservices to come online \n"
	sleep 10
   	#check Ric installed or not
   	helm list --all | grep ric
   	if [ $? -eq 0 ]; then
	    printf "\n\n ##### Ric Installation is Successful ######\n\n"
        fi
    fi  
fi
