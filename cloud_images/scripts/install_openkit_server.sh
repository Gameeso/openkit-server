echo "Installing Gameeso"
echo "Mode: $GAMEESO_MODE"
echo "Build Type: $PACKER_BUILDER_TYPE"
echo "gem: --no-rdoc --no-ri" > ~/.gemrc

# I know I know... Double APT update. It's because the docker 'ubuntu' image does not have a recent APT-cache at all,
# rendering unable to install python-software-properties & software-properties-common without updating first.
apt-get update

apt-get install -y python-software-properties software-properties-common
apt-add-repository -y ppa:brightbox/ruby-ng
add-apt-repository -y ppa:chris-lea/node.js

apt-get update

if [ "$GAMEESO_MODE" = "standalone" ]; then
  echo "RAILS_ENV=development" > /etc/env
  echo mysql-server mysql-server/root_password password gameeso | sudo debconf-set-selections
  echo mysql-server mysql-server/root_password_again password gameeso | sudo debconf-set-selections

  apt-get install -y mysql-server mysql-client libmysqlclient-dev libsqlite3-dev
else
  echo "RAILS_ENV=production" > /etc/env
fi

apt-get install -y git nodejs ruby2.1 ruby2.1-dev libxslt1-dev redis-server build-essential

ln -s /usr/bin/nodejs /usr/bin/node

# CoffeeScript transpiler for OpenKit-Importer
npm install -g coffee-script
gem install bundle
