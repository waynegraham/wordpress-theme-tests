#! /usr/bin/env bash

# Wordpress test setup for Travis CI
# Based on Benjamin J. Bailter (ben@balter.com | ben.balter.com)
# License: GPL3

export WP_CORE_DIR=/tmp/wordpress

echo "WP_CORE_DIR: $WP_CORE_DIR"
mkdir -p $WP_CORE_DIR

sudo apt-get clean
sudo apt-get update
sudo apt-get install apach2 libapache2-mod-php5 php5-mysql
sudo a2enmod rewrite php5

sudo cp -f build/travis-ci-apache /etc/apache2/sites-available/default
sudo sed -e "s?%TRAVIS_BUILD_DIR%?$($WP_CORE_DIR)?g" --in-place /etc/apache2/sites-available/default

echo `more /etc/apache2/sites-available/default`

sudo service apache2 restart

# set up database
mysql -e 'CREATE DATABASE wordpress_test;' -uroot

# Download Wordpress
wget -nv -O /tmp/wordpress.tar.gz https://github.com/WordPress/WordPress/tarball/$WP_VERSION
tar --strip-components=1 -zxmf /tmp/wordpress.tar.gz -C $WP_CORE_DIR

# Grab a working wp-config
wget -nv -O $WP_CORE_DIR/wp-config.php https://raw.githubusercontent.com/waynegraham/wordpress-theme-tests/master/setup/wp-tests-config.php

# put components in their proper directories
theme_slug=$(basename $(pwd))
theme_dir=$WP_CORE_DIR/wp-content/themes/$theme_slug

echo "Theme slug: $theme_slug"
echo "Theme dir: $theme_dir"

cd ../
mv $theme_slug $theme_dir

cd $theme_dir

echo "theme dir at end: $theme_dir"
echo "theme_dir files: `ls $theme_dir`"

