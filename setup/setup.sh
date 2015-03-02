#! /usr/bin/env bash

# Wordpress test setup for Travis CI
# Based on Benjamin J. Bailter (ben@balter.com | ben.balter.com)
# License: GPL3

export WP_CORE_DIR=/tmp/wordpress

mysql -e 'CREATE DATABASE wordpress_test;' -uroot

wget -nv -O /tmp/wordpress.tar.gz https://github.com/WordPress/WordPress/tarball/$WP_VERSION
mkdir -p $WP_CORE_DIR
tar --strip-components=1 -zxmf /tmp/wordpress.tar.gz -C $WP_CORE_DIR


