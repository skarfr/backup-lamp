# backup-lamp
This is a simple shell script used to dump important data on your linux server & backup / synchronize / send them to an other remote server.

### How does it works ?
1. This script will "dump" your files, folders & databases to a specific local folder.
2. It will automatically "clean" / delete previous dumps
3. Then it will use your prefered command tool to backup / synchronize / send those dump files on a remote server. The default tool is rsync over SSH but it can be whatever you want.

### Requirement
This script uses few commands:
* mysqldump: Optional. You need it only if you wish to dump & backup MySQL / MariaDB databases
* tar: Required to compress dumps files
* gpg: Optional. You need it only if you wish to encrypt dumps before sending them to a remote server
* rsync: Optional. This is the default backup / synchronize tool used to send dumps files to your prefered remote server

### Installation
* Make sure you installed required commands on your server
* Download "backup-lamp" files on your linux server
* Edit the file config.conf to fit your dump & backup needs
* chmod +x backup.sh
* Execute ./backup.sh as root and check the output for any errors
* Setup a cronjob (crontab -e) to run it everyday
