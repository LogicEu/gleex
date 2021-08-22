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
    -Iinclude/
)

lib=(
    -Llib/
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
    # -mmacos-version-min=10.9
)

fail_op() {
    echo "Run with -d to build dynamically, or -s to build statically." && exit
}

fail_os() {
    echo "OS is not supported yet..." && exit
}

mac_dlib() {
    $cc ${flags[*]} ${inc[*]} ${mac[*]} ${lib[*]} -dynamiclib $src -o $name.dylib &&\
    install_name_tool -id @executable_path/$name.dylib $name.dylib 
}

linux_dlib() {
    $cc -shared ${flags[*]} ${inc[*]} ${lib[*]} ${linux[*]} -fPIC $src -o $name.so 
}

dlib() {
    if echo "$OSTYPE" | grep -q "darwin"; then
        mac_dlib
    elif echo "$OSTYPE" | grep -q "linux"; then
        linux_dlib
    else
        fails_os
    fi
}

slib() {
    $cc ${flags[*]} ${inc[*]} -c $src && ar -crv $name.a *.o && rm *.o
}

build_lib() {
    pushd $1/ && ./build.sh $2 && mv *.a ../lib/ && popd
}

build() {
    mkdir lib/
    build_lib glee -s
    build_lib imgtool -slib
}

clean() {
    rm -r lib/
}

case "$1" in
    "-d")
        dlib;;
    "-s")
        slib;;
    "-build")
        build;;
    "-clean")
        clean;;
    *)
        fail_op;;
esac
