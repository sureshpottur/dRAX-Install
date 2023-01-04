#CU Uninstallation

#check acc-5g-cu-up installed or not
helm list --all | grep acc-5g-cu-up
if [ $? -eq 0 ]; then
    printf "\n\n ##### Proceeding with acc-5g-cu-up un-installation ######\n\n"
    helm uninstall acc-5g-cu-up
else
    printf "\n\n ##### acc-5g-cu-up is not installed to un-install ######\n\n"
fi

#check acc-5g-cu-cp installed or not
helm list --all | grep acc-5g-cu-cp
if [ $? -eq 0 ]; then
    printf "\n\n ##### Proceeding with acc-5g-cu-cp un-installation ######\n\n"
    helm uninstall acc-5g-cu-cp
else
    printf "\n\n ##### acc-5g-cu-cp is not installed to un-install ######\n\n"
fi

#check fiveg-infrastructure installed or not
helm list --all | grep fiveg-infrastructure
if [ $? -eq 0 ]; then
    printf "\n\n ##### Proceeding with fiveg-infrastructure un-installation ######\n\n"
    helm uninstall fiveg-infrastructure
else
    printf "\n\n ##### fiveg-infrastructure is not installed to un-install ######\n\n"
fi

sleep 5
