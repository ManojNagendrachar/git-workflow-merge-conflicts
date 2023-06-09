#!/bin/bash

# Check if inventory.html exists
inventory_file="/var/www/html/inventory.html"
if [ ! -f "$inventory_file" ]; then
    # Create the inventory.html file if it doesn't exist
    echo -e "Log Type\tDate Created\tType\tSize" > "$inventory_file"
fi

# Gather metadata for the new log archive
log_type="httpd-logs"
date_created="$(date +"%d%m%Y-%H%M%S")"
archive_type="tar"
archive_size="10K"

# Append the new entry to inventory.html
echo -e "$log_type\t$date_created\t$archive_type\t$archive_size\n" >> "$inventory_file"

# Create the cron job file
cron_file="/etc/cron.d/automation"

# Schedule the cronjob 
crontab -u root $cron_file

# Create or overwrite the cron file with the appropriate content and this will run at 10am everyday 
echo "0 10 * * * root sh /root/git-workflow-merge-conflicts/automation.sh" > "$cron_file"
