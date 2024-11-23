#!/bin/bash

runuser -u mongod -- /usr/local/bin/runner server &
runuser -u code -- /code-server/bin/code-server --bind-addr 0.0.0.0:8080 --auth none /home/code/workspace &
wait