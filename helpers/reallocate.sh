#!/bin/bash
# Notes:
# 1. Use this script to move storage space from /home to /root
# 2. This script is designed to work on rhel6 and rhel7 boxes
echo "Reallocating disk space to the home partition"
umount /home
lvremove -f /dev/mapper/*home
sed -i '/home/d' /etc/fstab
lvresize -l +100%FREE /dev/mapper/*root
if uname -r | grep -q el6; then resize2fs -f /dev/mapper/*root; else xfs_growfs / && mount / -o inode64,remount; fi
echo "Successfully completed reallocation"
