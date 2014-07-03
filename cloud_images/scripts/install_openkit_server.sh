echo "gem: --no-rdoc --no-ri" > ~/.gemrc

apt-get install -y python-software-properties software-properties-common
apt-add-repository -y ppa:brightbox/ruby-ng
apt-get update

echo mysql-server mysql-server/root_password password gameeso | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again password gameeso | sudo debconf-set-selections

apt-get install -y git mysql-server ruby2.1 ruby2.1-dev mysql-client libmysqlclient-dev libsqlite3-dev libxslt1-dev redis-server build-essential

gem install bundle

# Firewall
echo "Installing firewall"
ufw enable
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 3000