# MAMP MySQL

### Overview
Changing or re-setting the password for MAMP's MySQL root user necessitates updating hard-coded references to the old password in several Bash scripts shipped with MAMP for macOS.

As of MAMP 5.x these files are:
  * /Applications/MAMP/bin/checkMysql.sh
  * /Applications/MAMP/bin/quickCheckMysqlUpgrade.sh
  * /Applications/MAMP/bin/repairMysql.sh
  * /Applications/MAMP/bin/stopMysql.sh
  * /Applications/MAMP/bin/upgradeMysql.sh
  * /Applications/MAMP/bin/phpMyAdmin/config.inc.php

Instructions on changing the password for MAMP's MySQL root user and how to manually update each of these files can be found at [Changing the MySQL Root User Password in MAMP](https://www.tech-otaku.com/local-server/changing-mysql-root-user-password-mamp/).

### Purpose
[mamp-mysql.sh](mamp-mysql.sh) is a Bash script that automates updating these files with the new password and is run from the command line.

### Instructions
1. [Download](https://github.com/tech-otaku/mamp-mysql/archive/master.zip) mamp-mysql.sh
1. Open the Terminal application in macOS.
1. At the shell prompt
   1. type `chmod +x /path/to/mamp-mysql.sh` and press enter to make the script executable
   1. type `/path/to/mamp-mysql.sh OLDPASSWORD NEWPASSWORD` replacing `OLDPASSWORD` and  `NEWPASSWORD` as appropriate and press enter to run the script

The script changes all occurrences of `OLDPASSWORD` with `NEWPASSWORD` in the designated files making a backup (.bak) of each file in its parent directory before any changes are made.

If either the `OLDPASSWORD` or the `NEWPASSWORD` are omitted, the script will exit with the error `ERROR: Usage is mamp-mysql.sh OLDPASSWORD NEWPASSWORD`.

If `OLDPASSWORD` is not found in an individual file the script will display the message `WARNING: Could not find old password 'OLDPASSWORD' in /Applications/MAMP/bin/filename.sh`.

If successful the script will display the message `Updated /Applications/MAMP/bin/filename.sh with new password 'NEWPASSWORD'` for each file updated.
