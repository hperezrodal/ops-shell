# OPS-SHELL

A Docker-based operations shell container that provides a comprehensive set of DevOps tools for cloud operations, Kubernetes management, and infrastructure as code.

## Labels

[![License](https://img.shields.io/github/license/hperezrodal/ops-shell)](LICENSE)
[![GitHub Issues](https://img.shields.io/github/issues/hperezrodal/ops-shell)](https://github.com/hperezrodal/ops-shell/issues)
[![GitHub Stars](https://img.shields.io/github/stars/hperezrodal/ops-shell)](https://github.com/hperezrodal/ops-shell/stargazers)

## Project Structure

```
ops-shell/
├── Dockerfile            # Main Docker image definition
├── README.md             # Project documentation
├── CONTRIBUTING.md       # Contribution guidelines
├── LICENSE               # MIT License
├── .gitignore            # Git ignore rules
├── build.sh              # Build script for the Docker image
├── runtime-init.sh       # Container initialization script
├── init.sh               # Default initialization script
└── ops-shell.sh          # Helper script for common operations
```

### Key Files

- **Dockerfile**: Defines the container image with all necessary tools and configurations
- **runtime-init.sh**: Handles container startup and initialization
- **init.sh**: Default initialization script that runs when container starts
- **build.sh**: Script to build and tag the Docker image
- **ops-shell.sh**: Helper script for common operations and shortcuts

## Prerequisites

Before using OPS-SHELL, ensure you have the following:

### Required Tools

1. **Docker**
   - Version 20.10.0 or higher
   - Basic understanding of Docker concepts
   - Docker Compose (optional)

2. **Operating System**
   - Linux
   - macOS
   - Windows with WSL2

3. **System Requirements**
   - CPU: 2+ cores recommended
   - RAM: 4GB minimum, 8GB recommended
   - Storage: 10GB free space minimum
   - Network: Stable internet connection

### Installation

1. Install Docker:
   ```bash
   # For Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install docker.io docker-compose
   sudo usermod -aG docker $USER
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/hperezrodal/ops-shell.git
   cd ops-shell
   ```

3. Build the image:
   ```bash
   ./build.sh
   ```

## Features

- **Cloud Tools**:
  - AWS CLI v2
  - Azure CLI
  - Kubernetes (kubectl)
  - Helm
  - Terraform
  - Ansible

- **Development Environment**:
  - Python 3 with virtual environment
  - Common utilities (curl, jq, etc.)
  - Bash shell with customization support

## Usage

### Quick Start

#### Using the ops-shell.sh Script

The `ops-shell.sh` script provides a convenient way to run the container with different options:

```bash
# Just run the shell
./ops-shell.sh

# Run with --no-init flag
./ops-shell.sh --no-init

# Run with environment variables
./ops-shell.sh ENVIRONMENT=uat

# Run with --no-init and environment variables
./ops-shell.sh --no-init ENVIRONMENT=uat
```

#### Creating a Bash Alias

To make the ops-shell command easily accessible from your terminal, add the following alias to your shell configuration file:

For Linux (Bash):
```bash
# Add this line to your ~/.bashrc
alias ops-shell='docker run --rm -it -v "$(pwd)":/workspace ops-shell'
```

For macOS:
```bash
# Add this line to your ~/.zshrc (if using zsh)
alias ops-shell='docker run --rm -it -v "$(pwd)":/workspace ops-shell'

# Or if using bash, add it to your ~/.bash_profile
alias ops-shell='docker run --rm -it -v "$(pwd)":/workspace ops-shell'
```

After adding the alias, either:
1. Restart your terminal, or
2. Run `source ~/.bashrc` (Linux) or `source ~/.zshrc` (macOS zsh) or `source ~/.bash_profile` (macOS bash) to reload your configuration

Now you can use the `ops-shell` command directly from any directory:

```bash
# Run with default initialization
ops-shell

# Run without initialization
ops-shell --no-init

# Run with additional arguments
ops-shell --no-init bash
```

#### Running with Default Initialization

When you run OPS-SHELL without the `--no-init` flag, it will execute the initialization script (`init.sh`) if present in your workspace:

```bash
# Run with default initialization
docker run --rm -it ops-shell

# Example output:
=============================================
Welcome to Ops Shell Container
Build datetime: 2025-04-16T13:30:16Z
=============================================
Available tools:
- kubectl: v1.32.3
- helm: v3.17.3+ge4da497
- aws: aws-cli/2.26.2
- terraform: v1.11.4
- ansible: ansible [core 2.18.4]
=============================================
Running initialization script...
root@container-id:/workspace#
```

#### Running without Initialization

Use the `--no-init` flag to skip the initialization script:

```bash
# Run without initialization
docker run --rm -it ops-shell --no-init

# Example output:
=============================================
Welcome to Ops Shell Container
Build datetime: 2025-04-16T13:30:16Z
=============================================
Available tools:
- kubectl: v1.32.3
- helm: v3.17.3+ge4da497
- aws: aws-cli/2.26.2
- terraform: v1.11.4
- ansible: ansible [core 2.18.4]
=============================================
root@container-id:/workspace#
```

The main difference is that without `--no-init`, the container will:
1. Look for an `init.sh` script in your workspace
2. Execute it if found
3. Set up any environment variables or configurations defined in the script

### Customization

You can customize the shell environment by mounting your own initialization script:

```bash
docker run --rm -it \
  -v $(pwd)/my-init.sh:/workspace/init.sh \
  ops-shell
```

## Best Practices

1. **Version Control**:
   - Always use specific versions for tools in the Dockerfile
   - Keep track of build dates and versions

2. **Security**:
   - Run as non-root user when possible
   - Keep base images updated
   - Use multi-stage builds to reduce image size

3. **Development**:
   - Mount your local workspace for persistent changes
   - Use environment variables for configuration
   - Keep initialization scripts version controlled

## Development

### Building the Image

```bash
./build.sh
```

### Customizing the Image

1. Modify the `Dockerfile` to add or remove tools
2. Update initialization scripts in `runtime-init.sh`
3. Rebuild the image using `build.sh`

## License

MIT License - See LICENSE file for details
