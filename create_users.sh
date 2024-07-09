#!/bin/bash

LOG_FILE=/var/log/user_management.log
PASSWORD_FILE=/var/secure/user_passwords.txt

create_user() {
    user=$1
    group=$2
    sudo useradd -m -s /bin/bash $user
    sudo groupadd $user
    for group in $groups; do
        sudo usermod -aG $group $user
    done
}

if [ $# -ne 1 ]; then
    echo "Usage: sudo ./create_users.sh input_file.txt"
    exit 1
fi

input_file=$1

if [ ! -f $input_file ]; then
    echo "Input file $input_file not found!"
    exit 1
fi

# Create the password file and log file if they don't exist
sudo touch $PASSWORD_FILE
sudo chmod 600 $PASSWORD_FILE
sudo touch $LOG_FILE
sudo chmod 600 $LOG_FILE

# Read the input file and create users
while IFS= read -r line; do
    user=$(echo $line | cut -d: -f1)
    group=$(echo $line | cut -d: -f2)
    create_user $user $group
done < $input_file