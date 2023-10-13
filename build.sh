#!/bin/bash

cc=gcc
src=src/*.c
name=libgleex

flags=(
    -std=c99
    -Wall
    -Wextra
    -O2
)

inc=(
    -I.
    -Iinclude
)

lib=(
    -Llib
    -lglfw
    -lfreetype
    -lz
    -lpng
    -ljpeg
    -lglee
    -limgtool
)

linux=(
    -lGL
    -lGLEW
)

mac=(
    -Wl,-all_load
    -framework OpenGL
)

shared() {
    if echo "$OSTYPE" | grep -q "darwin"; then
        $cc ${flags[*]} ${inc[*]} ${mac[*]} ${lib[*]} -dynamiclib $src -o $name.dylib
    elif echo "$OSTYPE" | grep -q "linux"; then
        $cc -shared ${flags[*]} ${inc[*]} ${lib[*]} ${linux[*]} -fPIC $src -o $name.so 
    else
        echo "This OS is not supported yet..."
    fi
}

static() {
    $cc ${flags[*]} ${inc[*]} -c $src && ar -cr $name.a *.o && rm *.o
}

build_lib() {
    pushd $1/ && ./build.sh $2 && mv *.a ../lib/ && popd
}

build() {
    mkdir lib/
    build_lib glee static
    build_lib imgtool static
}

cleanf() {
    [ -f $1 ] && rm $1 && echo "deleted $1"
}

clean() {
    [ -d lib ] && rm -r lib && echo "deleted lib"
    cleanf $name.a
    cleanf $name.so
    cleanf $name.dylib
    return 0
}

install() {
    [ "$EUID" -ne 0 ] && echo "Run with 'sudo' to install" && exit

    static && build && shared
    cp gleex.h /usr/local/include/

    [ -f $name.a ] && mv $name.a /usr/local/lib
    [ -f $name.so ] && mv $name.so /usr/local/lib
    [ -f $name.dylib ] && mv $name.dylib /usr/local/lib

    echo "Successfully installed $name"
    return 0
}   

uninstall() {
    [ "$EUID" -ne 0 ] && echo "Run with 'sudo' to uninstall" && exit

    cleanf /usr/local/include/glee.h
    cleanf /usr/local/lib/$name.a
    cleanf /usr/local/lib/$name.so
    cleanf /usr/local/lib/$name.dylib

    echo "Successfully uninstalled $name"
    return 0
}

case "$1" in
    "static")
        static;;
    "shared")
        shared;;
    "build")
        build;;
    "all")
        static && build && shared;;
    "clean")
        clean;;
    "install")
        install;;
    "uninstall")
        uninstall;;
    *)
        echo "Use 'static' or 'shared' to build"
        echo "Use 'install' to install in /usr/local/"
        echo "Use 'clean' to remove local builds";;
esac
