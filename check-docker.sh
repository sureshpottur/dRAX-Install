# Check the Docker credentials
docker login --help

# Check the status of the command
if [ $? -eq 0 ]; then
  # Print a success message
  echo "Docker credentials are set"
  # Set the Docker username and password
  export username="accelleranguest"
  export password="accelleran"

  # Set the Docker registry URL
  export docker_registry="https://index.docker.io/v1/"

  # Log in to Docker
  echo "$password" | docker login --username "$username" --password-stdin "$docker_registry"

  # Check the status of the command
  if [ $? -eq 0 ]; then
    # Print a success message
    echo "Successfully logged in to Docker"
  else
    # Print an error message
    echo "Error: Failed to log in to Docker"
  fi
else
  # Print an error message
  echo "Error: Docker credentials are not set"
fi

