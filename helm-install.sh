#!/bin/sh

helm version
if [ $? -eq 127 ]; then
        echo "\n#### No Helm Avilable..Proceeding Helm Installation! ####\n"
	sudo apt-get update  # To get the latest package lists

	#helm install
	curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
	chmod 700 get_helm.sh
	./get_helm.sh

	#Accelleran helm chart
	helm repo add acc-helm https://accelleran.github.io/helm-charts/
	helm repo update

	sleep 2

	printf "\n\n#### Helm Installed Successfully ####\n"

	helm version
else
	echo "\n#### Helm already avilable ####\n"
fi
#end
