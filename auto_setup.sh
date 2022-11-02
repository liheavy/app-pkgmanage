#!/bin/bash


/usr/sbin/crond start
bash /etc/pkgship/auto_install_pkgship_requires.sh redis
bash /etc/pkgship/auto_install_pkgship_requires.sh elasticsearch
su -c "pkgshipd start" pkgshipuser
pkgship init
su -c "pkgship-paneld start" pkgshipuser
su -c "pkgship-panel &" pkgshipuser

cat > /var/spool/cron/root <<EOF
*/1 * * * * /bin/bash /etc/pkgship/service-monitor.sh
0 3 * * * python3 /etc/pkgship/timer_sync
EOF
