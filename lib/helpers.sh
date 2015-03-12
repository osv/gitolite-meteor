#!/usr/bin/env bash

# we install in gitolite home directory
INSTALLDIR=~

# where gitolite repo located
GITOLITE_REPO=~/repositories

# some free port for cordova meteor build
MOCK_PORT=9333

CACHEDIR=/tmp/cache

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
