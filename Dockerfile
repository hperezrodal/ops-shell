# Build stage for Python packages
FROM python:3.11-slim as python-builder

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
    && rm -rf /var/lib/apt/lists/*

# Copy Python virtual environment from builder
COPY --from=python-builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

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

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
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
