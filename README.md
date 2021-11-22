# Collection of scripts for logging your actions

## Traffic log

Use `traffic_log-setup.sh` (with root permissions) to set up traffic logging.
Traffic dumps are stored in /var/log/traffic.

Set up script adds `traffic_log.sh` to `/bin/`, adds `traffic_log.service` to `/lib/systemd/system/`, start and enable it.

Traffic_log is controlled by systemd unit `traffic_log.service`
    
    systemctl start traffic_log.service
    systemctl stop traffic_log.service
    systemctl status traffic_log.service


## Log.sh changes your .bashrc/.zshrc files to log all terminal sessions

Log.sh uses script for recoding terminal sessions. 
    
    ./log.sh

If you need to stop recording just `exit` 

Script saves files to cmd_logs (content and time)

You can reply terminal session using

    scriptreply time.log cmd.log [N (replay speed)]

