#!/bin/bash

# Update package details
sudo apt update

# Upgrade installed packages (optional)
sudo apt upgrade -y

# Check if Apache2 is installed
if ! dpkg -s apache2 >/dev/null 2>&1; then
  echo "Apache2 is not installed. Installing..."
  
  # Update package details
  sudo apt update
  
  # Install Apache2
  sudo apt install -y apache2
  
  # Start Apache2 service
  sudo service apache2 start
  
  echo "Apache2 has been installed and started."
else
  echo "Apache2 is already installed."
fi

# Check if Apache2 service is enabled
if systemctl is-enabled apache2 >/dev/null 2>&1; then
    echo "Apache2 service is already enabled."
else
    # Enable Apache2 service
    sudo systemctl enable apache2
    echo "Apache2 service has been enabled."
fi

# Set S3 bucket name
s3_bucket="upgrad-manoj"

# Set your name
your_name="Manoj"

# Set timestamp
timestamp=$(date '+%d%m%Y-%H%M%S')

# Set the source directory
source_dir="/var/log/apache2"

# Set the destination directory
destination_dir="/tmp"

# Create a temporary directory
temp_dir=$(mktemp -d)

# Copy only .log files from the source directory to the temporary directory
find "$source_dir" -type f -name "*.log" -exec cp {} "$temp_dir" \;

# Create the tar archive
tar -cf "$destination_dir/$your_name-httpd-logs-$timestamp.tar" -C "$temp_dir" .

# Remove the temporary directory
rm -r "$temp_dir"

# Print the path to the created tar archive
echo "Tar archive created: $destination_dir/$your_name-httpd-logs-$timestamp.tar"

# Print the path to the created tar archive
echo "Tar archive created: $destination_dir/$your_name-httpd-logs-$timestamp.tar"

# Create a tar archive of the file/directory 
tar -cf /tmp/${your_name}-httpd-logs-${timestamp}.tar /tmp

# Copy the tar archive to S3
aws s3 cp /tmp/${your_name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${your_name}-httpd-logs-${timestamp}.tar

# push the dev branch to github
git push -u origin dev
