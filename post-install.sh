#!/bin/bash

composer global require drush/drush:7.*
echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> $HOME/.bashrc

##add to .bashrc
##--------------------------
echo export EDITOR=nano >> $HOME/.bashrc
echo PATH='$HOME/.composer/vendor/bin:$PATH' >> $HOME/.bashrc
echo 'alias install="/usr/local/bin/scripts/si.sh"' >> $HOME/.bashrc
echo export PATH >> $HOME/.bashrc
source $HOME/.bashrc

drush dl drush_recipes -y
drush dl drush_cleanup -y
drush dl registry_rebuild -y
