cd /vagrant
git clone -b development https://github.com/Gameeso/openkit-server.git
cd openkit-server/dashboard

bundle update --path vendor/bundle
bundle exec bin/rake db:create RAILS_ENV=development
start gameeso