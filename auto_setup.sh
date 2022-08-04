#!/bin/bash
/usr/sbin/crond start
echo "*/1 * * * * /bin/bash /etc/pkgship/service-monitor.sh" > /var/spool/cron/root
bash /etc/pkgship/auto_install_pkgship_requires.sh redis
bash /etc/pkgship/auto_install_pkgship_requires.sh elasticsearch
su -c "pkgshipd start" pkgshipuser
pkgship init
su -c "pkgship-paneld start" pkgshipuser
su -c "pkgship-panel &" pkgshipuser