#!/bin/bash

#Checks if package is in the repo's by performing a dry run. Then checks the  error code is 100 (failed due to package not found) and invoking a cache search if so else it just installs the package.
perform_apt_update() {
	printf "\n\n##### Triggered apt update #####\n\n"
	sudo apt-get -qq --dry-run install $1
        if [ $? == 100 ]; then
		sudo apt-cache search $1
        else
                sudo apt-get install $1
        fi
}


docker -v
if [[ $(which docker) && $(docker --version) ]]; then
    printf "\n#### Docker avilable and Continuing with configuration ####\n"
else
    printf "\n#### The program 'docker' is currently not installed. ####\n"
#install docker
echo "\n\n-----------------------------------------------------------------------------------------------------------------------------------\n\n"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable nightly"
printf "\n\n-----------------------------------------------------------------------------------------------------------------------------------\n\n"

#sudo apt update
perform_apt_update

yes | sudo apt install docker-ce 
yes | sudo apt install docker-ce-cli 
yes | sudo apt install containerd.io 
yes | sudo apt install docker-compose
fi

#run the NW profile

sudo usermod -aG docker $USER
sleep 10
docker run hello-world


# Docker daemon configuration

sudo mkdir /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sleep 5
# Docker container start automatically on system boot
sudo systemctl enable docker
sleep 5
sudo systemctl daemon-reload
sleep 5
sudo systemctl restart docker
sleep 10

#sudo systemctl status docker

sleep 5
echo "/n/n#### Docker configured successfully ####/n/n"
