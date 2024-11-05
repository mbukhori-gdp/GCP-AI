#!/bin/bash
set -e  # Exit immediately on failure

# Version Script Information
VERSION="1.0.0"
echo "Running script version: $VERSION"

ORIGINAL_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Original directory: $ORIGINAL_DIR"

# Detect OS type
OS="$(uname -s 2>/dev/null || echo "Windows")"
echo "Detected OS: $OS"

# Function to check if Python is installed
check_python_installed() {
  if command -v python3 &>/dev/null; then
    PYTHON_CMD="python3"
    echo "Python3 is already installed."
    return 0
  elif command -v python &>/dev/null; then
    PYTHON_CMD="python"
    echo "Python is already installed."
    return 0
  else
    echo "Error: Python not found."
    return 1
  fi
}

# OS-specific logic to install Python if needed
if ! check_python_installed; then
  echo "Error: Python not found. Exiting..."
  exit 1
fi

# Function to update the .env file with the selected model
update_env_file() {
  model_choice=$1

  # Remove existing model-related variables from the .env file
  sed -i '/^GCP_MODEL_NAME=/d' .env
  sed -i '/^GCP_ENDPOINT_NAME=/d' .env

  # Set model-specific configurations
  case "$model_choice" in
    1)
      gcp_model_name="meta/llama-3.1-405b-instruct-maas"
      gcp_endpoint_name="us-central1-aiplatform.googleapis.com"
      script_to_run="serverless-llama-3-1.py"
      ;;
    2)
      gcp_model_name="gemini-1.0-pro"
      gcp_endpoint_name="https://us-central1-aiplatform.googleapis.com/v1/projects/glx-exploration/locations/us-central1/publishers/google/models/gemini-1.0-pro:streamGenerateContent"
      script_to_run="serverless-gemini1-0.py"
      ;;
    *)
      echo "Invalid choice."
      exit 1
      ;;
  esac

  # Append new configuration to .env
  echo "GCP_MODEL_NAME=\"$gcp_model_name\"" >> .env
  echo "GCP_ENDPOINT_NAME=\"$gcp_endpoint_name\"" >> .env
}

# Prompt user to choose a model
echo "Choose the model to deploy:"
echo "1. Serverless Llama 3-1"
echo "2. Serverless Gemini 1-0"
read -p "Enter the number corresponding to the model: " model_choice

# Update the .env file based on user input
update_env_file "$model_choice"

# Load environment variables from the .env file
if [ -f .env ]; then
  set -a
  while IFS='=' read -r key value; do
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | sed 's/#.*//' | xargs)  # Remove inline comments
    if [[ ! $key =~ ^# && $key && $value ]]; then
      export "$key=$value"
    fi
  done < .env
  set +a
else
  echo ".env file not found. Please ensure it exists in the directory."
  exit 1
fi

# Verify that GOOGLE_APPLICATION_CREDENTIALS is set correctly
GOOGLE_APPLICATION_CREDENTIALS="$ORIGINAL_DIR/key.json"
if [ ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
  echo "Error: GOOGLE_APPLICATION_CREDENTIALS file not found at $GOOGLE_APPLICATION_CREDENTIALS"
  exit 1
else
  export GOOGLE_APPLICATION_CREDENTIALS
  echo "GOOGLE_APPLICATION_CREDENTIALS set to $GOOGLE_APPLICATION_CREDENTIALS"
fi

# Create and activate virtual environment
echo "Creating and activating virtual environment..."
$PYTHON_CMD -m venv my_venv
source my_venv/bin/activate

# Install required libraries
pip install --disable-pip-version-check python-dotenv requests google-auth

# Run the selected Python script
echo "Running Python script..."
$PYTHON_CMD "$script_to_run"
echo "Python script executed successfully."
