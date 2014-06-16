cd /var/gameeso
git clone -b development https://github.com/Gameeso/openkit-server.git
cd openkit-server/dashboard

bundle install --path vendor/bundle
bundle update
bundle exec bin/rake db:setup RAILS_ENV=development

start gameeso