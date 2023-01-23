function winboot --wraps='sudo grub2-reboot "Windows Boot Manager (on /dev/nvme0n1p1)"; sudo reboot' --description 'alias winboot sudo grub2-reboot "Windows Boot Manager (on /dev/nvme0n1p1)"; sudo reboot'
  sudo grub2-reboot "Windows Boot Manager (on /dev/nvme0n1p1)"; sudo reboot $argv
        
end
