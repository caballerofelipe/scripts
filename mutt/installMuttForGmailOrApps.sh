#!/bin/bash
# Config
muttrcFile='~/.muttrc'
muttdirdefault='~/.mutt'
# /Config

echo "This script installs mutt and configures it to be used with Gmail or Google Apps"

read -p '... Install mutt using Homebrew? [y/N]' muttInstall
if [ "$muttInstall" != "y" ]; then
	echo 'Exiting'
	exit
fi

echo
echo "... Please fill some details"
read -p "Full username (username@domain):" userdomain
echo "Note: you might need an App Password, see this: https://support.google.com/accounts/answer/185833"
read -s -p "Password (will be stored as text in file):" pass
echo
read -p "Full name:" fullname
read -p "mutt dir (empty for default ~/.mutt)" muttdir
if [ -z $muttdir ]; then
	muttdir=$muttdirdefault
fi

echo
echo '... Attempting mutt install'
brew install mutt
if [ $? -ne 0 ]; then
	echo -e 'brew mutt install: \033[31mfailed\033[0m'
	echo 'Exiting'
	exit
else
	echo 'mutt install: \033[32mdone\033[0m'
fi

muttrcFileExpanded=$(eval echo $muttrcFile)
echo
echo "... Setting $muttrcFile"
if [ -s $muttrcFileExpanded ]; then
	echo "$muttrcFile is not empty: \033[31maborting\033[0m"
	exit
fi

{ # See https://stackoverflow.com/a/51113160/1071459
	echo "set imap_user = \"$userdomain\""
	echo "set imap_pass = \"$pass\""
	echo "set smtp_url = \"smtp://$userdomain@smtp.gmail.com:587/\""
	echo "set smtp_pass = \"$pass\""
	echo "set from = \"$userdomain\""
	echo "set realname = \"$fullname\""
	echo "set folder = \"imaps://imap.gmail.com:993\""
	echo "set spoolfile = \"+INBOX\""
	echo "set postponed = \"+[Gmail]/Drafts\""
	echo "set header_cache = $muttdir/cache/headers"
	echo "set message_cachedir = $muttdir/cache/bodies"
	echo "set certificate_file = $muttdir/certificates"
	echo "set move = no"
	echo "set smtp_authenticators = 'gssapi:login'"
} > $muttrcFileExpanded
