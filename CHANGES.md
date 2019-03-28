```
# @file: trunk/CHANGES.md
# @version: 2019-03-28
# @created: 2017-03-29
# @author: pyramid
# @brief: version documentation
```


=====================================
# SSH Backup
=====================================

code repository
https://github.com/pyramid3d/sshbackup

online guides
https://openteq.wordpress.com/portfolio/ssh-backup/


=====================================
## version history
=====================================
history is in inverse chronological order

newest date is on top

-------------------------------------

v1.20.03 | 2019-03-28
- .inc: better description for SSHAnd functions
- .inc: added mkdir for logdir
- android/-test: clear separation of standard  and android sections

v1.20.02 | 2019-03-27
- added instructions in runbackup-android
- client/posix holds bin/lib
- symlinks to lib in linux/bin and android/bin

v1.20.01 | 2019-03-26
- runbackup.inc: commented android version functions
- runbackup.inc: removed old obsolete code
- runbackup.cron: luser as unique .cron file parameter


v1.20.00 | 2019-03-25
- added $sport (ssh server port) param to backupRsyncSSH
- moved local params from runbackup to lib/.cfg
- structured .cron file (config, prod, tests)
- improved test entry descriptions
- cleaned parameters
- added CHANES.md
- created github repo

v1.10.17 | 2019-03-20
- improved .cron file description

v1.10.16 | 2019-03-03
- improved .cron file description

v1.10.15 | 2019-03-03
- added installation instructions

v1.10.10 | 2018-07-09
- improved functionality

v1.10.00 | 2018-05-28
- cloned rsync-backup to create secure solution
- ssh based solution
- setting up rsync server is obsolete now

v0.00.00 | 2017-03-29
- named solution rsync-backup
- created first rsync based backup solution

