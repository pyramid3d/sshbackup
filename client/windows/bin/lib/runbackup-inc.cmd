:: @file   : runbackup-inc.cmd
:: @version: 2018-06-22
:: @created: 2017-04-11
:: @author : pyramid
:: @brief  : runbackup include file with backup functions (Windows)


::----------------------------------------
:: MAIN
::----------------------------------------

:: execute the import of all functions into main file
CALL:%*
:: make cygwin ssh work correctly
SET HOME=%USERPROFILE%
::
EXIT /B %ERRORLEVEL%

::----------------------------------------
:: LOGGING
::----------------------------------------

:echoStart
    ECHO backup started: %date% %time%
    :: EXIT function and return to main process
    EXIT /B %ERRORLEVEL%
::
::----------------------------------------

:echoFinish
    ECHO backup finished: %date% %time%
    :: EXIT function and return to main process
    EXIT /B %ERRORLEVEL%
::
::----------------------------------------

:echoConfig
    ECHO device: %device%
    ECHO user: %user%
    ECHO platform: %platform%
    ECHO server: %susrsrv%
    ECHO errorlevel: %ERRORLEVEL%
    :: EXIT function and return to main process
    EXIT /B %ERRORLEVEL%
::
::----------------------------------------

:: ----------------------------------------------------------
:: SCP BACKUP WINDOWS
:: ----------------------------------------------------------
:: requires putty pscp
:: still need rsync to create the remote folder if not exists (but not implemeted yet)
::

:: execute backup of a path to ssh server
:: inputs: %1 - source path; %2 - target path
:doBackupSCP
    :: assign parameters
    SET SOURCE=%1
    SET TARGET=%2
    ECHO --- backing up %SOURCE% to %susrsrv%:%sshare%%TARGET%

    :: create directory tree in case not exists
    echo mkdir -p %sshare%%TARGET% > remotecmd.sh
    ::ECHO -- create dir: %ssh% -p 10001 -i %keyfile% %susrsrv% -m "remotecmd.sh"
    %ssh% -p 10001 -i %keyfile% %susrsrv% -m "remotecmd.sh" > nul
    ::remove remote command file
    del remotecmd.sh

    :: copy recursive and preserving file attributes
    ::ECHO --- %scp% -r -p -P 10001 -i %keyfile% "%SOURCE%" %susrsrv%:%sshare%%TARGET%
    %scp% -r -p -P 10001 -i %keyfile% "%SOURCE%" %susrsrv%:%sshare%%TARGET%

    :: force execution to quit at the end of the "main" logic
    EXIT /B %ERRORLEVEL%
::


:: ----------------------------------------------------------
:: RSYNC CYGWIN SSH BACKUP WINDOWS
:: ----------------------------------------------------------
:: requires cwRsync

:: execute backup of a path to rsync server
:: inputs: %1 - source path; %2 - target path
:doBackupRsyncSSH
    ECHO --- backing up %1 to %susrsrv%:%sshare%%2
    call :createPathRsyncSSH %2
    call :backupPathRsyncSSH %1 %2
    :: EXIT function and return to main process
    ::EXIT /B 0
    EXIT /B %ERRORLEVEL%
::

:: create target path on rsync server
:: inputs: $1 - target path
:createPathRsyncSSH
    REM create variable to hold split folder name
    SET t=%1
    REM create variable to hold the full target path
    SET cbpath=
    :createPathRsyncSSHloop
    REM split input into first folder and the rest
    for /f "tokens=1* delims=/" %%a in ("%t%") do (
        REM ECHO.a: %%a
        SET appendix=%%a
        REM get split remainder to further process in loop
        SET t=%%b
    )
    REM append the first folder to path
    SET cbpath=%cbpath%%appendix%/
    REM create remote folder
    ::ECHO.create: %rsync% . %susrsrv%:%sshare%/%cbpath%
    ::%rsync% . %susrsrv%:%sshare%/%cbpath% > nul
    %rsync% -e "%ssh% -y -p 10001 -i %keyfile%" . %susrsrv%:%sshare%/%cbpath% > nul
    REM run the split remainder 
    if defined t goto createPathRsyncSSHloop
    :: EXIT function and return to main process
    EXIT /B %ERRORLEVEL%
::

:: execute file transfer to rsync server
:: inputs: $1 - source path; $2 - target path
:backupPathRsyncSSH
    ::ECHO.using HOME=%HOME%
    :: using putty ssh
    :: pops up a window with "unknown option --server"
    ::ECHO.backup: %rsync% --progress -ave "%pssh% -P 10001 -i %keyfileppk%" %1 %susrsrv%:%sshare%%2
    ::%rsync% --progress -ave "%pssh% -P 10001 -i %keyfileppk%" %1 %susrsrv%:%sshare%%2
    :: using cygwin ssh
    ::ECHO.backup: %rsync% --progress -ave "%ssh% -y -p 10001 -i %keyfile%" %1 %susrsrv%:%sshare%%2
    %rsync% --progress --chmod=ugo+rwx -ave "%ssh% -y -p 10001 -i %keyfile%" %1 %susrsrv%:%sshare%%2
    :: EXIT function and return to main process
    EXIT /B %ERRORLEVEL%
::

:: execute file transfer to rsync server
:: inputs: $1 - source path; $2 - target path
:copyFromSSH
    ::ECHO.using HOME=%HOME%
    ::ECHO.backup: %rsync% --progress -ave "%ssh% -y -p 10001 -i %keyfile%" %susrsrv%:%sshare%%1 %2
    %rsync% --progress --chmod=ugo+rwx -ave "%ssh% -y -p 10001 -i %keyfile%" %susrsrv%:%sshare%%1 %2
    :: EXIT function and return to main process
    EXIT /B %ERRORLEVEL%
::


:: ----------------------------------------------------------
:: RSYNC OPEN SSH BACKUP WINDOWS
:: ----------------------------------------------------------
:: requires Windows Open SSH

:: execute backup of a path to rsync server
:: inputs: %1 - source path; %2 - target path
:doBackupRsyncSSHOpen
    ECHO --- backing up %1 to %susrsrv%:%sshare%%2
    call :createPathRsyncSSHOpen %2
    call :backupPathRsyncSSHOpen %1 %2
    :: EXIT function and return to main process
    ::EXIT /B 0
    EXIT /B %ERRORLEVEL%
::

:: create target path on rsync server
:: inputs: $1 - target path
:createPathRsyncSSHOpen
    REM create variable to hold split folder name
    SET t=%1
    REM create variable to hold the full target path
    SET cbpath=
    :createPathRsyncSSHOpenloop
    REM split input into first folder and the rest
    for /f "tokens=1* delims=/" %%a in ("%t%") do (
        REM ECHO.a: %%a
        SET appendix=%%a
        REM get split remainder to further process in loop
        SET t=%%b
    )
    REM append the first folder to path
    SET cbpath=%cbpath%%appendix%/
    REM create remote folder
    ::ECHO.create: %rsync% . %susrsrv%:%sshare%/%cbpath%
    %rsync% . %susrsrv%:%sshare%/%cbpath% > nul
    REM run the split remainder 
    if defined t goto createPathRsyncSSHOpenloop
    :: EXIT function and return to main process
    EXIT /B %ERRORLEVEL%
::

:: execute file transfer to rsync server
:: inputs: $1 - source path; $2 - target path
:backupPathRsyncSSHOpen
    ECHO.backup: %rsync% -a --progress "%1" %susrsrv%:%sshare%%2
    ::test: %rsync% -av --progress "%1" %susrsrv%:%sshare%%2
    %rsync% --progress -ae "%1" %susrsrv%:%sshare%%2
    :: EXIT function and return to main process
    EXIT /B %ERRORLEVEL%
::


:: ----------------------------------------------------------
:: RSYNC SERVER BACKUP WINDOWS
:: ----------------------------------------------------------
:: requires cwRsync

:: execute backup of a path to rsync server
:: inputs: %1 - source path; %2 - target path
:doBackupRsync
    ECHO --- backing up %1 to rsync://%ruser%@%rserver%/%rshare%%2
    call :createPathRsync %2
    call :backupPathRsync %1 %2
    :: EXIT function and return to main process
    ::EXIT /B 0
    EXIT /B %ERRORLEVEL%
::

:: create target path on rsync server
:: inputs: $1 - target path
:createPathRsync
    REM create variable to hold split folder name
    SET t=%1
    REM create variable to hold the full target path
    SET cbpath=
    :createPathRsyncloop
    REM split input into first folder and the rest
    for /f "tokens=1* delims=/" %%a in ("%t%") do (
        REM ECHO.a: %%a
        SET appendix=%%a
        REM get split remainder to further process in loop
        SET t=%%b
    )
    REM append the first folder to path
    SET cbpath=%cbpath%%appendix%/
    REM create remote folder
    ::ECHO.create: %rsync% . rsync://%ruser%@%rserver%/%share%/%cbpath%
    ::%rsync% . rsync://%ruser%@%rserver%/%rshare%/%cbpath%
    %rsync% . rsync://%ruser%@%rserver%/%rshare%/%cbpath% > nul
    REM run the split remainder 
    if defined t goto createPathRsyncloop
    :: EXIT function and return to main process
    EXIT /B %ERRORLEVEL%
::

:: execute file transfer to rsync server
:: inputs: $1 - source path; $2 - target path
:backupPathRsync
    ::ECHO.backup: %rsync% -a --progress %1 rsync://%ruser%@%rserver%/%rshare%%2
    ::%rsync% -av --progress %1 rsync://%ruser%@%rserver%/%rshare%%2
    %rsync% -a --progress %1 rsync://%ruser%@%rserver%/%rshare%%2
    :: EXIT function and return to main process
    EXIT /B %ERRORLEVEL%
::

::----------------------------------------
:: EOF
::----------------------------------------
