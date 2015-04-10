#!node_modules/LiveScript/bin/lsc
# Server for testing the web application.
# Known to run on Node v0.10.20

connect = require "connect"
staticFiles = require "serve-static"

connect()
 .use staticFiles "test"
 .listen 3000

