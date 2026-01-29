FROM ubuntu:latest

# Install SSH and Python (required for Ansible)
RUN apt-get update && apt-get install -y openssh-server python3 sudo

# Configure SSH to let us log in
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
# Allow root login via SSH (Only safe for local labs!)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Add your public key (We will mount this at runtime for simplicity, or COPY it here)
# For this lab, we will handle keys via Terraform/Docker volumes for flexibility.

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]