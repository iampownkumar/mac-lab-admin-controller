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


# ---------------------------------------------------------
# PARALLEL LAB CONTROL
# ---------------------------------------------------------
function mac-all
    set action $argv[1]

    if test -z "$action"
        echo "Usage: mac-all {status|reboot|down}"
        return
    end

    set green (set_color green)
    set red (set_color red)
    set yellow (set_color yellow)
    set normal (set_color normal)

    if test "$action" = "status"
        set online 0
        set offline 0

        echo "📡 Checking all machines (parallel, 5s timeout)"
        echo "---------------------------------------------"

        for host in $MACHINES
            ssh -o ConnectTimeout=5 -o ConnectionAttempts=1 -o ServerAliveInterval=2 -o ServerAliveCountMax=1 \
                ritmaclab@$host.local "uptime" > /tmp/$host.uptime 2>/dev/null &
        end

        wait

        for host in $MACHINES
            if test -s /tmp/$host.uptime
                set online (math $online + 1)
                echo "$green$host : ONLINE  → "(cat /tmp/$host.uptime)"$normal"
            else
                set offline (math $offline + 1)
                echo "$red$host : OFFLINE$normal"
            end
            rm -f /tmp/$host.uptime
        end

        echo "---------------------------------------------"
        echo "$green✅ ONLINE : $online$normal"
        echo "$red❌ OFFLINE: $offline$normal"
        echo "$yellow🖥 TOTAL  : "(math $online + $offline)"$normal"
        return
    end

    for host in $MACHINES
        echo "→ $action on $host"

        switch $action
            case reboot
                ssh -o ConnectTimeout=5 -o ConnectionAttempts=1 -o ServerAliveInterval=2 -o ServerAliveCountMax=1 \
                    ritmaclab@$host.local "sudo reboot" </dev/null >/dev/null 2>&1 &
            case down
                ssh -o ConnectTimeout=5 -o ConnectionAttempts=1 -o ServerAliveInterval=2 -o ServerAliveCountMax=1 \
                    ritmaclab@$host.local "sudo shutdown -h now" </dev/null >/dev/null 2>&1 &
        end
    end

    disown
    echo "🚀 $action commands dispatched to all machines"
end
