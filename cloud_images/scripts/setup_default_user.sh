sudo id -u gameeso &>/dev/null sudo useradd -m gameeso
sudo adduser gameeso sudo
sudo echo "gameeso:$1" | /usr/sbin/chpasswd
