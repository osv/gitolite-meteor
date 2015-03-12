#!/usr/bin/env bash

setTemporaryPlatforms() {
    cp ./.meteor/platforms ./.meteor/platforms-copy
    echo server$'\n'browser$'\n'firefoxos > ./.meteor/platforms
}

setOriginalPlatforms() {
    mv ./.meteor/platforms-copy ./.meteor/platforms
}

buildMeteorApp() {
    local APP=$1
    pwd | indent
    meteor build --directory $APP
}

buildMeteorAppForCordova() {
    local APP=$1
    # when building for cordova, we are using firefoxos
    # and it does not need ios and android deps to build web.cordova
    # so it's possible to build for the server bundle inside a build box as well

    setTemporaryPlatforms
    trap setOriginalPlatforms EXIT
    # we need to give it a dummy --server values to start building
    meteor build --directory $APP --server "http://localhost:$MOCK_PORT"
}

##
# node-gyp
##

gyp_rebuild_inside_node_modules () {
    local NODE_BIN=$1

    for npmModule in ./*; do
        cd $npmModule

        isBinaryModule="no"
        # recursively rebuild npm modules inside node_modules
        check_for_binary_modules () {
            if [ -f binding.gyp ]; then
                isBinaryModule="yes"
            fi

            if [ $isBinaryModule != "yes" ]; then
                if [ -d ./node_modules ]; then
                    cd ./node_modules
                    for module in ./*; do
                        cd $module
                        check_for_binary_modules
                        cd ..
                    done
                    cd ../
                fi
            fi
        }

        check_for_binary_modules

        if [ $isBinaryModule == "yes" ]; then
            echo "node-gyp: $npmModule: npm install due to binary npm modules" | indent
            rm -rf node_modules
            if [ -f binding.gyp ]; then
                $NODE_BIN/node-gyp rebuild || :
                $NODE_BIN/npm install
            else
                $NODE_BIN/npm install
            fi
        fi

        cd ..
    done
}

rebuild_binary_npm_modules () {
    local NODE_BIN=$1

    for package in ./*; do
        if [ -d $package/node_modules ]; then
            cd $package/node_modules
            gyp_rebuild_inside_node_modules $NODE_BIN
            cd ../../
        elif [ -d $package/main/node_module ]; then
            cd $package/node_modules
            gyp_rebuild_inside_node_modules $NODE_BIN
            cd ../../../
        fi
    done
}

