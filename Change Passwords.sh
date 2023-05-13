#!/bin/bash

# Get a list of all users except "ubuntu"
users=$(awk -F':' '{ if ($1 != "ubuntu") print $1 }' /etc/passwd)

# Set each user's password to "CyberTaipan1!69420L"
for user in $users
do
  echo "Changing password for user: $user"
  echo "$user:CyberTaipan1!69420L" | chpasswd
done
