# backup-lamp
This is a simple bash shell script used to dump data from any linux based computer, and backup / synchronize / send them to an other remote computer / server.
This script is customizable & it can easily be run from any cron system (ex: crontab)

### How does it works ?
1. This script will "dump" and optionally encrypt your files, folders & databases to a specific local folder.
2. It will automatically "clean" / delete previous dumps from this local folder
3. Then it will use your prefered command tool to backup / synchronize / send those dump files to a remote server. The default tool is rsync over SSH but it can be whatever you want.

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

### Important
By default, the encryption, the "Single Files dump" and the backup are disabled.
You must review carefully & edit accordingly to your needs the file config.conf before running the ./backup.sh script

### Disclaimer
Use this script at your own risk. Take note that myself, the owners, hosting providers and contributers cannot be held responsible for any misuse or script problems.
In no event shall myself, the copyright owner or contributors be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this software, script or service, even if advised of the possibility of such damage.
