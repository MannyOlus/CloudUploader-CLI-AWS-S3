#!/bin/bash

# Function to display usage/help message
function usage() {
    echo "Usage: $0 [-f file_path] [-p s3_path (optional)]"
    echo "  -f  Path to the file to upload"
    echo "  -p  S3 path (optional, default is root of the bucket)"
    echo
    echo "Example:"
    echo "  $0 -f ./file.txt"
    echo "  $0 -f /path/to/file.txt -p folder/subfolder/"
    exit 1
}

# Check if AWS CLI is installed
if ! [ -x "$(command -v aws)" ]; then
  echo 'Error: AWS CLI is not installed.' >&2
  exit 1
fi

# Prompt the user to enter the S3 bucket name
read -p "Enter the S3 bucket name: " BUCKET_NAME

# Parse command line options
while getopts ":f:p:" opt; do
  case ${opt} in
    f )
      FILE_PATH=$OPTARG
      ;;
    p )
      S3_PATH=$OPTARG
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Ensure file path is provided
if [ -z "${FILE_PATH}" ]; then
    echo "Error: File path must be specified."
    usage
fi

# Default S3 path to the root if not provided
if [ -z "${S3_PATH}" ]; then
    S3_PATH=""
fi

# Ensure S3_PATH ends with a forward slash if it's a folder path
if [ -n "${S3_PATH}" ] && [[ "${S3_PATH}" != */ ]]; then
    S3_PATH="${S3_PATH}/"
fi

# Check if the file exists
if [ ! -f "${FILE_PATH}" ]; then
    echo "Error: File ${FILE_PATH} does not exist."
    exit 1
fi

# Get the file name from the file path to append to S3 path
FILE_NAME=$(basename "${FILE_PATH}")

# Upload the file to the S3 bucket
echo "Uploading ${FILE_PATH} to s3://${BUCKET_NAME}/${S3_PATH}${FILE_NAME}"
aws s3 cp "${FILE_PATH}" "s3://${BUCKET_NAME}/${S3_PATH}${FILE_NAME}"

# Check the status of the upload
if [ $? -eq 0 ]; then
    echo "Upload successful!"
else
    echo "Error: File upload failed. Please check the AWS CLI error."
    exit 1
fi

