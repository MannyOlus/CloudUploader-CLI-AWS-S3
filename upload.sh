#!/bin/bash

# Function to display usage/help message
function usage() {
    echo "Usage: $0 [-f file_path] [-b bucket_name] [-p s3_path]"
    echo "  -f  Path to the file to upload"
    echo "  -b  Name of the S3 bucket"
    echo "  -p  S3 path (optional, default is root of the bucket)"
    echo
    echo "Example:"
    echo "  $0 -f ./file.txt -b my-s3-bucket"
    exit 1
}

# Check if AWS CLI and pv are installed
if ! [ -x "$(command -v aws)" ]; then
  echo 'Error: AWS CLI is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v pv)" ]; then
  echo 'Error: pv is not installed. Please install pv to track upload progress.' >&2
  exit 1
fi

# Parse command line options
while getopts ":f:b:p:" opt; do
  case ${opt} in
    f )
      file_path=$OPTARG
      ;;
    b )
      bucket_name=$OPTARG
      ;;
    p )
      s3_path=$OPTARG
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

# Ensure required inputs are provided
if [ -z "${file_path}" ]; then
    echo "Error: File path must be specified."
    usage
fi

# Prompt for S3 bucket name if not provided via command line
if [ -z "${bucket_name}" ]; then
    read -p "Enter the S3 bucket name: " bucket_name
fi

# Set S3 path to root if not provided
if [ -z "${s3_path}" ]; then
    s3_path="s3://${bucket_name}/$(basename ${file_path})"
else
    s3_path="s3://${bucket_name}/${s3_path}/$(basename ${file_path})"
fi

# Check if the file exists
if [ ! -f "${file_path}" ]; then
    echo "Error: File ${file_path} does not exist."
    exit 1
fi

# Get the size of the file
file_size=$(stat -c %s "$file_path")

# Upload the file to the S3 bucket using pv for progress tracking
echo "Uploading ${file_path} to ${s3_path}..."
pv -s $file_size "$file_path" | aws s3 cp - "$s3_path" --expected-size $file_size

# Check the status of the upload
if [ $? -eq 0 ]; then
    echo "Upload successful!"
    
    # Generate a shareable pre-signed URL (valid for 1 hour)
    shareable_link=$(aws s3 presign "$s3_path" --expires-in 3600)
    echo "Shareable link (valid for 1 hour):"
    echo "$shareable_link"
else
    echo "Error: File upload failed. Please check the AWS CLI error."
    exit 1
fi

