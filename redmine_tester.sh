#!/bin/bash

# create a link to cucumber features
#ln -sf $PATH_TO_INSTALL/$NAME_OF_PLUGIN/features/ .
ln -sf $PATH_TO_INSTALL/$NAME_OF_PLUGIN/spec/ .

mkdir -p coverage
ln -sf `pwd`/coverage $TESTSPACE

# patch fixtures
#bundle exec rake redmine:backlogs:prepare_fixtures

# run rspec
if [ ${REDMINE_VER} = "1.4.5" ]; then
    bundle exec spec:rcov --color --format nested
else
    bundle exec rspec spec --color --format doc
fi
#bundle exec rake redmine:plugins:test

# run cucumber
#if [ ! -n "${CUCUMBER_FLAGS}" ];
#then
#    export CUCUMBER_FLAGS="--format progress"
#fi
#bundle exec cucumber $CUCUMBER_FLAGS features
