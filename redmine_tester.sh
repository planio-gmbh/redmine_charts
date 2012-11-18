#!/bin/bash

git clone git://github.com/pullmonkey/open_flash_chart.git $PATH_TO_INSTALL/open_flash_chart
mkdir -p public/plugin_assets/open_flash_chart
cp -r $PATH_TO_INSTALL/open_flash_chart/assets/* public/plugin_assets/open_flash_chart/

# create a link to cucumber features
ln -sf $PATH_TO_PLUGIN/features/ .
ln -sf $PATH_TO_PLUGIN/spec/ .

mkdir -p coverage
ln -sf `pwd`/coverage $TESTSPACE

# patch fixtures
#bundle exec rake redmine:backlogs:prepare_fixtures

# run rspec
bundle exec rake spec
bundle exec rake redmine:plugins:test

# run cucumber
#if [ ! -n "${CUCUMBER_FLAGS}" ];
#then
#    export CUCUMBER_FLAGS="--format progress"
#fi
#bundle exec cucumber $CUCUMBER_FLAGS features
