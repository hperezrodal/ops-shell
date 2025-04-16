#!/bin/bash
set -euo pipefail

# Check for --no-init flag
NO_INIT=false
if [ $# -gt 0 ] && [ "$1" = "--no-init" ]; then
    NO_INIT=true
    shift
fi

# Print welcome message
echo "============================================="
echo "Welcome to Ops Shell Container"
echo "Build datetime: $BUILD_DATETIME"
echo "============================================="
echo "Available tools:"
echo "- kubectl: $(kubectl version --client -o json | jq -r '.clientVersion.gitVersion')"
echo "- helm: $(helm version --short)"
echo "- aws: $(aws --version)"
echo "- terraform: $(terraform version | head -n 1)"
echo "- ansible: $(ansible --version | head -n 1)"
echo "- azure: $(az version --output tsv)"
echo "============================================="

# Run initialization if --no-init is not set
if [ "$NO_INIT" = false ] && [ -f "/workspace/init.sh" ]; then
    echo "Running initialization script..."
    if [ -x "/workspace/init.sh" ]; then
        # shellcheck disable=SC1091
        source "/workspace/init.sh"
    else
        echo "Warning: init.sh is not executable. Making it executable..."
        chmod +x "/workspace/init.sh"
        # shellcheck disable=SC1091
        source "/workspace/init.sh"
    fi
fi

# Start bash with remaining arguments
exec /bin/bash "$@" 