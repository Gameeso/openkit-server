echo "gem: --no-rdoc --no-ri" > ~/.gemrc

sudo apt-get install -y git
git clone -b development https://github.com/Gameeso/openkit-server.git
cd openkit-server/dashboard

sudo apt-get install -y python-software-properties software-properties-common
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update

echo mysql-server mysql-server/root_password password gameeso | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again password gameeso | sudo debconf-set-selections

sudo apt-get install -y mysql-server build-essential ruby2.1 ruby2.1-dev mysql-client libmysqlclient-dev libsqlite3-dev libxslt1-dev

wget http://download.redis.io/releases/redis-2.8.11.tar.gz
tar xzf redis-2.8.11.tar.gz
cd redis-2.8.11
make && sudo make install

sudo gem install bundle
bundle install