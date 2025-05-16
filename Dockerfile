# Build stage for Python packages
FROM python:3.11-slim AS python-builder

# Create and activate virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages
RUN pip install --no-cache-dir kubernetes openshift boto3 botocore

# Final stage
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Add build datetime as environment variable
ARG BUILD_DATETIME
ENV BUILD_DATETIME=$BUILD_DATETIME
LABEL org.opencontainers.image.created=$BUILD_DATETIME

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    bash \
    unzip \
    lsb-release \
    gnupg \
    jq \
    ca-certificates \
    apt-transport-https \
    python3 \
    python3-pip \
    python3-venv \
    software-properties-common \
    openssh-client \
    netcat-openbsd \
    git \
    vim \
    dnsutils \
    at \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
# Add Docker's official GPG key:
RUN apt-get update \
    && apt-get install -y ca-certificates curl \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Ensure Docker group exists and add user to it
RUN getent group docker || groupadd -r docker \
    && useradd -r -g docker docker

# Install required Python packages for Ansible
RUN pip3 install --no-cache-dir kubernetes openshift

# Copy Python virtual environment from builder
COPY --from=python-builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Bash Library system-wide
RUN SYSTEM_INSTALL=true curl -sSL https://raw.githubusercontent.com/hperezrodal/bash-library/main/install-remote.sh | bash

# Install Ansible
RUN apt-add-repository --yes --update ppa:ansible/ansible \
    && apt-get update \
    && apt-get install -y --no-install-recommends ansible \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends terraform \
    && rm -rf /var/lib/apt/lists/*

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v1.32.3/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh

# Install ArgoCD CLI
RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 \
    && install -m 555 argocd-linux-amd64 /usr/local/bin/argocd \
    && rm argocd-linux-amd64

# Install AWS CLI v2
RUN if [ "$(uname -m)" = "aarch64" ]; then \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    else \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    fi \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Create workspace directory
RUN mkdir -p /workspace

# Copy and set up runtime initialization script
COPY runtime-init.sh /runtime-init.sh
RUN chmod +x /runtime-init.sh

# Define the working directory
WORKDIR /workspace

# Set the entrypoint
ENTRYPOINT ["/runtime-init.sh"]
