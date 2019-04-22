#! /bin/bash
# @file   : runbackup.inc
# @version: 2019-04-22
# @created: 2017-03-29
# @author : pyramid
# @brief  : runbackup include file with backup functions (Android,Linux)


#====================================
# LOGGING
#====================================

#------------------------------------
echoStart() {
    mkdir -p $logdir
    echo "sshbackup started $(date +'%Y-%m-%d %T')" > $logdir/runbackup-time.log
    echo "sshbackup started $(date +'%Y-%m-%d %T')"
}
#------------------------------------
echoFinish() {
    echo "sshbackup finished $(date +'%Y-%m-%d %T')" >> $logdir/runbackup-time.log
    echo "sshbackup finished $(date +'%Y-%m-%d %T')"
}
#------------------------------------
echoConfig() {
    echo "device: $device"
    echo "local user: $luser"
    echo "backup user: $suser"
    echo "platform: $platform"
    echo "server: $susrsrv"
}
#------------------------------------


#====================================
# LOCAL COPY BACKUP
#====================================

# @brief: copy directories or files recursively to destination
# @param: $1 - source path
# @param: $2 - target path
doCopy() {
    echo "--- copying $1 to $sshare$2"
    mkdir -p $sshare$2
    cp -p -r $1 $sshare$2
}

#====================================
# SCP BACKUP LINUX
#====================================

# @brief: execute backup of a path to ssh server
# @param: $1 - source path
# @param: $2 - target path
doBackupSCP() {

    # assign parameters
    SOURCE=$1
    TARGET=$2

    echo "--- backing up $SOURCE to $sshare$TARGET"
    # create directory tree in case not exists
    #echo 'ssh -p $sport $susrsrv "mkdir -p $sshare$TARGET"'
    ssh -p $sport $susrsrv "mkdir -p $sshare$TARGET"

    # copy recursive preserving atttributes
    #echo 'scp -r -p -P $sport $SOURCE $susrsrv:$sshare$TARGET'
    scp -r -p -P $sport $SOURCE $susrsrv:$sshare$TARGET
}


#====================================
# SSH BACKUP LINUX
#====================================

#------------------------------------

# @brief: create target path on rsync server
# @param: $1 - target path
# this is the standard version for posix systems
# Linux and Android
# note that the ssh command in rsync *must* be enclosed in
# double quotes, or the passed port parameter will not
# be resolved correctly
createPathRsyncSSH() {
    #splits=$(echo $TARGET | tr "/" "\n")
    splits=$(echo $1 | tr "/" "\n")
    cbpath=''

    for addr in $splits
    do
        cbpath="$cbpath/$addr"
        # - debug ini
        #echo "[$addr]"
        #cbpath=$(createPath $cbpath $addr)
        #echo "path: $cbpath/"
        # - debug end
        #echo 'rsync -e "ssh -y -p $sport" /dev/null $suser@$sserver:$sshare/$cbpath/ &> /dev/null'
        rsync -e "ssh -y -p $sport" /dev/null $suser@$sserver:$sshare/$cbpath/ &> /dev/null
    done
}

#------------------------------------

# @brief: execute file transfer to rsync server
# @param: $1 - source path
# @param: $2 - target path
# this is the standard version for posix systems
# Linux and Android
# note that the ssh command in rsync *must* be enclosed in
# double quotes, or the passed port parameter will not
# be resolved correctly
backupPathRsyncSSH() {
    #echo 'rsync --progress -avzzhe "ssh -y -p $sport" $1 $suser@$sserver:$sshare/$2'
    rsync --progress -avzzhe "ssh -y -p $sport" $1 $suser@$sserver:$sshare/$2
}

#------------------------------------

# @brief: execute backup of a path to rsync server
# @param: $1 - source path; $2 - target path
doBackupRsyncSSH() {
    echo "--- backing up $1 to $2"
    createPathRsyncSSH $2
    backupPathRsyncSSH $1 $2
}

#------------------------------------


#====================================
# SSH BACKUP ANDROID
#====================================

# currently unused parameter
#sopts=-avhe
#sopts=-avzzhe

#------------------------------------

# @brief: create target path on rsync server
# @param: $1 - target path
# note that the difference of the android version is that
# we must pass the keyfile in the ssh -i parameter
# at least this was the case with terminal IDE
# (com.spartacusrex.spartacuside)
# it also seems that there are differences of parameters accepted by the dropbear rsync
# e.g., the rsync command does not support -zz parameters
createPathRsyncSSHAnd() {
    #splits=$(echo $TARGET | tr "/" "\n")
    splits=$(echo $1 | tr "/" "\n")
    cbpath=''

    for addr in $splits
    do
        cbpath="$cbpath/$addr"
        # - debug ini
        #echo "[$addr]"
        #cbpath=$(createPath $cbpath $addr)
        #echo "path: $cbpath/"
        # - debug end
        #echo 'rsync -e "ssh -y -i "$keyfile" -p $sport" /dev/null $suser@$sserver:$sshare/$cbpath/ &> /dev/null'
        rsync -e "ssh -y -i "$keyfile" -p $sport " /dev/null $suser@$sserver:$sshare/$cbpath/ &> /dev/null
    done
}

#------------------------------------

# @brief: execute file transfer to rsync server
# @param: $1 - source path
# @param: $2 - target path
# note that the difference of the android version is that
# we must pass the keyfile in the ssh -i parameter
# at least this was the case with terminal IDE
# (com.spartacusrex.spartacuside)
# it also seems that there are differences of parameters accepted by the dropbear rsync
# e.g., the rsync command does not support -zz parameters
backupPathRsyncSSHAnd() {
    #echo 'rsync --progress -avhe "ssh -y -i "$keyfile" -p $sport" $1 $suser@$sserver:$sshare/$2'
    rsync --progress -avhe "ssh -y -i "$keyfile" -p $sport" $1 $suser@$sserver:$sshare/$2
}

#------------------------------------

# @brief: execute backup of a path to rsync server
# @param: $1 - source path
# @param: $2 - target path
# specific android version due to different handling of
# keyfile and rsync parameters
doBackupRsyncSSHAnd() {
    echo "--- backing up $1 to $2"
    createPathRsyncSSHAnd $2
    backupPathRsyncSSHAnd $1 $2
}

#------------------------------------


#====================================
# RSYNC SERVER BACKUP ANDROID,LINUX
#====================================
# this is a legacy implementation
# it requires an rsync server setup
# is unsecured, and not recommended

#------------------------------------

# @brief: create target path on rsync server
# @param: $1 - target path
createPathRsync() {
    #splits=$(echo $TARGET | tr "/" "\n")
    splits=$(echo $1 | tr "/" "\n")
    cbpath=''

    for addr in $splits
    do
        cbpath="$cbpath/$addr"
        # - debug ini
        #echo "[$addr]"
        #cbpath=$(createPath $cbpath $addr)
        #echo "path: $cbpath/"
        # - debug end
        #echo 'rsync /dev/null rsync://$ruser@$rserver/$rshare$cbpath/ &> /dev/null'
        rsync /dev/null rsync://$ruser@$rserver/$rshare$cbpath/ &> /dev/null
    done
}

#------------------------------------

# @brief: execute file transfer to rsync server
# @param: $1 - source path; $2 - target path
backupPathRsync() {
     #echo 'rsync -av --progress $1 rsync://$ruser@$rserver/$rshare$2'
     rsync -av --progress $1 rsync://$ruser@$rserver/$rshare$2
}

#------------------------------------

# @brief: execute backup of a path to rsync server
# @param: $1 - source path
# @param: $2 - target path
doBackupRsync() {
    echo "--- backing up $1 to $2"
    createPathRsync $2
    backupPathRsync $1 $2
}

#------------------------------------


#====================================
# EOF
#====================================
