function mac
    set id $argv[1]
    set action $argv[2]

    if test -z $id
        echo "Usage: mac <number> [status|reboot|down]"
        return
    end

    set num (string pad -w 3 -c 0 $id)
    set host mac-$num

    switch $action
        case ""
            ssh $LAB_USER@$host.$LAB_DOMAIN
        case status
            ssh -o ConnectTimeout=5 $LAB_USER@$host.$LAB_DOMAIN uptime
        case reboot
            ssh -t $LAB_USER@$host.$LAB_DOMAIN sudo reboot
        case down
            ssh -t $LAB_USER@$host.$LAB_DOMAIN sudo shutdown -h now
    end
end


function mac-all
    set action $argv[1]

    if test -z "$action"
        echo "Usage: mac-all {status|reboot|down}"
        return
    end

    for host in $MACHINES
        switch $action
            case status
                ssh -o ConnectTimeout=5 $LAB_USER@$host.$LAB_DOMAIN uptime &
            case reboot
                ssh -o ConnectTimeout=5 $LAB_USER@$host.$LAB_DOMAIN "sudo reboot" &
            case down
                ssh -o ConnectTimeout=5 $LAB_USER@$host.$LAB_DOMAIN "sudo shutdown -h now" &
        end
    end

    disown
end