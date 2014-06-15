echo "gem: --no-rdoc --no-ri" > ~/.gemrc

apt-get install -y python-software-properties software-properties-common
apt-add-repository -y ppa:brightbox/ruby-ng
apt-get update

echo mysql-server mysql-server/root_password password gameeso | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again password gameeso | sudo debconf-set-selections

apt-get install -y git mysql-server ruby2.1 ruby2.1-dev mysql-client libmysqlclient-dev libsqlite3-dev libxslt1-dev redis-server build-essential

gem install bundle

mkdir -p /vagrant
chmod 7777 -R /vagrant

cat >/etc/init/gameeso.conf <<EOL
description "Gameeso Game Backend"
 
start on filesystem or runlevel [2345]
stop on run level [!2345]
 
exec start-stop-daemon --start --chuid vagrant --chdir /vagrant/openkit-server/dashboard/ --exec "/vagrant/openkit-server/dashboard/bin/rails" \
    -- server
EOL