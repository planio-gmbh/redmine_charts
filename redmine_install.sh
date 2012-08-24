#/bin/bash

if [[ ! "$TESTSPACE" = /* ]] ||
   [[ ! "$PATH_TO_REDMINE" = /* ]] ||
   [[ ! "$PATH_TO_TESTER" = /* ]] ||
   [[ ! "$NAME_OF_PLUGIN" = * ]] ||
   [[ ! "$PATH_TO_PLUGIN" = /* ]];
then
  echo "You should set"\
       " TESTSPACE, PATH_TO_REDMINE, PATH_TO_TESTER"\
       " NAME_OF_PLUGIN, PATH_TO_PLUGIN"\
       " environment variables"
  echo "You set:"\
       "$TESTSPACE"\
       "$PATH_TO_REDMINE"\
       "$PATH_TO_PLUGIN"
       "$NAME_OF_PLUGIN"
       "$PATH_TO_PLUGIN"
  exit 1;
fi

case $REDMINE_VER in
  1)  export PATH_TO_INSTALL=./vendor/plugins # for redmine < 2.0
      export GENERATE_SECRET=generate_session_store
      export MIGRATE_PLUGINS=db:migrate_plugins
      export REDMINE_GIT_REPO=git://github.com/edavis10/redmine.git
      export REDMINE_GIT_TAG=1.4.4
      ;;
  2)  export PATH_TO_INSTALL=./plugins # for redmine 2.0
      export GENERATE_SECRET=generate_secret_token
      export MIGRATE_PLUGINS=redmine:plugins:migrate
      export REDMINE_GIT_REPO=git://github.com/edavis10/redmine.git
      export REDMINE_GIT_TAG=2.0.3
      ;;
  cp) export PATH_TO_INSTALL=./vendor/plugins
      export GENERATE_SECRET=generate_session_store
      export MIGRATE_PLUGINS=db:migrate:plugins
      export REDMINE_GIT_REPO=http://github.com/chiliproject/chiliproject.git
      export REDMINE_GIT_TAG=v3.1.0
      ;;
esac

export BUNDLE_GEMFILE=$PATH_TO_REDMINE/Gemfile

clone_redmine()
{
  set -e # exit if clone fails
  git clone -b master --depth=2000 --quiet $REDMINE_GIT_REPO $PATH_TO_REDMINE
  cd $PATH_TO_REDMINE
  git checkout $REDMINE_GIT_TAG
}

run_tests()
{
  # exit if tests fail
  set -e

  cd $PATH_TO_REDMINE

  bash $PATH_TO_TESTER

}

uninstall()
{
  set -e # exit if migrate fails
  cd $PATH_TO_REDMINE
  # clean up database
  bundle exec rake $MIGRATE_PLUGINS NAME=$NAME_OF_PLUGIN VERSION=0 RAILS_ENV=test
  bundle exec rake $MIGRATE_PLUGINS NAME=$NAME_OF_PLUGIN VERSION=0 RAILS_ENV=development
}

run_install()
{
# exit if install fails
set -e

# cd to redmine folder
cd $PATH_TO_REDMINE
echo current directory is `pwd`

# create a link to the backlogs plugin
ln -sf $PATH_TO_PLUGIN $PATH_TO_INSTALL/$NAME_OF_PLUGIN

# copy Gemfile.local for development & test
cp $TESTSPACE/Gemfile.local .

# install gems
mkdir -p vendor/bundle
bundle install --path vendor/bundle

# copy database.yml
cp $TESTSPACE/database.yml config/

if [[ $REDMINE_VER == 2 ]]
then
    rails plugin install git://github.com/pullmonkey/open_flash_chart.git
else
    $PATH_TO_REDMINE/script/plugin install git://github.com/pullmonkey/open_flash_chart.git
fi

# run redmine database migrations
bundle exec rake db:migrate RAILS_ENV=test --trace
bundle exec rake db:migrate RAILS_ENV=development --trace

# install redmine database
bundle exec rake redmine:load_default_data REDMINE_LANG=en RAILS_ENV=development

# generate session store/secret token
bundle exec rake $GENERATE_SECRET

# run backlogs database migrations
bundle exec rake $MIGRATE_PLUGINS RAILS_ENV=test
bundle exec rake $MIGRATE_PLUGINS RAILS_ENV=development
}

while getopts :ictu opt
do case "$opt" in
  i)  run_install;  exit 0;;
  c)  clone_redmine; exit 0;;
  t)  run_tests;  exit 0;;
  u)  uninstall;  exit 0;;
  [?]) echo "i: install; c: clone redmine; t: run tests; u: uninstall";;
  esac
done
