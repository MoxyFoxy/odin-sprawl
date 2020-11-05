#!/bin/bash

odin build . -define:CCOMPAT=true -build-mode:shared -out:bin/libsprawlc -keep-temp-files
ld bin/libsprawlc.o -shared -o bin/libsprawlc.so -init "___\$shared_runtime"
sudo mv bin/libsprawlc.so /usr/local/lib
cd c
gcc -L. test.c sprawlc.c -lsprawlc
./a.out