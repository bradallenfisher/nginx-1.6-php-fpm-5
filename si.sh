#!/bin/bash

# Directories
##########################################################
httpDir="/var/www/html/"
rootDir="$1/"
libraries="sites/all/libraries/"
modules="sites/all/modules/"
files="sites/default/files/"
##########################################################

# Site
##########################################################
siteName="$2"
siteSlogan="$3"
##########################################################

# Database
##########################################################
dbHost="localhost"
dbName="$4"
dbUser="root"
dbPassword=""
dbsu="root" # root user
dbsupw="" # using yes
##########################################################

# Admin
##########################################################
AdminUsername="admin"
AdminPassword="admin"
adminEmail="admin@admin.com"
##########################################################

# Paths
##########################################################
WGET_PATH="$(which wget)"
UNZIP="$(which unzip)"
TAR="$(which tar)"
##########################################################
sudo chown -R vagrant:vagrant /var/www/html
# Download Core
##########################################################
cd $httpDir

if [[ -d "$httpDir$rootDir" ]]
  then
  sudo rm $rootDir -rf
fi

drush dl -y --destination=$httpDir --drupal-project-rename=$rootDir

echo "cleaning up ...... removing text files"
cd $httpDir$rootDir

echo "$PWD"

# Install core
##########################################################
drush site-install -y standard --account-mail=$adminEmail --account-name=$AdminUsername --db-su=$dbsu --db-su-pw=$dbsupw --account-pass=$AdminPassword --site-name=$siteName --site-mail=$adminEmail --db-url=mysql://$dbUser:$dbPassword@$dbHost/$dbName
drush cleanup
echo "creating module directories"
mkdir $httpDir$rootDir$modules\contrib
mkdir $httpDir$rootDir$modules\custom

# Disable some core modules
##########################################################
drush -y dis color toolbar shortcut dashboard overlay help
cd $httpDir$rootDir

# Enable modules
###########################################################################
drush -y en admin_menu admin_menu_toolbar context_ui field_group fitvids globalredirect googleanalytics httprl libraries link metatag module_filter page_title pathauto redirect search404 token transliteration xmlsitemap

# Pre configure settings
###########################################################################
# Set Site Slogan
drush vset -y site_slogan "$siteSlogan"

# Disable user pictures
drush vset -y user_pictures 0

# Allow only admins to register users
drush vset -y user_register 0

# Remove require user email verification
drush vset -y user_email_verification 0

# Create file locations
cd $httpDir$rootDir
mkdir $files\private
mkdir $files\tmp
cd $httpDir$rootDir$files
sudo chown nginx:nginx tmp
sudo chmod 775 tmp

# Change file destinations
drush vset -y file_private_path "sites/default/files/private"
drush vset -y file_temporary_path "sites/default/files/tmp"

# Change ownership of new files locations.
sudo chown -R nginx:nginx $httpDir$rootDir$files
sudo chmod -R 775 $httpDir$rootDir$files

# Set the site name using the variable in top of script
drush vset -y site_name "$siteName"

###########################################################################

echo -e "////////////////////////////////////////////////////"
echo -e "Install Completed"
echo -e "////////////////////////////////////////////////////"

echo "$PWD"

drush -y pm-disable bartik
drush -y pm-uninstall color
drush -y pm-uninstall dashboard
drush -y pm-uninstall help
drush -y pm-uninstall overlay
drush -y pm-uninstall shortcut
drush -y pm-uninstall toolbar
drush -y pm-disable block
drush -y pm-uninstall block
drush -y pm-enable block
drush cook d7adminux -y
drush en devel -y
drush cc all
