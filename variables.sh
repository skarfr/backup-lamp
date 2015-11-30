#!/bin/sh

_now=$(date +"%Y%m%d-%H%M%S")     #used to name dumps files such as: YYYYMMDD-HHMMSS-<dump name>.ext
_pathDump="/home/.dump"           #the folder where dumps will be created

_mysqlUser="dump"                 #SQL username. It must have global privileges USAGE: SELECT, LOCK TABLES, EVENT, TRIGGER, SHOW VIEW
_mysqlPassword="<mysql password>" #change with the real password

typeset -A _fullFolders
_fullFolders=([username]="/home/username/" #change username with real linux username. You can add more usernames
              [etc]="/etc/"
              [www]="/var/www/"
              [crontab]="/var/spool/cron/crontabs/"
              [debback]="/var/backups/")

typeset -A _singleFiles
_singleFiles=([rootbashrc]="/root/.bashrc") #list of single files to dump

_singleFilesDumpName="singleFiles"          #all single files will be dump within 1 file named from this variable

_deleteOlderThan=5 #days                    #last step of the dump is to delete dumps older than X days
