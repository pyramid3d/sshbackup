@echo off
:: @file   : runbackup-test.cmd
:: @version: 2019-04-22
:: @created: 2017-04-11
:: @author : pyramid
:: @brief  : run backup test (Windows)

SETLOCAL

:: ----------------------------------------------------------
:: LIBS & CONFIG
:: ----------------------------------------------------------

CALL lib\runbackup-cfg.cmd

ECHO ------------------------------
ECHO --- runbackup v 2019-04-22 ---
CALL lib\runbackup-inc.cmd :echoConfig
ECHO ------------------------------
CALL lib\runbackup-inc.cmd :echoStart
ECHO ------------------------------

::CALL :performTest
::EXIT /B %ERRORLEVEL%


:: ----------------------------------------------------------
:: MAIN DRIVE C
:: ----------------------------------------------------------
:: use cygdrive if running with cygwin or cwRsync (standard)
SET drive=/cygdrive/c
:: if using putty, or openssh
::SET drive=C:


::----------------------------------------
:: secure archive copy (diff&zip)
::----------------------------------------

::----------------------------------------
:: backup one file (device.id)
SET SOURCE=%drive%/users/%user%/bin/runbackup-test
SET TARGET=/install.config/app.user.data/%platform%/%user%/%device%/home/bin/
CALL lib\runbackup-inc.cmd :doBackupRsyncSSH %SOURCE% %TARGET%

::----------------------------------------
:: backup folder (bin to home)
SET SOURCE=%drive%/users/%user%/.ssh
SET TARGET=/install.config/app.user.data/%platform%/%user%/%device%/home/
CALL lib\runbackup-inc.cmd :doBackupRsyncSSH %SOURCE% %TARGET%


::----------------------------------------
:: secure direct full copy (no diff)
::----------------------------------------

::----------------------------------------
:: direct copy one file (device.id)
SET SOURCE=%drive%/%datadir%/device.id.DEVICE
SET TARGET=/install.config/app.user.data/%platform%/%user%/%device%/data/
CALL lib\runbackup-inc.cmd :doBackupSCP %SOURCE% %TARGET%

::----------------------------------------
:: get file from server
CALL lib\runbackup-inc.cmd :copyFromSSH /filename.txt %drive%/%datadir%/


:: ----------------------------------------------------------
:: FINISH
:: ----------------------------------------------------------
ECHO ------------------------------
CALL lib\runbackup-inc.cmd :echoFinish
ECHO ------------------------------


:: do not close terminal to show
:: progress if run from explorer
PAUSE


:: force execution to quit at the end of the "main" logic
EXIT /B %ERRORLEVEL%

:: ----------------------------------------------------------
:: EOF
:: ----------------------------------------------------------
