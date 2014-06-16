date > /etc/vagrant_box_build_time

mkdir /home/gameeso/.ssh
wget --no-check-certificate \
    'https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' \
    -O /home/gameeso/.ssh/authorized_keys
chown -R gameeso /home/gameeso/.ssh
chmod -R go-rwsx /home/gameeso/.ssh
