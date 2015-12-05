#!/bin/bash

#check that the user is root, or exit
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

#load config.conf & tools.inc
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/config.conf"
source "$DIR/tools.inc"   #in_array()

echo "Location:     $_pathDump"

#dump Mysql/Mariadb
if [ "$_mysqlDump" = 1 ]; then
    _databases=$(mysql -u "$_mysqlUser" -p"$_mysqlPassword" -e "SHOW DATABASES;" | tr -d "| " | grep -v Database) #we get all the databases names
    for _db in $_databases; do
        if [ $(in_array _mysqlExcludeDB $_db) = "false" ] ; then                         #if not a database to be excluded
            _file="$_pathDump/$_now-$_db.sql"
            mysqldump -u "$_mysqlUser" -p"$_mysqlPassword" --databases "$_db" > "$_file" #we create 1 dump file per databases
            tar -czf "$_file".tar.gz -C / ${_file#"/"}                                   #compress the sql file into a tar.gz file
            rm "$_file"                                                                  #delete the sql file
            _file="$_file".tar.gz                                                        #.sql.tar.gz
            if [ "$_mysqlDumpEncrypt" = 1 ]; then
                gpg --yes --batch --passphrase="$_gpgPassword" -c "$_file"               #encrypt the tar.gz file into a tar.gz.gpg file
                rm "$_file"                                                              #delete the tar.gz file
            fi
            echo "Dump database: $_db DONE"
        fi
    done
fi

#dump full Folders
if [ "$_fullFoldersDump" = 1 ]; then
    for _folder in "${!_fullFolders[@]}"; do
        _file="$_pathDump/$_now-$_folder.tar.gz"
        tar -czf $_file -C / ${_fullFolders[$_folder]#"/"}
        if [ "$_fullFoldersDumpEncrypt" = 1 ]; then
            gpg --yes --batch --passphrase="$_gpgPassword" -c "$_file" #encrypt the tar.gz file into a tar.gz.gpg file
            rm "$_file"                                                #delete the tar.gz file
        fi
        echo "Dump Folder:  ${_fullFolders[$_folder]} DONE"
    done
fi

#dump single Files
if [ "$_singleFilesDump" = 1 ]; then
    _file="$_pathDump/$_now-$_singleFilesDumpName.tar"             #all single files will be dumped into 1 tar file
    for _singfile in "${!_singleFiles[@]}"; do
        tar -rf $_file -C / ${_singleFiles[$_singfile]#"/"}
        echo "Dump File:    ${_singleFiles[$_singfile]} DONE"
    done
    if [ "$_singleFilesDumpEncrypt" = 1 ]; then
        gpg --yes --batch --passphrase="$_gpgPassword" -c "$_file" #encrypt the tar file into a tar.gpg file
        rm "$_file"                                                #delete the tar file
    fi
fi

#delete previous dumps
if [ "$_deleteOlderDumps" = 1 ]; then
    find $_pathDump/* -mtime +$_deleteOlderThan -type f -delete
    echo "Clean Dumps:  >$_deleteOlderThan days DONE"
fi

#backup/synchronize to remote server
if [ "$_backup" = 1 ]; then
   "${_backupcmd[@]}"
    echo "Backup: DONE"
fi
