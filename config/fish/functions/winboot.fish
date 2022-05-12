function winboot --wraps='grub2-reboot "Windows Boot Manager (on /dev/nvme0n1p1)"; sudo reboot' --description 'alias winboot grub2-reboot "Windows Boot Manager (on /dev/nvme0n1p1)"; sudo reboot'
  grub2-reboot "Windows Boot Manager (on /dev/nvme0n1p1)"; sudo reboot $argv; 
end
