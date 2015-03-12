#!/usr/bin/env bash

# we install in gitolite home directory
INSTALLDIR=~

# where gitolite repo located
GITOLITE_REPO=~/repositories

# some free port for cordova meteor build
MOCK_PORT=9333

APP_DIR=/webapp

cache_dir() {
    local user=$1
    user="${user:-$USER}"
    echo "$APP_DIR/$user/cache"
}

apps_dir() {
    local user=$1
    user="${user:-$USER}"
    echo "$APP_DIR/$user/apps"
}

indent() {
    sed -u 's/^/       /'
}

info() {
    sed -u 's/^/-----> /'
}

task() {
    sed -u 's/^/=====> /'
}

repo_directory() {
    local REPO=$1 
    
    echo $GITOLITE_REPO/$REPO.git
}
