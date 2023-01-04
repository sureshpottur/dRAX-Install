#!/bin/bash

if [ -x "$(command -v docker)" ]; then
    #docker uninstall
    printf "\n#####################################################\n\n"
    dpkg -l | grep -i docker
    printf "\n#####################################################\n\n"

    sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli docker-compose-plugin
    sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce docker-compose-plugin


    sudo umount /var/lib/docker/
    sudo rm -rf /var/lib/docker /etc/docker
    sudo rm /etc/apparmor.d/docker
    sudo groupdel docker
    sudo rm -rf /var/run/docker.sock
    sudo rm -rf /usr/bin/docker-compose
    
    sudo rm /etc/apt/sources.list.d/docker.list
    sudo apt update
    sudo find /etc/apt -name '*.list' -exec grep -i 'download.docker.com' {} \; -print

    sleep 5
    printf "\n#### Checking docker uninstallation process ####\n"
   
    if [ -x "$(command -v docker)" ]; then
        printf "\n#### Docker uninstallation failed ####\n"
    else
        printf "\n#### Docker uninstallation is successful ####\n"
    fi
else
    printf "\n#### 'Docker' is currently not installed ####\n\n"
    #end
fi
