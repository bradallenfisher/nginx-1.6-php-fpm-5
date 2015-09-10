#!/bin/bash

composer global require drush/drush:7.*
echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc
