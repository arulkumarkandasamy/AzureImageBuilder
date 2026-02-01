#!/bin/bash
echo "--- Starting Linux Hardening ---"

# 1. Set Password Policies
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   7/' /etc/login.defs

# 2. Disable USB Storage (Common CIS Check)
echo "install usb-storage /bin/true" > /etc/modprobe.d/usb-storage.conf

# 3. Lock Down SSH
sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#MaxAuthTries.*/MaxAuthTries 4/' /etc/ssh/sshd_config

# 4. Cleanup
apt-get autoremove -y || dnf autoremove -y
rm -rf /tmp/*
echo "--- Hardening Complete ---"