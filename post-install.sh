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

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm
rvm install ruby-1.9.3-p551

echo "chown this file /usr/local/bin/scripts/si.sh to your new user"
echo "now run this to play around..."
echo "install test test test test"
exec bash
