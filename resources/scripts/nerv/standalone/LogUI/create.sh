#!/usr/bin/env bash

function create() {
    if [ -f $APP_PID ]; then
        $APP stop  || return $?
    fi
    tar -xf $PKG_FILE -C $root
    if [ $? -ne "0" ]; then
        echo {\"error\":\"tar -xf ${PKG_FILE}\"}
        return 1
    fi

    local os=$(uname)
    tar -xf ../../pkg/kibana-$elk_version-$os-x86_64.tar.gz -C $APP_ROOT
    if [ $? -ne "0" ]; then
        echo {\"error\":\"tar -xf $pkg_root/kibana-$elk_version-$os-x86_64.tar.gz -C $APP_ROOT\"}
        return 1
    fi
}

if [ "$pkg_url" == "" ]; then
    echo {\"error\":\"pkg_url is empty\"}
    exit 1
elif [ "$root" == ""  ]; then
    echo {\"error\":\"root is empty\"}
    exit 1
else
    APP_ROOT=$root$node_name
    APP_PID=APP_ROOT/log/app.pid
    APP=$APP_ROOT/bin/app
    PKG_FILE=$pkg_url

    create
fi

