echo "gem: --no-rdoc --no-ri" > ~/.gemrc

apt-get install -y python-software-properties software-properties-common
apt-add-repository -y ppa:brightbox/ruby-ng
apt-get update

echo mysql-server mysql-server/root_password password gameeso | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again password gameeso | sudo debconf-set-selections

apt-get install -y mysql-server ruby2.1 ruby2.1-dev mysql-client libmysqlclient-dev libsqlite3-dev libxslt1-dev redis-server

gem install bundle
apt-get install -y git

mkdir -p /vagrant
chmod 744 -R /vagrant
cd /vagrant

git clone -b development https://github.com/Gameeso/openkit-server.git
cd openkit-server/dashboard