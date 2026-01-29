terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# 1. Build the Custom Image locally
resource "docker_image" "ubuntu_ssh" {
  name = "my-ubuntu-ssh"
  build {
    context = "../images/ubuntu-ssh"
  }
}

# 2. Create a Network
resource "docker_network" "devops_net" {
  name = "devops-lab-network"
}

# 3. Create Web Servers (2 Instances)
resource "docker_container" "web" {
  count = 2
  name  = "web-server-${count.index + 1}"
  image = docker_image.ubuntu_ssh.name
  hostname = "web-${count.index + 1}"
  
  networks_advanced {
    name = docker_network.devops_net.name
  }
  
  # Map SSH port to random host ports so we can access them
  ports {
    internal = 22
    external = 2221 + count.index
  }
}

# 4. Create Load Balancer
resource "docker_container" "lb" {
  name  = "load-balancer"
  image = docker_image.ubuntu_ssh.name
  hostname = "lb"

  networks_advanced {
    name = docker_network.devops_net.name
  }

  ports {
    internal = 22
    external = 2220
  }
  
  # Expose the website to your browser
  ports {
    internal = 80
    external = 8080
  }
}