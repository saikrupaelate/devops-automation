FROM jenkins/jenkins:lts

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    wget \
    gnupg \
    software-properties-common \
    python3-pip \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN pip3 install awscli

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip \
    && unzip terraform_1.6.6_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_1.6.6_linux_amd64.zip

# Install Ansible
RUN pip3 install ansible

USER jenkins