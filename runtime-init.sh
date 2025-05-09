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
echo "- docker: $(docker --version)"
echo "============================================="

# If there are remaining arguments, they are treated as environment variables
if [ $# -gt 0 ]; then
	echo "Setting environment variables from arguments..."
	for arg in "$@"; do
		# Split the argument into name and value if it contains '='
		if [[ "$arg" == *=* ]]; then
			var_name="${arg%%=*}"
			var_value="${arg#*=}"
			export "$var_name"="$var_value"
		else
			# If no '=' is found, export the variable name as is
			export "${arg?}"
		fi
	done
fi

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

# Start bash
exec /bin/bash
