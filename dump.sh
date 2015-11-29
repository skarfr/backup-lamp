#!/bin/bash

#exit if error
set -e

#root only
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

#variables $_
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/variables.sh"

echo "Location:     $_pathDump"

#dump Mysql/Mariadb
_databases=$(mysql -u $_mysqlUser -p"$_mysqlPassword" -e "SHOW DATABASES;" | tr -d "| " | grep -v Database)

#we create 1 file per databases
for _db in $_databases; do
    if [[ "$_db" != "information_schema" ]] && [[ "$_db" != "performance_schema" ]] && [[ "$_db" != "mysql" ]] && [[ "$_db" != _* ]] ; then
        _file="$_pathDump/$_now-$_db.sql"
        mysqldump -u $_mysqlUser -p"$_mysqlPassword" --databases $_db > $_file
        tar -czf $_file.tar.gz -C / ${_file#"/"}
        rm $_file
        echo "Dump Mariadb: $_db DONE"
    fi
done

#dump full Folders
for _folder in "${!_fullFolders[@]}"; do
    _file="$_pathDump/$_now-$_folder.tar.gz"
    tar -czf $_file -C / ${_fullFolders[$_folder]#"/"}
    echo "Dump Folder:  ${_fullFolders[$_folder]} DONE"
done

#dump single Files
_file="$_pathDump/$_now-$_singleFilesDumpName.tar" #all in 1 file
for _singfile in "${!_singleFiles[@]}"; do
    tar -rf $_file -C / ${_singleFiles[$_singfile]#"/"}
    echo "Dump File:    ${_singleFiles[$_singfile]} DONE"
done

#delete previous backups
find $_pathDump/* -mtime +$_deleteOlderThan -type f -delete
echo "Clean Dumps:  >$_deleteOlderThan days DONE"
