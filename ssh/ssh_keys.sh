#!/bin/bash

# To run this file directly from a computer without downloading run this:
# curl -sS https://raw.githubusercontent.com/caballerofelipe/scripts/master/ssh/ssh_keys.sh | bash

# Used to show SSH fingerprints
# Inspired by this post: http://superuser.com/a/1030779/369045

# standard sshd config path
SSH_DIR=/etc/ssh/

# Helper functions
function tablize {
    printf "| %-7s | %-7s | %-47s |\n" $1 $2 $3
}
LINE="+---------+---------+-------------------------------------------------+"

# Header
echo $LINE
tablize "Cipher" "Algo" "Fingerprint"
echo $LINE

# Fingerprints
for i in $(ls $SSH_DIR/*.pub); do
	md5_result=$(ssh-keygen -l -f $i -E md5)
	sha256_result=$(ssh-keygen -l -f $i -E sha256)
	cipher=$(echo $md5_result | sed 's/.*(//' | sed 's/)[^)]*//')
	md5=$(echo $md5_result | awk '{print $2}' | sed 's/^[^:]*://g')
	sha256=$(echo $sha256_result | awk '{print $2}' | sed 's/^[^:]*://g')
	tablize $cipher MD5 $md5
	tablize $cipher SHA-256 $sha256
    echo $LINE
done
