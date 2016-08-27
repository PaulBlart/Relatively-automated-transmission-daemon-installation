add-apt-repository --assume-yes ppa:transmissionbt/ppa
apt-get update
apt-get --assume-yes install transmission-cli
apt-get --assume-yes install transmission-common
apt-get --assume-yes install transmission-daemon

# Adding user, 'borrowed' from http://www.cyberciti.biz/tips/howto-write-shell-script-to-add-user.html
if [ $(id -u) -eq 0 ]; then
        read -p "Enter username : " username
        read -s -p "Enter password : " password
        egrep "^$username" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "$username exists!"
                exit 1
        else
                pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
                useradd -m -p $pass $username
                [ $? -eq 0 ] && echo "User has been added!" || echo "Username failed to register"
	fi
else
	exit 2
fi
cd /home/$username/
mkdir transmission
usermod -a -G debian-transmission $username
chgrp -R debian-transmission /home/$username/transmission
chmod -R 775 /home/&username/transmission
service transmission-daemon stop
cd /etc/transmission-daemon
rm settings.json
cd /home/$username
mkdir tmp
cd tmp
https://raw.githubusercontent.com/PaulBlart/Relatively-automated-transmission-daemon-installation/master/settings.json
cp settings.json /etc/transmission-daemon/
cd ../
rm -rf /tmp/


service transmission-daemon start
echo Connect with <server ip>:9091