#!/bin/bash

# Install Flutter Gen CLI globally
echo "Installing Hybrid CLI..."

# Navigate to the CLI directory
cd "$(dirname "$0")"

# Install dependencies
dart pub get

# Activate globally
dart pub global activate --source path .

echo "✓ Hybrid CLI installed successfully!"
echo ""
echo "Usage:"
echo "  hybrid init <project_name>     # Create new Flutter project"
echo "  hybrid feature <feature_name>  # Create new feature"
echo "  hybrid generate <type> <name>  # Generate components"
echo ""
echo "Example:"
echo "  hybrid init my_awesome_app"
echo "  hybrid feature user_management" 
echo "  hybrid generate model User"
