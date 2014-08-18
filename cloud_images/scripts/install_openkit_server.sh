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

if [ "$GAMEESO_MODE" = "standalone" ]; then
  echo "RAILS_ENV=development" > /etc/env
  echo mysql-server mysql-server/root_password password gameeso | sudo debconf-set-selections
  echo mysql-server mysql-server/root_password_again password gameeso | sudo debconf-set-selections

  apt-get install -y mysql-server mysql-client libmysqlclient-dev libsqlite3-dev
else
  echo "RAILS_ENV=production" > /etc/env
  echo "Production Mode! Installing NGIX"
  apt-get install nginx
cat >>/etc/nginx/sites-enabled/gameeso <<EOL
server {
  listen  80;
  server_name api.*;
  location / {
    proxy_set_header X-Real-IP  $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header Host $host;
    proxy_pass http://localhost:3000/;
    client_max_body_size 512M;
    }
  }

  server {
    listen  80;
    server_name developer.*;
    location /assets {
      alias /var/gameeso/openkit-server/dashboard/public/assets/;
    }

    location / {
      proxy_set_header X-Real-IP  $remote_addr;
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header Host $host;
      proxy_pass http://localhost:3000/;
      client_max_body_size 512M;
    }
}
EOL
fi

apt-get install -y git nodejs ruby2.1 ruby2.1-dev libxslt1-dev redis-server build-essential

ln -s /usr/bin/nodejs /usr/bin/node

# CoffeeScript transpiler for OpenKit-Importer
npm install -g coffee-script
gem install bundle
