#!/bin/bash

# Custom networks don't work with rootless podman, so try podman
# if it exists and we're root and i
if command -v podman > /dev/null && [ "$EUID" -eq 0 ]; then
  CMD=podman
elif command -v docker > /dev/null; then
  CMD=docker
else
  echo Could not find podman or docker
  exit 1
fi

# Set CMD here if you want to hard code one or the other
# CMD=podman
