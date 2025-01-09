#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure a distribution_hash is provided
if [ -z "$1" ]; then
  echo "Error: distribution_hash must be provided as a parameter."
  echo "Usage: ./script.sh <distribution_hash>"
  exit 1
fi

DISTRIBUTION_HASH=$1

# Run the Dart script with the distribution_hash parameter
echo "Running Dart script with distribution_hash: $DISTRIBUTION_HASH"
dart run crowdin_integrator.dart "$DISTRIBUTION_HASH"

# Run Flutter pub get
echo "Running flutter pub get..."
flutter pub get

echo "Script execution completed."
