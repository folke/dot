set node "root@10.0.0.10"

function pve
    ssh -t $node $argv
end

function pct_enter
    set name $argv[1]
    set id (pve pct list | grep $name | awk '{print $1}' | head -n1)
    if test -z $id
        echo "VM $name not found"
        return 1
    end
    pve pct enter $id
end

function win
    test -z "$PVE_API_KEY"; and echo "PVE_API_KEY not set" and return 1
    cv4pve-pepper --api-token $PVE_API_KEY --host 10.0.0.10 --viewer (which remote-viewer) --vmid 106 --start-or-resume
end
