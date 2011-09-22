# install rubygems the recommended way
wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
tar -xvf rubygems-1.8.10.tgz
cd rubygems-1.8.10
ruby setup.rb

cd /home/tuna

# nokogiri has native extensions, and is a pain to build
# plus, the header files seem to be in nonstandard places)
yum -y install libxml2 libxml2-devel libxslt libxslt-devel
gem install nokogiri -- --with-xml2-include=/usr/include/libxml2/ --with-xslt-include=/usr/include/libxslt/

# install bundler via the previously-installed rubygems!
gem install bundler

# get (our fork of) bigtuna
cd /home/tuna
git clone git://github.com/vnc/bigtuna.git

# install bigtuna's bundle via the previously-install bundler!
cd /home/tuna/bigtuna
bundle install

# Create a config file for bigtuna, so it can find all our DBs
echo 'production:
  adapter: sqlite3
  database: db/prod.sqlite
  pool: 5' > config/database.yml

# Uncomment a line in the SVN config file, to allow saving pwds in plain-text.
# This allows bigtuna's svn checkout command to run w/o prompts
sed -i 's/^# store-passwords = yes/store-passwords = yes/;' /home/tuna/.subversion/config

# Generate some RSA keys for the tuna user w/o a passphrase
ssh-keygen -q -t rsa -f /home/tuna/.ssh/id_rsa -N ""

# Create the DB schemas
RAILS_ENV=production bundle exec rake db:schema:load

# Run delayed_job, which will process our builds in the bg
RAILS_ENV=production ./script/delayed_job start

# Start that crap!
RAILS_ENV=production bundle exec rails s -p 3389
