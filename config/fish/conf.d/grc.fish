set -U grc_plugin_execs df dig ifconfig \
    make mount mtr netstat ping ps tail traceroute \
    wdiff blkid du dnf env id ip iostat journalctl kubectl \
    last lsattr lsblk lspci lsmod lsof getfacl getsebool ulimit uptime nmap \
    fdisk findmnt free semanage sar ss sysctl systemctl \
    tcpdump tune2fs vmstat w who sockstat

for executable in $grc_plugin_execs
    if type -q $executable
        function $executable --inherit-variable executable --wraps=$executable
            if isatty 1
                grc $executable $argv
            else
                eval command $executable $argv
            end
        end
    end
end
