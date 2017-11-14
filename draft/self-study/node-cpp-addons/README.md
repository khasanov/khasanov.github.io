C++ Addons
==========

https://nodejs.org/dist/latest-v8.x/docs/api/addons.html

## V8 API
https://v8docs.nodesource.com
https://developers.google.com/v8/


## Hello, world
$ npm install node-gyp
$ node ./node_modules/node-gyp/bin/node-gyp.js configure
$ node ./node_modules/node-gyp/bin/node-gyp.js build
$ file build/Release/addon.node
build/Release/addon.node: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, not stripped
$ node hello.js
world
