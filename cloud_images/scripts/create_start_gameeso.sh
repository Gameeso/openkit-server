echo "Creating Gameeso Boot configuration..."

cat >/etc/init/gameeso.conf <<EOL
description "Gameeso Game Backend"

start on (local-filesystems and net-device-up IFACE!=lo and started mysql)
stop on shutdown

script
exec /usr/bin/start_gameeso
end script
EOL

# Upstart doesnt work on Docker for obvious reasons, so we run the dependency stuff on our own
if [ "$PACKER_BUILDER_TYPE" = "docker" ]; then
cat >>/usr/bin/start_gameeso <<EOL
redis-server &
EOL

# only start MySQL if in standalone mode
if [ "$GAMEESO_MODE" = "standalone" ]; then
cat >>/usr/bin/start_gameeso <<EOL
		/etc/init.d/mysql start
EOL
fi

fi

cat >>/usr/bin/start_gameeso <<EOL
mkdir -p /var/gameeso
chmod 7777 -R /var/gameeso

cd /var/gameeso

if [ ! -d "openkit-server" ]; then
	echo "Cloning & installing latest Gameeso server development branch"
	git clone -b development https://github.com/Gameeso/openkit-server.git

	echo "Configuring the NodeJS-side"
	cd openkit-server/openkit_importer
	npm install

	echo "Creating Push-cert folders"
	mkdir -p /var/gameeso/apple_certs/production
	mkdir -p /var/gameeso/apple_certs/sandbox

	cd ../dashboard

	echo "Copying config files..."
	cp config/database.sample.yml config/database.yml
	cp /home/gameeso/ok_config.rb config/ok_config.rb

	bundle install --path vendor/bundle
	bundle exec bin/rake db:setup

	if [ "$GAMEESO_MODE" = "production" ]; then
		bundle exec bin/rake assets:precompile
	fi
fi

cd /var/gameeso/openkit-server/dashboard
bin/rails server
EOL

chmod a+x /usr/bin/start_gameeso
