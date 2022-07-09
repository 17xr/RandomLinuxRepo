#!/bin/bash

pacstrap --noconfirm /mnt base linux-zen linux-zen-headers linux-lts linux-lts-headers linux-firmware git nano intel-ucode btrfs-progs

genfstab /mnt -U >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Africa/Algiers /etc/localtime

hwclock --systohc

sed -i '177s/.//' /etc/locale.gen
sed -i '248s/.//' /etc/locale.gen

locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=fr" >> /etc/vconsole.conf
echo "abdou-ms7680" >> /etc/hostname
echo "127.0.0.1    localhost" >> /etc/hosts
echo "::1        localhost" >> /etc/hosts
echo "127.0.1.1    abdou-ms7680.localdomain    abdou-ms7680" >> /etc/hosts

echo root:password | chpasswd

pacman -S --noconfirm grub networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel avahi xdg-user-dirs xdg-utils cups alsa-utils alsa-firmware pipewire reflector acpi qemu-desktop virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat iptables-nft ufw flatpak acpid os-prober ntfs-3g ttf-roboto

pacman -S dkms
echo "" >> /etc/dkms/framework.conf
echo "sign_file='/usr/lib/modules/${kernelver}/build/scripts/sign-file'" >> /etc/dkms/framework.conf

pacman -S --noconfirm --needed nvidia nvidia-utils nvidia-settings

grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable cups.service
systemctl enable avahi-daemon
systemctl enable libvirtd
systemctl enable ufw

useradd -m -G wheel _17xr
echo _17xr:password | chpasswd

printf "\e[1;32m Done! Don't forget to modify visudo to enable sudo for your user.\e[0m"
