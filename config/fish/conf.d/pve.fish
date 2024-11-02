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

function pve-ssh-copy-id -d "Copy the SSH public key to a Proxmox VM/LXC" -a name
    set cid $argv[1]
    echo "Copying SSH public key to $cid"

    cat ~/.ssh/id_ed25519.pub |
        ssh $node bash -c "pct exec $cid -- bash -c \"mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys\""
end


function win
    cv4pve-pepper --api-token $PVE_API_KEY --host 10.0.0.10 --viewer (which remote-viewer) --vmid 106 --start-or-resume
end
