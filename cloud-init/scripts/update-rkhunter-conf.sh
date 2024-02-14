#!/bin/bash
sed -i 's/MIRRORS_MODE=1/MIRRORS_MODE=0/' /etc/rkhunter.conf
sed -i 's/UPDATE_MIRRORS=0/UPDATE_MIRRORS=1/' /etc/rkhunter.conf
sed -i 's|WEB_CMD="/bin/false"|WEB_CMD=""|' /etc/rkhunter.conf