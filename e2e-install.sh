# Script to install Docker, Kubernetes, Helm, RIC, CU-CP and CU-CP components

printf "\n\n---------------------------------------------------------------------------------------------\n\n"
printf "Trigger Docker Installation"
printf "\n---------------------------------------------------------------------------------------------\n\n"
./docker-install.sh

sleep 5
printf "\n\n---------------------------------------------------------------------------------------------\n\n"
printf "Trigger Kubernetes Installation"
printf "\n---------------------------------------------------------------------------------------------\n\n"
./k8s-install.sh

sleep 5
printf "\n\n---------------------------------------------------------------------------------------------\n\n"
printf "Trigger Helm Installation"
printf "\n---------------------------------------------------------------------------------------------\n\n"
./helm-install.sh

sleep 5
printf "\n\n---------------------------------------------------------------------------------------------\n\n"
printf "Perform Docker Login"
printf "\n---------------------------------------------------------------------------------------------\n\n"
./check-docker.sh

sleep 5
printf "\n\n---------------------------------------------------------------------------------------------\n\n"
printf "Trigger Ric Installation"
printf "\n---------------------------------------------------------------------------------------------\n\n"
./ric-install.sh

sleep 5
printf "\n\n---------------------------------------------------------------------------------------------\n\n"
printf "Trigger Control Unit (CU-CP and CU-UP) Installation"
printf "\n---------------------------------------------------------------------------------------------\n\n"



