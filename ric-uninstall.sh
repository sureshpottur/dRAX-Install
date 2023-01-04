# Ric uninstall 
#check Ric installed or not
helm list --all | grep ric
if [ $? -eq 0 ]; then
    printf "\n\n ##### Proceeding with Ric un-installation ######\n\n"
    helm uninstall ric
else
    printf "\n\n ##### Ric is not installed to un-install ######\n\n"
fi
