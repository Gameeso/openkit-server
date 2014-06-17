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

mkdir -p /var/gameeso
chmod 7777 -R /var/gameeso

cd /var/gameeso

if [ ! -d "openkit-server" ]; then
	# Vagrant tends to delete contents of a synced folder once it's trying to set up synced folders.
	# By waiting for 10 seconds we avoid to become deleted right in the middle.
	
	sleep 10
	echo "Cloning & installing latest Gameeso server development branch"
	git clone -b development https://github.com/Gameeso/openkit-server.git
	cd openkit-server/dashboard

	bundle install --path vendor/bundle
	bundle update
	bundle exec bin/rake db:setup RAILS_ENV=development  
fi

cd /var/gameeso/openkit-server/dashboard
bin/rails server

EOL

chmod a+x /usr/bin/start_gameeso

cat >/etc/init/gameeso.conf <<EOL
description "Gameeso Game Backend"

start on (local-filesystems and net-device-up IFACE!=lo)
stop on shutdown

script
exec /usr/bin/start_gameeso
end script
EOL

# Firewall
echo "Installing firewall"
ufw enable
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 3000