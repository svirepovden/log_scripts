# Collection of scripts for logging your actions

## Traffic log

**DOESNT WORK PROPERLY**
An `/etc/init.rc` init for dumping traffic from all interfaces (and 
compress it afterwards).
Records traffic in 10 min sessions.
Sessions are stored in `/root` by default

    ./traffic_log.sh start 
    ./traffic_log.sh status
    ./traffic_log.sh stop

User is important, script adds a task to user crontab.

### TODO
- chose dir to save

## Log.sh changes your .bashrc/.zshrc files to log all terminal sessions

Log.sh uses script for recoding terminal sessions. 
    
    ./log.sh

If you need to stop recording just `exit` 

Script saves files to cmd_logs (content and time)

You can reply terminal session using

    scriptreply time.log cmd.log [N (replay speed) ]

