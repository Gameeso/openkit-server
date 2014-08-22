echo "Installing Gameeso"
echo "Mode: $GAMEESO_MODE"
echo "Build Type: $PACKER_BUILDER_TYPE"
echo "gem: --no-rdoc --no-ri" > ~/.gemrc

# Permanent variables
echo "GAMEESO_MODE=$GAMEESO_MODE" > /etc/env

# I know I know... Double APT update. It's because the docker 'ubuntu' image does not have a recent APT-cache at all,
# rendering unable to install python-software-properties & software-properties-common without updating first.
apt-get update

apt-get install -y python-software-properties software-properties-common
apt-add-repository -y ppa:brightbox/ruby-ng
add-apt-repository -y ppa:chris-lea/node.js

apt-get update

# Boost Ruby
cat >>/etc/environment <<EOL
    RUBY_GC_HEAP_INIT_SLOTS=1000000 # 1M
    RUBY_GC_HEAP_FREE_SLOTS=500000  # 0.5M
    RUBY_GC_HEAP_GROWTH_FACTOR=1.1
    RUBY_GC_HEAP_GROWTH_MAX_SLOTS=10000000 # 10M
    RUBY_GC_MALLOC_LIMIT_MAX=1000000000    # 1G
    RUBY_GC_MALLOC_LIMIT_GROWTH_FACTOR=1.1
EOL

if [ "$GAMEESO_MODE" = "standalone" ]; then
  echo "RAILS_ENV=development" >> /etc/environment
  echo mysql-server mysql-server/root_password password gameeso | sudo debconf-set-selections
  echo mysql-server mysql-server/root_password_again password gameeso | sudo debconf-set-selections

  apt-get install -y mysql-server mysql-client
else
  echo "RAILS_ENV=production" >> /etc/environment
fi

apt-get install -y libmysqlclient-dev libsqlite3-dev git nodejs ruby2.1 ruby2.1-dev libxslt1-dev redis-server build-essential

# CoffeeScript transpiler for OpenKit-Importer
npm install -g coffee-script
chmod 7777 -R /home/gameeso/.npm
gem install bundle
