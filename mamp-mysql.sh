#!/usr/bin/env bash

# Check if both the old [$1] and new [$2] MySQL root user passwords have been provided as command line arguements. Exit with error message if not.
if [[ -z $1 || -z $2 ]]; then
	printf '\nERROR: Usage is mamp-mysql.sh OLDPASSWORD NEWPASSWORD\n'
	exit 1
fi

# Define the parent directory containing the files to be updated.
SOURCE=/Applications/MAMP/bin

# Define the names of the files to be updated excluding config.inc.php which is handled separately at the end of this script.
declare -a files=("checkMysql.sh" "quickCheckMysqlUpgrade.sh" "repairMysql.sh" "stopMysql.sh" "upgradeMysql.sh")

printf '\n'
# Iterate through the list of file names.
for f in "${files[@]}"
do
	# Check if file exists. Display warning message and skip to next file if not.
	if [ -f "$SOURCE/$f" ]; then
		# Check if the text `-uroot -pOLDPASSWORD` exists in the file. Display warning message if not.
		grep -e "-u[ ]*root -p[ ]*$1" "$SOURCE/$f" > /dev/null
		if [ $? -eq 0 ]; then
			# Change the old password in the file to the new password making a backup (.bak) first.
			sed -i '.bak' -E "s/(-u[ ]*root -p[ ]*)$1/\1$2/g" "$SOURCE/$f"
			# Display success message.
			echo "Updated $SOURCE/$f with new password '$2'"
		else
			# Display warning message regarding old password.
			echo "WARNING: Could not find old password '$1' in $SOURCE/$f"
		fi
	else
		# Display warning message regarding file doesn't exist.
		echo "WARNING: The file $SOURCE/$f does not exist"
	fi
done

# Process the file config.inc.php checking first if it exists. Display warning message if not.
if [ -f "$SOURCE/phpMyAdmin/config.inc.php" ]; then
	# Check if the text `'password'] ='OLDPASSWORD` exists in the file. Display warning message if not.
	grep -e "'password'\] *= '$1" "$SOURCE/phpMyAdmin/config.inc.php" > /dev/null
	if [ $? -eq 0 ]; then
		# Change the old password in the file to the new password making a backup (.bak) first.
		sed -i '.bak' -E "s/('password'\] *= ')$1/\1$2/g" "$SOURCE/phpMyAdmin/config.inc.php"
		# Display success message.
		echo "Updated $SOURCE/phpMyAdmin/config.inc.php with new password '$2'"
	else
		# Display warning message regarding old password.
		echo "WARNING: Could not find old password '$1' in $SOURCE/phpMyAdmin/config.inc.php"
	fi
else
	# Display warning message regarding file doesn't exist.
	echo "WARNING: The file $SOURCE/phpMyAdmin/config.inc.php does not exist"
fi
printf '\n'
