sudo mount /dev/mapper/main-root /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p1 /mnt/boot
sudo swapon /dev/mapper/main-swap
sudo mkdir -p /mnt/nix
sudo mount /dev/mapper/main-nix--store /mnt/nix
sudo mkdir -p /mnt/home
sudo mount /dev/mapper/main-home /mnt/home
