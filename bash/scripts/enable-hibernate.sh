#/bin/bash
# Ekimia.fr 2021
# Enables Hibernation with swap file with menus on Ubuntu 20.04

echo "WARNING : hibernate might fail on your machine if not officially supported , use with caution , press a key"
read start
echo " starting enabling hibernate "

#CHange this value to size the swapfile X times your ram
swapfilefactor=1.3

# install needed packages

sudo apt-get -y install uswsusp pm-utils hibernate


# Compute ideal size of swap ( Memesize * 1.5 )
swapfilesize=$(echo "$(cat /proc/meminfo | grep MemTotal | grep -oh '[0-9]*') * $swapfilefactor" |bc -l | awk '{print int($1)}')
echo "swapfilesize will be $swapfilesize bytes"
echo " creating new swapfile, this can take up to 2 minutes "
sudo swapoff /swapfile
sudo dd if=/dev/zero of=/swapfile bs=$swapfilesize count=1024 conv=notrunc
sudo mkswap /swapfile
sudo swapon /swapfile


swapfileoffset=1


# Get UUID & swap_offset

rootuuid=$((sudo findmnt -no SOURCE,UUID -T /swapfile) |cut -d\  -f 2)

echo rootuuid = $rootuuid


swapfileoffset=$((sudo swap-offset /swapfile)  |cut -d\  -f 4)

echo swapfileoffset = $swapfileoffset


# Modify initramfs

echo "RESUME=UUID=$rootuuid resume_offset=$swapfileoffset" |sudo tee /etc/initramfs-tools/conf.d/resume

# Update initramfs

sudo update-initramfs -k all -u

#Update grub

echo "Update Grub config"
#TODO Test if grub was already containing the string
#if [[ grep -q "resume" ]]

grubstring="resume=UUID=$rootuuid resume_offset=$swapfileoffset"


sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/ s|"\(.*\)"|"\1 '"${grubstring}"'"|' /etc/default/grub

sudo update-grub

echo " Update policy kit"



sudo tee /etc/polkit-1/localauthority/10-vendor.d/com.ubuntu.desktop.pkla <<EOF
[Enable hibernate in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes

[Enable hibernate in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions;org.freedesktop.login1.hibernate-ignore-inhibit
ResultActive=yes"
EOF


echo " setting hibernate delay after suspend at 1h in /etc/systemd/sleep.conf "

sudo echo "HibernateDelaySec=3600" | sudo tee -a /etc/systemd/sleep.conf


echo " setting sleep-then-hibernate on lid close in /etc/systemd/logind.conf "

sudo echo "HandleSuspendKey=suspend-then-hibernate" | sudo tee -a /etc/systemd/logind.conf

sudo echo "HandleLidSwitch=suspend-then-hibernate" | sudo tee -a /etc/systemd/logind.conf


echo "Forcing sleepandhibernate when DE ask for sleep ( waiting for gnome to fix this) "

#TODO : We need to handle old install where systemd is in /lib

sudo mv /usr/lib/systemd/system/systemd-suspend.service /usr/lib/systemd/system/systemd-suspendsave.service

sudo ln -s /usr/lib/systemd/system/systemd-suspend-then-hibernate.service /usr/lib/systemd/system/systemd-suspend.service


echo "Suspend-then-hibernate now active , press a key "
read p
