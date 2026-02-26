function mac-all-notify
    set msg $argv

    for host in $MACHINES
        ssh $LAB_USER@$host.$LAB_DOMAIN \
        "osascript -e 'display notification \"$msg\" with title \"Lab Admin\"'" &
    end

    disown
end

function mac-all-alert
    set msg $argv

    for host in $MACHINES
        ssh $LAB_USER@$host.$LAB_DOMAIN \
        "afplay /System/Library/Sounds/Glass.aiff; \
         osascript -e 'display notification \"$msg\" with title \"Lab Admin\"'" &
    end

    disown
end