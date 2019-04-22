:: @file   : runbackup-cfg.cmd
:: @version: 2019-04-22
:: @created: 2017-04-11
:: @author : pyramid
:: @brief  : runbackup configuration file (Windows)

:: ----------------------------------------------------------
:: CONFIGURATION
:: ----------------------------------------------------------

:: please run the install-cwrsync.cmd script before running backups
:: in order to avoid recurring "are you sure" messages when cwrsync
:: cannot add the server to the known_host file
:: or change to the cwrsync directory and run
:: mkdir home\%USERNAME%\.ssh
:: echo. >> home\%USERNAME%\.ssh\known_hosts


:: do not set local scope as variables are imported
::SETLOCAL

:: user configuration
SET device=DEVICE
SET user=localuser
:: platform=android,linux,windows
SET platform=windows
:: datadir=data,userdatadata
SET datadir=userdata

:: ssh configuration
SET suser=backupuser
SET sserver=myserver.ddns.net
SET susrsrv=%suser%@%sserver%
SET sshare=/mnt/nasdata

:: keys
:: putty keyfile
SET keyfileppk=%USERPROFILE%\.ssh\rsa-key.ppk
:: openSSH keyfile
SET keyfile=%USERPROFILE%\.ssh\id_rsa

:: rsync configuration (insecure)
SET ruser=rsyncuser
SET rserver=myserver.ddns.net
::SET rserver=172.100.1.1
SET rshare=backup@servername

:: folder configuration
SET logdir=%USERPROFILE%\log

:: program configuration
SET pscp=C:\programs\putty\pscp.exe
SET pssh=C:\programs\putty\putty.exe -ssh
:: source: http://www.cygwin.com/
SET scp=C:\Programs\cygwin\bin\scp.exe
SET ssh=C:\Programs\cygwin\bin\ssh.exe
SET rsync=C:\Programs\cygwin\bin\rsync.exe
:: sorce: cwRsync
REM SET ssh=C:\programs\cwRsync\bin\ssh.exe
REM SET rsync=C:\programs\cwRsync\bin\rsync.exe
:: OpenSSH (Windows 10 integrated)
SET ossh=C:\Windows\System32\OpenSSH\ssh.exe
SET oscp=C:\Windows\System32\OpenSSH\scp.exe

