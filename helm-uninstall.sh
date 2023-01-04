#!/bin/bash
export version=$(helm version)

if [ $? -eq 127 ]; then
	echo "\nNo Helm installed to Uninstall.. Exiting..!"
else
	echo "The program 'Helm' is currently installed.\n"
	printf "\nInstalled helm version == $version"
	sleep 1
	export path=$(which helm)
	printf "\nHelm installed path - $path"

	sudo rm -rf $path
	printf "\nHelm removed from $path"
	sleep 1
	printf "\n\n#### Helm Uninstalled successfully ####\n"
fi
