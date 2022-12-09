#!/bin/sh

addgroup \
	-g $GID \
	-S \
	$FTP_USER

adduser \
	-D \
	-G $FTP_USER \
	-h /home/$FTP_USER \
	-s /bin/false \
	-u $UID \
	$FTP_USER

if [[ -v "$FTP_USER2" ]]; then
	adduser \
		 -D \
		 -G $FTP_USER2 \
		 -h /home/$FTP_USER2 \
		 -s /bin/false \
		 -u $UID \
		 $FTP_USER2
fi

mkdir -p /home/$FTP_USER
chown -R $FTP_USER:$FTP_USER /home/$FTP_USER
echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd

if [[ -v "$FTP_USER2" ]]; then
	mkdir -p /home/$FTP_USER2
	chown -R $FTP_USER2:$FTP_USER2 /home/$FTP_USER2
	echo "$FTP_USER2:$FTP_PASS2" | /usr/sbin/chpasswd
fi

touch /var/log/vsftpd.log
tail -f /var/log/vsftpd.log | tee /dev/stdout &
touch /var/log/xferlog
tail -f /var/log/xferlog | tee /dev/stdout &

exec "$@"
