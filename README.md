# CloudUploader S3 File Upload Tool

The purpose of this project is to create a bash-based CLI tool that allows users to quickly upload files to a specified cloud storage solution, providing a seamless upload experience similar to popular storage services.

---

## Prerequisites

Before you begin, ensure you have met the following requirements:

- AWS subscription S3 bucket
- [AWS CLI](https://aws.amazon.com/cli/) has been installed and configured for each user requiring the upload functionality
- Assumed basic knowledge of Linux (file creation & permissions management)


## Usage

The tool is used as following

./uploadtos3.sh <Path to the local file you want to upload> <Destination path in the S3 bucket>

Examples: ./uploadtos3.sh ./example.txt uploads/

Please note that the script will prompt you to enter your S3 Bucket name.

Additional functionality has now been added. The user will now get a shareable link that will expire in one hour.

---

## Installation

Step-by-step guide to install and set up the script on your local machine including enabling permissions for all users:

1. **Create the upload.sh file**
2. **Download the script**
	1. [S3 Upload Tool](https://github.com/MannyOlus/CloudUploader-CLI-AWS-S3/blob/main/upload.sh)
3. **Make the file executable
	1. chmod +x ./upload.sh
4. **Make the script globally accessible**
	1. sudo mv /path/to/upload.sh /usr/local/bin/upload.sh

---

## Contributing

Contributions are welcome 

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some feature'`)
5. Push to the branch (`git push origin feature-branch`)
6. Create a new Pull Request

---

## Future Enhancements

List any potential features or improvements you plan to add in the future:

- [ ]  Feature 1: Progress bar or percentage upload completion
- [ ]  Feature 2: Enable file synchronization -- if the file already exists in the cloud, prompt the user to overwrite, skip, or rename

---

## License

This project is licensed under the [MIT License](https://github.com/MannyOlus/CloudUploader-CLI-AWS-S3/blob/main/MIT%20License).

---

## Authors

- Initial work_ - [MannyOlus](https://github.com/MannyOlus)

---

## Acknowledgments

- [Gwyneth Peña-Siguenza](https://github.com/madebygps)
- [Code Nemo](https://github.com/nehemiahlc)
