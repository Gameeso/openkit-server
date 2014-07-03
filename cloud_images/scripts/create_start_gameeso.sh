echo "Creating Gameeso Boot configuration..."

cat >/etc/init/gameeso.conf <<EOL
description "Gameeso Game Backend"

start on (local-filesystems and net-device-up IFACE!=lo and started mysql)
stop on shutdown

script
exec /usr/bin/start_gameeso
end script
EOL

cat >/usr/bin/start_gameeso <<EOL

mkdir -p /var/gameeso
chmod 7777 -R /var/gameeso

cd /var/gameeso

if [ ! -d "openkit-server" ]; then
	echo "Cloning & installing latest Gameeso server development branch"
	git clone -b development https://github.com/Gameeso/openkit-server.git
	cd openkit-server/dashboard

	# Copy config files
	cp config/database.sample.yml database.yml
	cp config/ok_config.sample.rb ok_config.rb

	bundle install --path vendor/bundle
	bundle update
	bundle exec bin/rake db:setup RAILS_ENV=development
fi

cd /var/gameeso/openkit-server/dashboard
bin/rails server

EOL

chmod a+x /usr/bin/start_gameeso