#!/bin/bash

# Lists of authorized users and admins
AUTHORIZED_USERS=$(cat authorized_users.txt)
AUTHORIZED_ADMINS=$(cat authorized_admins.txt)

# Functions to add and remove sudo permissions
function add_sudo {
    usermod -aG sudo $1
}

function remove_sudo {
    deluser $1 sudo
}

# Loop through the current users
for user in $(awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd); do
    if [[ $AUTHORIZED_USERS == *"$user"* ]] && [[ $AUTHORIZED_ADMINS != *"$user"* ]]; then
        remove_sudo $user
    elif [[ $AUTHORIZED_ADMINS == *"$user"* ]]; then
        add_sudo $user
    else
        userdel -r $user
    fi
done

# Loop through the authorized users and add them if they don't exist
for user in $AUTHORIZED_USERS; do
    if ! id -u $user >/dev/null 2>&1; then
        useradd $user
    fi
done

# Loop through the authorized admins and add them if they don't exist, also add sudo
for user in $AUTHORIZED_ADMINS; do
    if ! id -u $user >/dev/null 2>&1; then
        useradd $user
        add_sudo $user
    fi
done
