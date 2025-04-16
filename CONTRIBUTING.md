# Contributing to OPS-SHELL

Thank you for your interest in contributing to OPS-SHELL! This document provides guidelines and instructions for contributing to this project.

## Prerequisites

Before you start contributing, make sure you have the following tools and knowledge:

### Required Tools

1. **Docker**
   - Version 20.10.0 or higher
   - Basic understanding of Docker concepts
   - Docker Compose (optional, for local development)

2. **Git**
   - Basic Git knowledge
   - GitHub account
   - Understanding of branching and pull requests

3. **Shell Scripting**
   - Basic to intermediate Bash scripting knowledge
   - Understanding of shell best practices
   - Familiarity with common Unix commands

4. **Development Environment**
   - A text editor or IDE (VS Code, Vim, etc.)
   - Terminal emulator
   - Basic understanding of Linux/Unix systems

### Recommended Knowledge

1. **Containerization**
   - Understanding of Dockerfile best practices
   - Multi-stage builds
   - Layer optimization
   - Security considerations

2. **DevOps Tools**
   - Basic understanding of the tools included in OPS-SHELL:
     - Kubernetes (kubectl)
     - Helm
     - Terraform
     - Ansible
     - AWS CLI
     - Azure CLI

3. **Development Practices**
   - Version control best practices
   - Code review process
   - Testing methodologies
   - Documentation standards

### System Requirements

- **Operating System**: Linux, macOS, or Windows with WSL2
- **CPU**: 2+ cores recommended
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 10GB free space minimum
- **Network**: Stable internet connection for Docker pulls and updates

### Setting Up Your Environment

1. Install Docker:
   ```bash
   # For Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install docker.io docker-compose
   sudo usermod -aG docker $USER
   ```

2. Install Git:
   ```bash
   sudo apt-get install git
   ```

3. Clone the repository:
   ```bash
   git clone https://github.com/hperezrodal/ops-shell.git
   cd ops-shell
   ```

4. Build the image:
   ```bash
   ./build.sh
   ```

5. Test the environment:
   ```bash
   docker run --rm -it ops-shell
   ```

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct. Please be respectful and considerate of others.

## How to Contribute

### Reporting Issues

1. Check if the issue has already been reported in the [Issues](https://github.com/hperezrodal/ops-shell/issues) section
2. If not, create a new issue with:
   - A clear, descriptive title
   - Detailed description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, Docker version, etc.)
   - Any relevant error messages or logs

### Feature Requests

1. Check if the feature has already been requested
2. Create a new issue with:
   - A clear, descriptive title
   - Detailed description of the feature
   - Use cases and benefits
   - Any relevant examples or references

### Pull Requests

1. Fork the repository
2. Create a new branch for your feature/fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes following the coding standards
4. Test your changes thoroughly
5. Update documentation if necessary
6. Submit a pull request with:
   - A clear description of the changes
   - Reference to any related issues
   - Screenshots or examples if applicable

## Development Guidelines

### Code Standards

- Follow shell script best practices:
  - Use `set -euo pipefail` in scripts
  - Quote all variables
  - Use meaningful variable names
  - Add comments for complex logic
  - Follow the existing code style

### Docker Image Development

1. When adding new tools:
   - Use specific versions
   - Document version in README
   - Add appropriate error handling
   - Update runtime-init.sh if needed

2. For Dockerfile changes:
   - Use multi-stage builds when possible
   - Minimize layer count
   - Clean up temporary files
   - Use non-root user
   - Keep security best practices in mind

### Testing

1. Test your changes locally:
   ```bash
   ./build.sh
   docker run --rm -it ops-shell
   ```

2. Verify all tools work as expected
3. Test edge cases and error conditions
4. Ensure backward compatibility

### Documentation

1. Update README.md for:
   - New features
   - Configuration changes
   - Usage examples
   - Breaking changes

2. Add inline comments for:
   - Complex logic
   - Configuration options
   - Environment variables

## Release Process

1. Version numbering follows [Semantic Versioning](https://semver.org/)
2. Create a release branch:
   ```bash
   git checkout -b release/vX.Y.Z
   ```
3. Update version numbers and changelog
4. Create a pull request for review
5. After approval, merge and tag the release

## Getting Help

- Open an issue for questions
- Join our community discussions
- Check the documentation

## License

By contributing to this project, you agree that your contributions will be licensed under the project's MIT License. 