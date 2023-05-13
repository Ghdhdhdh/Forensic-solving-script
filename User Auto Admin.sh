#!/bin/bash
 
# Define lists of authorised admins and users
authorized_admins=( "ubuntu" "linux" "excel" "powerpoint" )
authorized_users=( "teams" "outlook" "onenote" "bsod" )
 
# Loop through all users with UID over 1000
for user in $(cut -d: -f1,3 /etc/passwd | awk -F: '$2 >= 1000 {print $1}')
do
  # Check if user is in either of the authorized lists
  if [[ " ${authorized_admins[@]} " =~ " ${user} " ]] || [[ " ${authorized_users[@]} " =~ " ${user} " ]]
  then
    # Check if the user is in the sudo group
    if groups $user | grep -q '\bsudo\b'; then
      # Check if the user is in the authorized users list
      if [[ " ${authorized_users[@]} " =~ " ${user} " ]]; then
        # Remove admin privileges
        sudo deluser $user sudo
        echo "Removed sudo privileges for user $user"
      fi
    else
      # Add admin privileges
      sudo adduser $user sudo
      echo "Added sudo privileges for user $user"
    fi
  else
    # Add user with default settings
    sudo adduser $user
    echo "Added user $user"
  fi
done

# Other Script at pastebin.com/GCXbarH3