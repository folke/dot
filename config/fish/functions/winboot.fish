function winboot --wraps='grub2-reboot "Windows Boot Manager (on /dev/nvme0n1p1)"' --description 'alias winboot grub2-reboot "Windows Boot Manager (on /dev/nvme0n1p1)"'
    sudo grub2-reboot "Windows Boot Manager (on /dev/nvme0n1p1)" $argv
end
