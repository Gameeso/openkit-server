echo "gem: --no-rdoc --no-ri" > ~/.gemrc

apt-get install -y python-software-properties software-properties-common
apt-add-repository -y ppa:brightbox/ruby-ng
apt-get update

echo mysql-server mysql-server/root_password password gameeso | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again password gameeso | sudo debconf-set-selections

apt-get install -y git mysql-server ruby2.1 ruby2.1-dev mysql-client libmysqlclient-dev libsqlite3-dev libxslt1-dev redis-server build-essential

gem install bundle

mkdir -p /var/gameeso
chmod 7777 -R /var/gameeso

cat >/usr/bin/start_gameeso <<EOL
cd /var/gameeso/openkit-server/dashboard
bin/rails server
EOL

chmod a+x /usr/bin/start_gameeso

cat >/etc/init/gameeso.conf <<EOL
description "Gameeso Game Backend"
 
start on filesystem or runlevel [2345]
stop on run level [!2345]
 
exec /usr/bin/start_gameeso

EOL

# Firewall
echo "Installing firewall"
ufw enable
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 3000