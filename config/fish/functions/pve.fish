set node "root@10.0.0.10"

function pve
    set name $argv[1]
    set id (pct list | grep $name | awk '{print $1}' | head -n1)
    if test -z $id
        echo "VM $name not found"
        return 1
    end
    pct enter $id
end

function pve-ssh-copy-id -d "Copy the SSH public key to a Proxmox VM/LXC" -a name
    set cid (pve $argv[1])
    cat ~/.ssh/id_ed25519.pub |
        ssh $node bash -c 'pct exec $cid -- bash -c "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"'
end

function pct -d "Run pct on Proxmox"
    ssh -t $node pct $argv
end
