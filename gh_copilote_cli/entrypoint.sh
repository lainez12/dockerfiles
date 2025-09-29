#!/bin/bash

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: variable GITHUB_TOKEN is required."
    echo "Example usage:"
    echo "  docker run --rm -it -e GITHUB_TOKEN=your_token -v \$(pwd):/workspace -w /workspace copilot-cli"
    exit 1
fi

# Exportar el token para que el CLI lo use
export GITHUB_TOKEN=$GITHUB_TOKEN

# Lanzar bash interactivo
exec "$@"