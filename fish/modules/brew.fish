function mac-brew-all
    set type $argv[1]
    set name $argv[2]

    if test -z "$type" -o -z "$name"
        echo "Usage: mac-brew-all <cask|formula> <package>"
        return
    end

    for host in $MACHINES
        ssh -o ConnectTimeout=5 $LAB_USER@$host.$LAB_DOMAIN \
            "/opt/homebrew/bin/brew install --$type $name" &
    end

    disown
end